from __future__ import annotations

import json
import logging
import shutil
import threading
from concurrent.futures import Future, ThreadPoolExecutor
from dataclasses import dataclass
from datetime import date, datetime, timedelta
from pathlib import Path
from typing import Any

import pandas as pd

from app.config import settings
from app.db import get_db

logger = logging.getLogger(__name__)


@dataclass
class ModelMeta:
    code: str
    trained_until: date
    trained_at: datetime
    row_count: int


_executor = ThreadPoolExecutor(max_workers=settings.sync_max_workers)
_locks: dict[str, threading.Lock] = {}
_futures: dict[str, Future[None]] = {}
_locks_guard = threading.Lock()
_prophet_ready = False


def _lock_for(code: str) -> threading.Lock:
    with _locks_guard:
        lock = _locks.get(code)
        if lock is None:
            lock = threading.Lock()
            _locks[code] = lock
        return lock


def ensure_model_dir() -> Path:
    model_dir = Path(settings.model_dir)
    model_dir.mkdir(parents=True, exist_ok=True)
    return model_dir


def _ensure_prophet_ready() -> None:
    """Ensure Prophet can load a Stan backend.

    On Windows, the PyPI `prophet` wheel sometimes contains an incomplete bundled
    CmdStan directory (missing `makefile`), which makes `cmdstanpy.set_cmdstan_path`
    fail and causes Prophet initialization to break.

    Workaround: if the bundled directory exists but is incomplete, prevent Prophet
    from trying to use it so cmdstanpy falls back to the user's installed CmdStan.
    """

    global _prophet_ready
    if _prophet_ready:
        return

    try:
        import importlib.resources as importlib_resources
        import prophet.models as prophet_models

        stan_model_dir = Path(str(importlib_resources.files("prophet") / "stan_model"))

        # Ensure required runtime DLL is discoverable on Windows.
        # `prophet_model.bin` imports `tbb.dll` but the wheel may place it deep under
        # a bundled cmdstan directory, which Windows won't search by default.
        tbb_target = stan_model_dir / "tbb.dll"
        if not tbb_target.exists():
            candidates = [p for p in stan_model_dir.rglob("tbb.dll") if p != tbb_target]
            if candidates:
                shutil.copyfile(candidates[0], tbb_target)

        version = getattr(prophet_models.CmdStanPyBackend, "CMDSTAN_VERSION", None)
        if version:
            local_cmdstan_traversable = (
                importlib_resources.files("prophet")
                / "stan_model"
                / f"cmdstan-{version}"
            )
            local_cmdstan = Path(str(local_cmdstan_traversable))

            makefile = local_cmdstan / "makefile"
            if local_cmdstan.exists() and not makefile.exists():
                # Disable bundled cmdstan usage by pointing to a non-existent version.
                prophet_models.CmdStanPyBackend.CMDSTAN_VERSION = "disabled"
    except Exception:
        # If anything goes wrong here, let Prophet try its normal behavior.
        pass

    _prophet_ready = True


def _model_paths(code: str) -> tuple[Path, Path]:
    model_dir = ensure_model_dir() / code
    model_dir.mkdir(parents=True, exist_ok=True)
    return model_dir / "model.json", model_dir / "meta.json"


def _db_max_date(code: str) -> date | None:
    db = get_db()
    with db.pool.connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT MAX(date) FROM historical_stocks_data WHERE code = %s",
                (code,),
            )
            row = cur.fetchone()
            if not row or row[0] is None:
                return None
            return row[0]


def _load_series(code: str) -> pd.DataFrame:
    db = get_db()
    with db.pool.connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT date, close FROM historical_stocks_data WHERE code = %s AND close IS NOT NULL ORDER BY date ASC",
                (code,),
            )
            rows = cur.fetchall()

    if not rows:
        return pd.DataFrame(columns=["ds", "y"])

    df = pd.DataFrame(rows, columns=["ds", "y"])
    df["ds"] = pd.to_datetime(df["ds"])
    df["y"] = pd.to_numeric(df["y"], errors="coerce")
    df = df.dropna(subset=["ds", "y"]).sort_values("ds")
    df = df.drop_duplicates(subset=["ds"], keep="last")
    return df


def _read_meta(code: str) -> ModelMeta | None:
    _, meta_path = _model_paths(code)
    if not meta_path.exists():
        return None
    data = json.loads(meta_path.read_text(encoding="utf-8"))
    return ModelMeta(
        code=code,
        trained_until=date.fromisoformat(data["trained_until"]),
        trained_at=datetime.fromisoformat(data["trained_at"]),
        row_count=int(data.get("row_count", 0)),
    )


def _write_meta(meta: ModelMeta) -> None:
    _, meta_path = _model_paths(meta.code)
    meta_path.write_text(
        json.dumps(
            {
                "code": meta.code,
                "trained_until": meta.trained_until.isoformat(),
                "trained_at": meta.trained_at.isoformat(),
                "row_count": meta.row_count,
            },
            ensure_ascii=False,
        ),
        encoding="utf-8",
    )


def _load_model(code: str) -> Prophet | None:
    _ensure_prophet_ready()
    from prophet.serialize import model_from_json

    model_path, _ = _model_paths(code)
    if not model_path.exists():
        return None
    return model_from_json(model_path.read_text(encoding="utf-8"))


def _save_model(code: str, model: Prophet) -> None:
    _ensure_prophet_ready()
    from prophet.serialize import model_to_json

    model_path, _ = _model_paths(code)
    model_path.write_text(model_to_json(model), encoding="utf-8")


def train_model(code: str) -> None:
    _ensure_prophet_ready()
    from prophet import Prophet

    logger.info(f"[TRAIN_START] Training model for code={code}")
    df = _load_series(code)
    if df.empty or len(df) < 2:
        logger.error(f"[TRAIN_ERROR] Not enough data for code={code}, rows={len(df)}")
        raise ValueError(f"Not enough data to train model for code={code}")

    logger.info(f"[TRAIN_DATA] code={code}, historical_data_points={len(df)}, date_range={df['ds'].min()}_to_{df['ds'].max()}")

    model = Prophet(
        interval_width=settings.interval_width,
        yearly_seasonality=True,
        weekly_seasonality=True,
        daily_seasonality=False,
    )
    model.fit(df)

    trained_until = df["ds"].max().date()
    _save_model(code, model)
    _write_meta(
        ModelMeta(
            code=code,
            trained_until=trained_until,
            trained_at=datetime.utcnow(),
            row_count=len(df),
        )
    )
    logger.info(f"[TRAIN_DONE] Model trained for code={code}, trained_until={trained_until}")


def _train_model_locked(code: str) -> None:
    lock = _lock_for(code)
    with lock:
        train_model(code)


def ensure_trained(code: str) -> None:
    lock = _lock_for(code)
    with lock:
        meta = _read_meta(code)
        db_max = _db_max_date(code)

        if db_max is None:
            raise ValueError(f"No historical data found for code={code}")

        if meta is not None and meta.trained_until >= db_max:
            return

        train_model(code)


def schedule_training(code: str) -> None:
    lock = _lock_for(code)
    with lock:
        existing = _futures.get(code)
        if existing and not existing.done():
            return
        # Avoid unnecessary retraining: only train if DB has newer data.
        # `ensure_trained()` is lock-safe (it takes the per-code lock itself).
        _futures[code] = _executor.submit(ensure_trained, code)


def list_codes() -> list[str]:
    db = get_db()
    with db.pool.connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT DISTINCT code FROM company WHERE code IS NOT NULL ORDER BY code ASC")
            return [r[0] for r in cur.fetchall() if r and r[0]]


def _is_bd_trading_day(d: date) -> bool:
    # Bangladesh stock market trading days are typically Sunday-Thursday.
    # Python weekday(): Mon=0 ... Sun=6
    return d.weekday() in (6, 0, 1, 2, 3)


def _next_bd_trading_days(start: date, n: int) -> list[pd.Timestamp]:
    out: list[pd.Timestamp] = []
    d = start
    while len(out) < n:
        d = d + timedelta(days=1)
        if _is_bd_trading_day(d):
            out.append(pd.Timestamp(d))
    return out


def forecast_next_days(code: str) -> list[dict[str, Any]]:
    logger.info(f"[FORECAST_START] code={code}")
    ensure_trained(code)
    model = _load_model(code)
    if model is None:
        logger.error(f"[FORECAST_ERROR] Model missing after training for code={code}")
        raise RuntimeError(f"Model missing after training for code={code}")

    # Forecast next N Bangladesh trading days (Sun-Thu), skipping Fri/Sat.
    last_observed = _db_max_date(code)
    if last_observed is None:
        logger.error(f"[FORECAST_ERROR] No historical data found for code={code}")
        raise ValueError(f"No historical data found for code={code}")
    
    logger.info(f"[FORECAST_DATA] code={code}, last_observed={last_observed}, forecast_days={settings.forecast_days}")
    future = pd.DataFrame({"ds": _next_bd_trading_days(last_observed, settings.forecast_days)})
    forecast = model.predict(future)

    # Output: list of predictions with code/date/high/low/close
    # Defensive: ensure unique dates (some downstream consumers assume one row per day).
    out: list[dict[str, Any]] = []
    seen_dates: set[str] = set()
    for _, row in forecast.iterrows():
        ds = pd.to_datetime(row["ds"]).date().isoformat()
        yhat = float(row["yhat"]) if pd.notna(row["yhat"]) else None
        yhat_lower = float(row["yhat_lower"]) if pd.notna(row["yhat_lower"]) else yhat
        yhat_upper = float(row["yhat_upper"]) if pd.notna(row["yhat_upper"]) else yhat

        if yhat is None:
            continue

        if ds in seen_dates:
            continue
        seen_dates.add(ds)

        out.append(
            {
                "code": code,
                "date": ds,
                "high": yhat_upper,
                "low": yhat_lower,
                "close": yhat,
            }
        )
        logger.info(f"[PREDICTION] code={code}, date={ds}, close={yhat:.2f}, high={yhat_upper:.2f}, low={yhat_lower:.2f}")

    logger.info(f"[FORECAST_DONE] code={code}, predictions_count={len(out)}")
    return out


def get_model_status(code: str) -> dict[str, Any]:
    """Return lightweight diagnostics for a code.

    This is intentionally non-training (no model fit) so it can be used to
    diagnose deployment/config issues (like pointing to the wrong DB).
    """

    code = (code or "").strip()
    if not code:
        raise ValueError("code is required")

    meta = _read_meta(code)
    db_max = _db_max_date(code)

    return {
        "code": code,
        "db_max_date": db_max.isoformat() if db_max else None,
        "model": (
            {
                "trained_until": meta.trained_until.isoformat(),
                "trained_at": meta.trained_at.isoformat(),
                "row_count": meta.row_count,
            }
            if meta
            else None
        ),
    }

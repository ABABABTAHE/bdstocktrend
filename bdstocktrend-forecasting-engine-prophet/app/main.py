from __future__ import annotations

import logging
import time
from fastapi import BackgroundTasks, FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse

logger = logging.getLogger(__name__)
logger.info("Loading app.main module...")

from app.config import settings
logger.info(f"Config loaded. Database: {settings.db_name}, User: {settings.db_user}")

from app.db import close_db, init_db
from app.modeling import forecast_next_days, get_model_status, list_codes, schedule_training

logger.info("All dependencies imported successfully")


app = FastAPI(title=settings.app_name, version=settings.app_version, lifespan=None)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Minimal middleware to detect if requests are even hitting the app
@app.middleware("http")
async def basic_logging(request: Request, call_next):
    logger.info(f"===> REQUEST SECURED BY ASGI: {request.method} {request.url.path}")
    response = await call_next(request)
    logger.info(f"<=== RESPONSE DISPATCHED: {response.status_code}")
    return response


# Removing startup event because ASGIMiddleware + Passenger might hang on it.
# We will lazy-initialize DB instead anyway.

@app.on_event("shutdown")
def _shutdown() -> None:
    logger.info("FastAPI SHUTDOWN EVENT triggered")
    try:
        close_db()
        logger.info("Database closed successfully")
    except Exception:
        logger.exception("Error during database shutdown")


@app.get("/")
def root() -> dict:
    try:
        return {
            "app": settings.app_name,
            "version": settings.app_version,
            "status": "running"
        }
    except Exception as e:
        logger.exception("Error in root endpoint")
        import traceback
        return {
            "error": str(e),
            "type": type(e).__name__,
            "traceback": traceback.format_exc()
        }


@app.get("/health")
def health() -> dict:
    return {
        "status": "ok",
        "app": settings.app_name,
        "version": settings.app_version,
    }


@app.get("/debug")
def debug_endpoint() -> dict:
    """Debug endpoint that shows what's happening"""
    result = {}
    
    # Test 1: Basic response
    result["test_basic"] = "OK"
    
    # Test 2: Settings access
    try:
        result["settings"] = {
            "app_name": settings.app_name,
            "app_version": settings.app_version,
            "db_host": settings.db_host,
            "db_name": settings.db_name,
        }
    except Exception as e:
        result["settings_error"] = str(e)
    
    # Test 3: DB access
    try:
        from app.db import _db
        if _db is None:
            result["db_status"] = "DB not initialized"
        else:
            result["db_status"] = "DB initialized"
            result["db_pool"] = str(_db.pool)
    except Exception as e:
        result["db_error"] = str(e)
    
    # Test 4: Try to import modeling
    try:
        from app.modeling import list_codes
        result["modeling_import"] = "OK"
        #  Try calling list_codes
        try:
            codes = list_codes()
            result["list_codes"] = f"Success: {len(codes)} codes"
        except Exception as e:
            result["list_codes_error"] = str(e)
    except Exception as e:
        result["modeling_error"] = str(e)
    
    return result


@app.get("/sync")
def sync(background_tasks: BackgroundTasks) -> dict:
    """Compatibility endpoint.

    The Java/PHP backends call /sync before looping through /predict/{code}.
    We schedule background model training for all codes, but return immediately.
    """

    try:
        codes = list_codes()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to list codes: {e}")

    for code in codes:
        background_tasks.add_task(schedule_training, code)

    return {"status": "ok", "scheduled": len(codes)}


@app.get("/predict/{code}")
def predict(code: str) -> dict:
    try:
        preds = forecast_next_days(code)
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    return {"predictions": preds}


@app.get("/meta/{code}")
def meta(code: str) -> dict:
    """Lightweight diagnostics for a single code.

    Useful to verify the engine is connected to the expected DB and that the
    model is trained up to the latest historical date.
    """

    try:
        status = get_model_status(code)
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    return {
        "engine": {
            "app": settings.app_name,
            "version": settings.app_version,
            "db_host": settings.db_host,
            "db_name": settings.db_name,
        },
        "status": status,
    }

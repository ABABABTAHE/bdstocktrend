import 'package:bd_stock_trend/common/model/time_series.dart';
import 'package:bd_stock_trend/features/companies/domain/entities/company_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_details_response.freezed.dart';
part 'company_details_response.g.dart';

@freezed
class CompanyDetailsResponse with _$CompanyDetailsResponse {
  const factory CompanyDetailsResponse({
    ScripDetailsInfoData? info,
    List<TimeSeriesData>? last30Days,
    List<TimeSeriesData>? next30Days,
    ForecastMetaData? forecastMeta,
  }) = _CompanyDetailsResponse;

  const CompanyDetailsResponse._();

  factory CompanyDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$CompanyDetailsResponseFromJson(json);

  CompanyDetails toEntity() {
    final last30DaysList = (last30Days ?? const <TimeSeriesData>[])
        .map<TimeSeries>(
          (model) => TimeSeries(
            time: model.time ?? DateTime.now(),
            value: model.value ?? 0.0,
          ),
        )
        .toList();

    final next30DaysList = (next30Days ?? const <TimeSeriesData>[])
        .map<TimeSeries>(
          (model) => TimeSeries(
            time: model.time ?? DateTime.now(),
            value: model.value ?? 0.0,
          ),
        )
        .toList();

    return CompanyDetails(
      info: info!.toEntity(),
      last30Days: last30DaysList,
      next30Days: next30DaysList,
      forecastMeta: forecastMeta?.toEntity(),
    );
  }
}

@freezed
class ForecastMetaData with _$ForecastMetaData {
  const factory ForecastMetaData({
    double? intervalWidth,
    double? confidenceLevel,
    String? disclaimer,
  }) = _ForecastMetaData;

  const ForecastMetaData._();

  factory ForecastMetaData.fromJson(Map<String, dynamic> json) =>
      _$ForecastMetaDataFromJson(json);

  ForecastMeta toEntity() {
    return ForecastMeta(
      intervalWidth: intervalWidth,
      confidenceLevel: confidenceLevel,
      disclaimer: disclaimer,
    );
  }
}

@freezed
class TimeSeriesData with _$TimeSeriesData {
  const factory TimeSeriesData({
    DateTime? time,
    double? value,
  }) = _TimeSeriesData;

  factory TimeSeriesData.fromJson(Map<String, dynamic> json) =>
      _$TimeSeriesDataFromJson(json);
}

@freezed
class ScripDetailsInfoData with _$ScripDetailsInfoData {
  const factory ScripDetailsInfoData({
    required String Scrip,
    required String FullName,
    required double LastTrade,
    required double Volume,
    required double ClosePrice,
    required double Week1Close,
    required double Week52Close,
    required String Week52Range,
    required double OpenPrice,
    required double YCP,
    required double MarketCap,
    required double DaysValue,
    required String LastUpdate,
    required String Change,
    required double TotalTrade,
    required double AuthorizedCap,
    required double PaidUpCap,
    required double TotalSecurities,
    required String LastAGMHeld,
    required double ReserveSurplus,
    required int ListingYear,
    required String MarketCategory,
    required String Electronic,
    required String ShareHoldingPercentage,
    required double SponsorDirector,
    required double Govt,
    required double Institute,
    required double Foreign,
    required double Public,
    required String ShareHoldingPercentage1,
    required double SponsorDirector1,
    required double Govt1,
    required double Institute1,
    required double Foreign1,
    required double Public1,
    required String ShareHoldingPercentage2,
    required double SponsorDirector2,
    required double Govt2,
    required double Institute2,
    required double Foreign2,
    required double Public2,
    required String PresentOs,
    required String PresentLs,
    required int ShortLoan,
    required int LongLoan,
    String? LatestDividendStatus,
    required String Address,
    required String Contact,
    required String Email,
    required String Web,
    String? Rating,
    required double ChangePer,
    required String DayRange,
    required double EPS,
    required double AuditedPE,
    required double UnAuditedPE,
    required double Q1Eps,
    required double Q2Eps,
    required double Q3Eps,
    required double Q4Eps,
    required double NAV,
    required double NavPrice,
    required double freefloat,
    required String YE,
    required double DividentYield,
    required String news1stdate,
    required String news1sttitle,
    required String news1stbody,
    required String news2stdate,
    required String news2sttitle,
    required String news2stbody,
    required String news3stdate,
    required String news3sttitle,
    required String news3stbody,
    required String news4stdate,
    required String news4sttitle,
    required String news4stbody,
    required String news5stdate,
    required String news5sttitle,
    required String news5stbody,
    required String ma10,
    required String ma20,
    required String ma50,
    required String ma100,
    required String ma200,
    required String maAVG,
    required String ema10,
    required String ema20,
    required String ema50,
    required String ema100,
    required String ema200,
    required String emaAVG,
    required String stockBeta,
  }) = _ScripDetailsInfoData;

  const ScripDetailsInfoData._();

  factory ScripDetailsInfoData.fromJson(Map<String, dynamic> json) =>
      _$ScripDetailsInfoDataFromJson(json);

  ScripDetailsInfo toEntity() {
    return ScripDetailsInfo(
      scrip: Scrip,
      fullName: FullName,
      lastTrade: LastTrade,
      volume: Volume,
      closePrice: ClosePrice,
      week1Close: Week1Close,
      week52Close: Week52Close,
      week52Range: Week52Range,
      openPrice: OpenPrice,
      ycp: YCP,
      marketCap: MarketCap,
      daysValue: DaysValue,
      lastUpdate: LastUpdate,
      change: Change,
      totalTrade: TotalTrade,
      authorizedCap: AuthorizedCap,
      paidUpCap: PaidUpCap,
      totalSecurities: TotalSecurities,
      lastAGMHeld: LastAGMHeld,
      reserveSurplus: ReserveSurplus,
      listingYear: ListingYear,
      marketCategory: MarketCategory,
      electronic: Electronic,
      shareHoldingPercentage: ShareHoldingPercentage,
      sponsorDirector: SponsorDirector,
      govt: Govt,
      institute: Institute,
      foreign: Foreign,
      public: Public,
      shareHoldingPercentage1: ShareHoldingPercentage1,
      sponsorDirector1: SponsorDirector1,
      govt1: Govt1,
      institute1: Institute1,
      foreign1: Foreign1,
      public1: Public1,
      shareHoldingPercentage2: ShareHoldingPercentage2,
      sponsorDirector2: SponsorDirector2,
      govt2: Govt2,
      institute2: Institute2,
      foreign2: Foreign2,
      public2: Public2,
      presentOs: PresentOs,
      presentLs: PresentLs,
      shortLoan: ShortLoan,
      longLoan: LongLoan,
      latestDividendStatus: LatestDividendStatus,
      address: Address,
      contact: Contact,
      email: Email,
      web: Web,
      rating: Rating,
      changePer: ChangePer,
      dayRange: DayRange,
      eps: EPS,
      auditedPE: AuditedPE,
      unAuditedPE: UnAuditedPE,
      q1Eps: Q1Eps,
      q2Eps: Q2Eps,
      q3Eps: Q3Eps,
      q4Eps: Q4Eps,
      nav: NAV,
      navPrice: NavPrice,
      freefloat: freefloat,
      ye: YE,
      dividendYield: DividentYield,
      news1stdate: news1stdate,
      news1sttitle: news1sttitle,
      news1stbody: news1stbody,
      news2stdate: news2stdate,
      news2sttitle: news2sttitle,
      news2stbody: news2stbody,
      news3stdate: news3stdate,
      news3sttitle: news3sttitle,
      news3stbody: news3stbody,
      news4stdate: news4stdate,
      news4sttitle: news4sttitle,
      news4stbody: news4stbody,
      news5stdate: news5stdate,
      news5sttitle: news5sttitle,
      news5stbody: news5stbody,
      ma10: ma10,
      ma20: ma20,
      ma50: ma50,
      ma100: ma100,
      ma200: ma200,
      maAVG: maAVG,
      ema10: ema10,
      ema20: ema20,
      ema50: ema50,
      ema100: ema100,
      ema200: ema200,
      emaAVG: emaAVG,
      stockBeta: stockBeta,
    );
  }
}

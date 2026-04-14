import 'package:bd_stock_trend/core/core.dart';
import 'package:bd_stock_trend/features/companies/domain/entities/company_details.dart';
import 'package:bd_stock_trend/features/companies/domain/repositories/companies_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_company_details.freezed.dart';
part 'get_company_details.g.dart';

class GetCompanyDetails extends UseCase<CompanyDetails, CompanyParams> {
  final CompaniesRepository _repo;

  GetCompanyDetails(this._repo);

  @override
  Future<Either<Failure, CompanyDetails>> call(CompanyParams params) =>
      _repo.companyDetails(params);
}

@freezed
class CompanyParams with _$CompanyParams {
  const factory CompanyParams({required String code}) = _CompanyParams;

  factory CompanyParams.fromJson(Map<String, dynamic> json) =>
      _$CompanyParamsFromJson(json);
}

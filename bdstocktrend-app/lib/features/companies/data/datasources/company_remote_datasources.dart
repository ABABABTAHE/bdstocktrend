import 'package:bd_stock_trend/core/core.dart';
import 'package:bd_stock_trend/features/companies/data/models/companies_response.dart';
import 'package:bd_stock_trend/features/companies/domain/usecases/get_companies.dart';
import 'package:bd_stock_trend/features/companies/domain/usecases/get_company_details.dart';
import 'package:dartz/dartz.dart';

import '../models/company_details_response.dart';

abstract class CompaniesRemoteDatasource {
  Future<Either<Failure, CompaniesResponse>> companies(UsersParams userParams);

  Future<Either<Failure, CompanyDetailsResponse>> companyDetails(
      CompanyParams params);
}

class CompaniesRemoteDatasourceImpl implements CompaniesRemoteDatasource {
  final DioClient _client;

  CompaniesRemoteDatasourceImpl(this._client);

  @override
  Future<Either<Failure, CompaniesResponse>> companies(
      UsersParams userParams) async {
    final response = await _client.getRequest(
      ListAPI.companies,
      queryParameters: userParams.toJson(),
      converter: (response) =>
          CompaniesResponse.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }

  @override
  Future<Either<Failure, CompanyDetailsResponse>> companyDetails(
      CompanyParams params) async {
    final response = await _client.getRequest(
      Uri.encodeFull('${ListAPI.companies}/${params.code}'),
      converter: (response) =>
          CompanyDetailsResponse.fromJson(response as Map<String, dynamic>),
    );

    return response;
  }
}

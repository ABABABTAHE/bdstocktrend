import 'package:bd_stock_trend/core/core.dart';
import 'package:bd_stock_trend/features/companies/domain/entities/company_details.dart';
import 'package:bd_stock_trend/features/companies/domain/usecases/get_company_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_details_state.dart';
part 'company_details_cubit.freezed.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsState> {
  final GetCompanyDetails _getCompanyDetails;

  CompanyDetailsCubit(this._getCompanyDetails) : super(const _Loading());

  Future<void> refreshDashboardData(String code) async {
    await fetchCompanyDetails(code);
  }

  Future<void> fetchCompanyDetails(String code) async {
    emit(const _Loading());
    final data = await _getCompanyDetails.call(CompanyParams(code: code));

    data.fold(
      (failure) => emit(_Failure(_failureMessage(failure))),
      (result) => emit(_Success(result)),
    );
  }

  String _failureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? '';
    }
    if (failure is NoDataFailure) {
      return 'No data found';
    }
    if (failure is CacheFailure) {
      return 'Cache error';
    }
    return 'Something went wrong';
  }
}

import 'package:bd_stock_trend/features/features.dart';
import 'package:flutter/cupertino.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  AuthRepository,
  AuthRemoteDatasource,
  CompaniesRepository,
  CompaniesRemoteDatasource,
])
@GenerateNiceMocks([MockSpec<BuildContext>()])
void main() {}

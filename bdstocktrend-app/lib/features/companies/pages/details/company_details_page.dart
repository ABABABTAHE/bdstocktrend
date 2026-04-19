import 'package:bd_stock_trend/common/widget/line_chart_sample3.dart';
import 'package:bd_stock_trend/common/widget/line_chart_sample4.dart';
import 'package:bd_stock_trend/core/resources/styles.dart';
import 'package:bd_stock_trend/core/widgets/widgets.dart';
import 'package:bd_stock_trend/features/companies/domain/entities/company_details.dart';
import 'package:bd_stock_trend/features/companies/pages/details/cubit/company_details_cubit.dart';
import 'package:bd_stock_trend/features/general/pages/main/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'company_info.dart';

class CompanyDetailsPage extends StatefulWidget {
  final String code;

  const CompanyDetailsPage({super.key, required this.code});

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MainCubit>().updateTitle(widget.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      child: BlocBuilder<CompanyDetailsCubit, CompanyDetailsState>(
        builder: (_, state) {
          return state.when(
            loading: () => const Center(child: Loading()),
            success: (data) => _success(data),
            failure: (message) => Center(child: Empty(errorMessage: message)),
          );
        },
      ),
    );
  }

  Widget _success(CompanyDetails data) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    // Keep charts a bit more compact; users can pinch-zoom inside the chart.
    final chartHeight = (screenWidth * 0.72).clamp(280.0, 420.0);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              labelColor: Theme.of(context).extension<LzyctColors>()!.pink,
              indicatorColor: Theme.of(context).extension<LzyctColors>()!.pink,
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Forecasting'),
              ],
            ),
            SizedBox(
              height: chartHeight,
              width: double.infinity,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  if (data.last30Days.isNotEmpty)
                    LineChartSample3(data: data.last30Days)
                  else
                    const Align(
                      alignment: Alignment.center,
                      child: Text('No data available'),
                    ),
                  if (data.next30Days.isNotEmpty)
                    LineChartSample4(
                      data1: data.last30Days,
                      data2: data.next30Days,
                    )
                  else
                    const Align(
                      alignment: Alignment.center,
                      child: Text('Forecast not available'),
                    ),
                ],
              ),
            ),
            const SpacerV(value: 12),
            CompanyInfo(info: data.info),
            const SpacerV(value: 12),
          ],
        ),
      ),
    );
  }
}

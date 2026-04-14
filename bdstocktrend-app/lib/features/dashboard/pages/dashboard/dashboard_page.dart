import 'package:bd_stock_trend/common/widget/line_chart_sample2.dart';
import 'package:bd_stock_trend/common/widget/pie_chart_sample.dart';
import 'package:bd_stock_trend/core/core.dart';
import 'package:bd_stock_trend/features/dashboard/domain/entities/dashboard.dart';
import 'package:bd_stock_trend/features/dashboard/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:bd_stock_trend/utils/services/hive/main_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin, MainBoxMixin {
  late TabController _tabController1;
  late TabController _tabController2;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (!(getData(MainBoxKeys.roles) as List).contains('ROLE_PREMIUM_USER')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPremiumSubscriptionModal(context);
      });
    }

    _tabController1 = TabController(length: 3, vsync: this);
    _tabController2 = TabController(length: 5, vsync: this);
    _scrollController.addListener(() async {
      /*if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (_currentPage < _lastPage) {
            _currentPage++;
            await context
                .read<UsersCubit>()
                .fetchUsers(UsersParams(page: _currentPage));
          }
        }
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      child: RefreshIndicator(
        color: Theme.of(context).extension<LzyctColors>()!.pink,
        backgroundColor: Theme.of(context).extension<LzyctColors>()!.background,
        onRefresh: () {

          return context.read<DashboardCubit>().refreshDashboardData();
        },
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (_, state) {
            return state.when(
              loading: () => const Center(child: Loading()),
              success: (data) => _success(data),
              failure: (message) => Center(child: Empty(errorMessage: message)),
            );
          },
        ),
      ),
    );
  }

  Widget _success(Dashboard data) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.space12, vertical: Dimens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // DSE Header Card
          // DSE Header Card
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radiusLarge)),
              elevation: 4,
              shadowColor: Palette.primary.withOpacity(0.3),
              child: InkWell(
                onTap: () {
                  context.pushNamed(Routes.dhakaStockExchange.name);
                },
                borderRadius: BorderRadius.circular(Dimens.radiusLarge),
                child: Container(
                  padding: EdgeInsets.all(Dimens.space16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.radiusLarge),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).cardColor,
                        Palette.primary.withOpacity(0.05)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: BoxDecoration(
                          color: Palette.primary.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(Dimens.radiusMedium),
                          boxShadow: [
                            BoxShadow(
                              color: Palette.primary.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.analytics_rounded,
                            color: Palette.primary, size: 28),
                      ),
                      const SpacerH(value: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dhaka Stock Exchange",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SpacerV(value: 4),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    size: 14, color: Palette.subText),
                                const SpacerH(value: 4),
                                Flexible(
                                  child: Text(
                                    "Last Update: ${data.lastUpdateTime}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 16, color: Palette.subText),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SpacerV(value: 24),

          // Indices Chart Section
          Card(
            child: Column(
              children: [
                TabBar(
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.normal),
                  labelColor: Palette.primary,
                  indicatorColor: Palette.primary,
                  dividerColor: Colors.transparent,
                  controller: _tabController1,
                  tabs: const [
                    Tab(text: "DSEX"),
                    Tab(text: "DSES"),
                    Tab(text: "DS30"),
                  ],
                ),
                SizedBox(
                  height: 250.h,
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    controller: _tabController1,
                    children: [
                      LineChartSample2(data: data.dseX),
                      LineChartSample2(data: data.dseS),
                      LineChartSample2(data: data.ds30),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpacerV(value: 24),

          // Market Pulse (Winner VS Loser)
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimens.space16),
                  child: Text(
                    "Market Pulse",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                PieChartSample2(dseInfo: data.dseInfo),
                const SpacerV(value: 12),
              ],
            ),
          ),
          const SpacerV(value: 24),

          // Top Companies Section
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimens.space16),
                  child: Text(
                    "Top Companies",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                TabBar(
                  labelColor: Palette.primary,
                  indicatorColor: Palette.primary,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  controller: _tabController2,
                  tabs: const [
                    Tab(text: "Value"),
                    Tab(text: "Gainer"),
                    Tab(text: "Loser"),
                    Tab(text: "Volume"),
                    Tab(text: "Trade"),
                  ],
                ),
                SizedBox(
                  height: 400.h,
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    controller: _tabController2,
                    children: [
                      _buildTopList(data.topCompaniesByCategory.value),
                      _buildTopList(data.topCompaniesByCategory.gainar),
                      _buildTopList(data.topCompaniesByCategory.loser),
                      _buildTopList(data.topCompaniesByCategory.volume),
                      _buildTopList(data.topCompaniesByCategory.trade),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpacerV(value: 40),
        ],
      ),
    );
  }

  Widget _buildTopList(List<ScripInfo> scrips) {
    return ListView.separated(
      padding: EdgeInsets.all(Dimens.space16),
      itemCount: scrips.length,
      separatorBuilder: (_, __) =>
          Divider(color: Palette.divider.withOpacity(0.5)),
      itemBuilder: (context, index) {
        final scrip = scrips[index];
        final bool isPositive = scrip.ChangePer >= 0;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.space4),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scrip.Scrip,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Volume: ${scrip.Value}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  "${scrip.LTP}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.end,
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isPositive ? Palette.success : Palette.error)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "${scrip.ChangePer}%",
                    style: TextStyle(
                      color: isPositive ? Palette.success : Palette.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showPremiumSubscriptionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Premium Subscription'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Unlock premium features!'),
                SizedBox(height: 16),
                Text('Benefits include:'),
                SizedBox(height: 8),
                Text(
                    '- Advanced Stock Forecasting for over 400 companies, powered by state-of-the-art predictive models.'),
                SizedBox(height: 8),
                Text(
                    '- Historical Data Visualization with interactive charts to help you analyze trends and patterns.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Subscribe Now'),
              onPressed: () {
                Navigator.of(context).pop();

                context.goNamed(Routes.payment.name);
              },
            ),
          ],
        );
      },
    );
  }
}

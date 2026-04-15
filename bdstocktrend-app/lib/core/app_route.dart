import 'package:bd_stock_trend/dependencies_injection.dart';
import 'package:bd_stock_trend/features/auth/pages/payment.dart';
import 'package:bd_stock_trend/features/companies/pages/details/company_details_page.dart';
import 'package:bd_stock_trend/features/companies/pages/details/cubit/company_details_cubit.dart';
import 'package:bd_stock_trend/features/dashboard/pages/dse/dhaka_stock_exchange_page.dart';
import 'package:bd_stock_trend/features/features.dart';
import 'package:bd_stock_trend/features/settings/pages/change_password/change_password_page.dart';
import 'package:bd_stock_trend/features/settings/pages/edit_profile/edit_profile_page.dart';
import 'package:bd_stock_trend/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  root("/"),
  splashScreen("/splashscreen"),

  /// Home Page
  dashboard("/dashboard"),
  payment("/payment"),
  companies("/companies"),
  companyDetails("/company-details/:code"),
  settings("/settings"),

  // Auth Page
  login("/auth/login"),
  register("/auth/register"),

  // New Features
  dhakaStockExchange("/dhaka-stock-exchange"),
  editProfile("/settings/edit-profile"),
  changePassword("/settings/change-password"),
  ;

  const Routes(this.path);

  final String path;
}

class AppRoute {
  static late BuildContext context;

  AppRoute.setStream(BuildContext ctx) {
    context = ctx;
  }

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: Routes.splashScreen.path,
        name: Routes.splashScreen.name,
        builder: (_, __) => SplashScreenPage(),
      ),
      GoRoute(
        path: Routes.root.path,
        name: Routes.root.name,
        redirect: (_, __) => Routes.dashboard.path,
      ),
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.register.path,
        name: Routes.register.name,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<RegisterCubit>(),
          child: const RegisterPage(),
        ),
      ),
      ShellRoute(
        builder: (_, __, child) => BlocProvider(
          create: (context) => sl<MainCubit>(),
          child: MainPage(child: child),
        ),
        routes: [
          GoRoute(
            path: Routes.dashboard.path,
            name: Routes.dashboard.name,
            builder: (_, __) => BlocProvider(
              create: (_) => sl<DashboardCubit>()..fetchDashboardData(),
              child: const DashboardPage(),
            ),
          ),
          GoRoute(
            path: Routes.payment.path,
            name: Routes.payment.name,
            builder: (_, __) => BlocProvider(
              create: (_) => sl<DashboardCubit>()..fetchDashboardData(),
              child: Payment(),
            ),
          ),
          GoRoute(
            path: Routes.companies.path,
            name: Routes.companies.name,
            builder: (_, __) => BlocProvider(
              create: (_) =>
                  sl<CompanyListCubit>()..fetchCompanies(const UsersParams()),
              child: const CompanyListPage(),
            ),
          ),
          GoRoute(
            path: Routes.companyDetails.path,
            name: Routes.companyDetails.name,
            builder: (context, state) => BlocProvider(
              create: (context) => sl<CompanyDetailsCubit>()
                ..fetchCompanyDetails(state.pathParameters['code'] ?? ''),
              child: CompanyDetailsPage(
                code: state.pathParameters['code'] ?? '',
              ),
            ),
          ),
          GoRoute(
            path: Routes.settings.path,
            name: Routes.settings.name,
            builder: (_, __) => const SettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.dhakaStockExchange.path,
        name: Routes.dhakaStockExchange.name,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<DashboardCubit>()..fetchDashboardData(),
          child: const DhakaStockExchangePage(),
        ),
      ),
      GoRoute(
        path: Routes.editProfile.path,
        name: Routes.editProfile.name,
        builder: (_, __) => const EditProfilePage(),
      ),
      GoRoute(
        path: Routes.changePassword.path,
        name: Routes.changePassword.name,
        builder: (_, __) => const ChangePasswordPage(),
      ),
    ],
    initialLocation: Routes.splashScreen.path,
    routerNeglect: true,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: GoRouterRefreshStream(context.read<AuthCubit>().stream),
    redirect: (_, GoRouterState state) {
      final bool isLoginPage = state.matchedLocation == Routes.login.path ||
          state.matchedLocation == Routes.register.path;

      ///  Check if not login
      ///  if current page is login page we don't need to direct user
      ///  but if not we must direct user to login page
      if (!((MainBoxMixin.mainBox?.get(MainBoxKeys.isLogin.name) as bool?) ??
          false)) {
        return isLoginPage ? null : Routes.login.path;
      }

      /// Check if already login and in login page
      /// we should direct user to main page

      if (isLoginPage &&
          ((MainBoxMixin.mainBox?.get(MainBoxKeys.isLogin.name) as bool?) ??
              false)) {
        return Routes.root.path;
      }

      /// No direct
      return null;
    },
  );
}

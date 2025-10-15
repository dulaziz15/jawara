import 'package:auto_route/auto_route.dart';
import 'package:jawara/presentation/pages/auth/login_page.dart';
import 'package:jawara/presentation/pages/auth/register_page.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_overview.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_reports.dart';
import 'package:jawara/presentation/pages/penerimaanWarga/penerimaan.dart';
import 'package:jawara/presentation/pages/penerimaanWarga/penerimaanWarga.dart';
import 'package:jawara/presentation/pages/pesanWarga/aspirasi.dart';
import 'package:jawara/presentation/pages/pesanWarga/pesanWarga.dart';
import 'package:jawara/presentation/pages/report/report.dart';
import 'package:jawara/presentation/pages/report/report_finance.dart';
import 'package:jawara/presentation/pages/setting/setting_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
 @override
 final routes = [
 AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
 AutoRoute(page: RegisterRoute.page, path: '/register'),
 AutoRoute(page: DashboardRoute.page, path: '/dashboard', children: [
 AutoRoute(page: DashboardOverviewRoute.page, path: 'overview'),
 AutoRoute(page: DashboardReportsRoute.page, path: 'reports'),
 AutoRoute(page: SettingsRoute.page, path: 'settings'),
]),
 AutoRoute(page: ReportRoute.page, path: '/report', children: [
 AutoRoute(page: ReportFinanceRoute.page, path: 'finance'),
 ]),
 AutoRoute(page: PesanWargaRoute.page, path: '/pesanWarga', children: [
 AutoRoute(page: AspirasiRoute.page, path: 'aspirasi'),
 ]),
 AutoRoute(page: PenerimaanWargaRoute.page, path: '/penerimaanWarga', children: [
 AutoRoute(page: PenerimaanRoute.page, path: 'penerimaan'),
 ]),
];
}
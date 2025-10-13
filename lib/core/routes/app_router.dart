import 'package:auto_route/auto_route.dart';
import 'package:jawara/presentation/pages/auth/login_page.dart';
import 'package:jawara/presentation/pages/auth/register_page.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kependudukan.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_keuangan.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kegiatan.dart';
import 'package:jawara/presentation/pages/report/report.dart';
import 'package:jawara/presentation/pages/report/report_finance.dart';
import 'package:jawara/presentation/pages/setting/setting_page.dart';
import 'package:jawara/presentation/pages/warga/daftar_warga.dart';
import 'package:jawara/presentation/pages/warga/keluarga.dart';
import 'package:jawara/presentation/pages/warga/tambah_warga.dart';
import 'package:jawara/presentation/pages/warga/warga.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  final routes = [
    AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: DashboardRoute.page, path: '/dashboard', children: [
      AutoRoute(page: DashboardKeuanganRoute.page, path: 'keuangan'),
      AutoRoute(page: DashboardKegiatanRoute.page, path: 'kegiatan'),
      AutoRoute(page: DashboardKependudukanRoute.page, path: 'kependudukan'),
    ]),
    AutoRoute(page: ReportRoute.page, path: '/report', children: [
      AutoRoute(page: ReportFinanceRoute.page, path: 'finance'),
    ]),
    AutoRoute(page: WargaRoute.page, path: '/warga', children: [
      AutoRoute(page: WargaDaftarRoute.page, path: 'daftar'),
      AutoRoute(page: WargaTambahRoute.page, path: 'tambah'),
    ]),
    AutoRoute(page: KeluargaRoute.page, path: '/keluarga'),
  ];
}

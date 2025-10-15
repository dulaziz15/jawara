import 'package:auto_route/auto_route.dart';
import 'package:jawara/presentation/pages/auth/login_page.dart';
import 'package:jawara/presentation/pages/auth/register_page.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kegiatan.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kependudukan.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_dan_broadcast.dart';
import 'package:jawara/presentation/pages/laporan/laporan.dart';
import 'package:jawara/presentation/pages/penerimaanWarga/penerimaanWarga.dart';
import 'package:jawara/presentation/pages/pengeluaran/pengeluaran.dart';
import 'package:jawara/presentation/pages/pesanWarga/aspirasi.dart';
import 'package:jawara/presentation/pages/pesanWarga/pesanWarga.dart';
import 'package:jawara/presentation/pages/report/report.dart';
import 'package:jawara/presentation/pages/report/report_finance.dart';

// Tambahan import (buat rute sesuai sidebar)
// import 'package:jawara/presentation/pages/dashboard/dashboard_keuangan.dart';
// import 'package:jawara/presentation/pages/dashboard/dashboard_kegiatan.dart';
// import 'package:jawara/presentation/pages/dashboard/dashboard_kependudukan.dart';

// import 'package:jawara/presentation/pages/warga/warga_daftar.dart';
// import 'package:jawara/presentation/pages/warga/warga_tambah.dart';
// import 'package:jawara/presentation/pages/warga/keluarga_page.dart';
// import 'package:jawara/presentation/pages/rumah/rumah_daftar.dart';
// import 'package:jawara/presentation/pages/rumah/rumah_tambah.dart';

// import 'package:jawara/presentation/pages/pemasukan/pemasukan_kategori.dart';
// import 'package:jawara/presentation/pages/pemasukan/pemasukan_tagih.dart';
// import 'package:jawara/presentation/pages/pemasukan/pemasukan_tagihan.dart';
// import 'package:jawara/presentation/pages/pemasukan/pemasukan_lain_daftar.dart';
// import 'package:jawara/presentation/pages/pemasukan/pemasukan_lain_tambah.dart';

import 'package:jawara/presentation/pages/pengeluaran/pengeluaran_daftar.dart';
import 'package:jawara/presentation/pages/pengeluaran/pengeluaran_tambah.dart';

import 'package:jawara/presentation/pages/laporan/laporan_pemasukan.dart';
import 'package:jawara/presentation/pages/laporan/laporan_pengeluaran.dart';
import 'package:jawara/presentation/pages/laporan/laporan_cetak.dart';

import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_daftar.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_tambah.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_daftar.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_masuk.dart';
import 'package:jawara/presentation/pages/setting/setting_page.dart';

// import 'package:jawara/presentation/pages/pesan/pesan_informasi.dart';
// import 'package:jawara/presentation/pages/penerimaan/penerimaan_daftar.dart';
// import 'package:jawara/presentation/pages/mutasi/mutasi_daftar.dart';
// import 'package:jawara/presentation/pages/mutasi/mutasi_tambah.dart';

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
      AutoRoute(page: DashboardOverviewRoute.page, path: 'overview'),
      AutoRoute(page: DashboardReportsRoute.page, path: 'reports'),
      AutoRoute(page: SettingsRoute.page, path: 'settings'),
    ]),
    AutoRoute(page: ReportRoute.page, path: '/report', children: [
      AutoRoute(page: ReportFinanceRoute.page, path: 'finance'),
    ]),
  ];
}
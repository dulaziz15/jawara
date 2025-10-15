// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    // === Kegiatan dan broadcast ===
    KegiatanDanBroadcastRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KegiatanDanBroadcastPage(),
      );
    },
    BroadcastDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BroadcastDaftarPage(),
      );
    },
    BroadcastMasukRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BroadcastMasukPage(),
      );
    },
    KegiatanDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KegiatanDaftarPage(),
      );
    },
    KegiatanTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KegiatanTambahPage(),
      );
    },
    // ==== Dashboard ===
    DashboardKegiatanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DashboardKegiatanPage(),
      );
    },
    DashboardKependudukanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardKependudukanPage(),
      );
    },
    DashboardKeuanganRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DashboardKeuanganPage(),
      );
    },

    // === Warga ===
    KeluargaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KeluargaPage(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    ReportFinanceRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ReportFinancePage(),
      );
    },
    ReportRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ReportPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    WargaDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WargaDaftarPage(),
      );
    },
    WargaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WargaPage(),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },

    // === Laporan Keuangan ===
    LaporanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LaporanPage(),
      );
    },
    LaporanCetakRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LaporanCetakPage(),
      );
    },
    LaporanPemasukanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LaporanPemasukanPage(),
      );
    },
    LaporanPengeluaranRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LaporanPengeluaranPage(),
      );
    },
    // === Auth ===
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },

    // === Pengeluaran ===
    PengeluaranRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PengeluaranPage(),
      );
    },
    PengeluaranDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PengeluaranDaftarPage(),
      );
    },
    PengeluaranTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PengeluaranTambahPage(),
      );
    },
    WargaTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WargaTambahPage(),
      );
    }
  };
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

  
/// generated route for
/// [BroadcastDaftarRoute]
class BroadcastDaftarRoute extends PageRouteInfo<void> {
  const BroadcastDaftarRoute({List<PageRouteInfo>? children})
      : super(
          BroadcastDaftarRoute.name,
          initialChildren: children,
        );

  static const String name = 'BroadcastDaftarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BroadcastMasukRoute]
class BroadcastMasukRoute extends PageRouteInfo<void> {
  const BroadcastMasukRoute({List<PageRouteInfo>? children})
      : super(
          BroadcastMasukRoute.name,
          initialChildren: children,
        );

  static const String name = 'BroadcastMasukRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChannelDaftarRoute]
class ChannelDaftarRoute extends PageRouteInfo<void> {
  const ChannelDaftarRoute({List<PageRouteInfo>? children})
      : super(
          ChannelDaftarRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChannelDaftarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChannelTambahRoute]
class ChannelTambahRoute extends PageRouteInfo<void> {
  const ChannelTambahRoute({List<PageRouteInfo>? children})
      : super(
          ChannelTambahRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChannelTambahRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardKegiatanPage]
class DashboardKegiatanRoute extends PageRouteInfo<void> {
  const DashboardKegiatanRoute({List<PageRouteInfo>? children})
      : super(
          DashboardKegiatanRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardKegiatanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardKependudukanPage]
class DashboardKependudukanRoute extends PageRouteInfo<void> {
  const DashboardKependudukanRoute({List<PageRouteInfo>? children})
      : super(
          DashboardKependudukanRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardKependudukanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardKeuanganPage]
class DashboardKeuanganRoute extends PageRouteInfo<void> {
  const DashboardKeuanganRoute({List<PageRouteInfo>? children})
      : super(
          DashboardKeuanganRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardKeuanganRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BroadcastdanKegiatanPage]
class KegiatanDanBroadcastRoute extends PageRouteInfo<void> {
  const KegiatanDanBroadcastRoute({List<PageRouteInfo>? children})
      : super(
          KegiatanDanBroadcastRoute.name,
          initialChildren: children,
        );

  static const String name = 'KegiatanDanBroadcastRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [KeluargaPage]
class KeluargaRoute extends PageRouteInfo<void> {
  const KeluargaRoute({List<PageRouteInfo>? children})
      : super(
          KeluargaRoute.name,
          initialChildren: children,
        );

  static const String name = 'KeluargaRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ReportFinancePage]
class ReportFinanceRoute extends PageRouteInfo<void> {
  const ReportFinanceRoute({List<PageRouteInfo>? children})
      : super(
          ReportFinanceRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReportFinanceRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ReportPage]
class ReportRoute extends PageRouteInfo<void> {
  const ReportRoute({List<PageRouteInfo>? children})
      : super(
          ReportRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReportRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WargaDaftarPage]
class WargaDaftarRoute extends PageRouteInfo<void> {
  const WargaDaftarRoute({List<PageRouteInfo>? children})
      : super(
          WargaDaftarRoute.name,
          initialChildren: children,
        );

  static const String name = 'WargaDaftarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WargaPage]
class WargaRoute extends PageRouteInfo<void> {
  const WargaRoute({List<PageRouteInfo>? children})
      : super(
          WargaRoute.name,
          initialChildren: children,
        );

  static const String name = 'WargaRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WargaTambahPage]
class WargaTambahRoute extends PageRouteInfo<void> {
  const WargaTambahRoute({List<PageRouteInfo>? children})
      : super(
          WargaTambahRoute.name,
          initialChildren: children,
        );  static const String name = 'DashboardReportsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [KegiatanDaftarRoute]
class KegiatanDaftarRoute extends PageRouteInfo<void> {
  const KegiatanDaftarRoute({List<PageRouteInfo>? children})
      : super(
          KegiatanDaftarRoute.name,
          initialChildren: children,
        );

  static const String name = 'KegiatanDaftarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [KegiatanTambahRoute]
class KegiatanTambahRoute extends PageRouteInfo<void> {
  const KegiatanTambahRoute({List<PageRouteInfo>? children})
      : super(
          KegiatanTambahRoute.name,
          initialChildren: children,
        );

  static const String name = 'KegiatanTambahRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LaporanPage]
class LaporanRoute extends PageRouteInfo<void> {
  const LaporanRoute({List<PageRouteInfo>? children})
      : super(
          LaporanRoute.name,
          initialChildren: children,
        );

  static const String name = 'LaporanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LaporanCetakPage]
class LaporanCetakRoute extends PageRouteInfo<void> {
  const LaporanCetakRoute({List<PageRouteInfo>? children})
      : super(
          LaporanCetakRoute.name,
          initialChildren: children,
        );

  static const String name = 'LaporanCetakRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LaporanPemasukanPage]
class LaporanPemasukanRoute extends PageRouteInfo<void> {
  const LaporanPemasukanRoute({List<PageRouteInfo>? children})
      : super(
          LaporanPemasukanRoute.name,
          initialChildren: children,
        );

  static const String name = 'LaporanPemasukanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LaporanPengeluaranPage]
class LaporanPengeluaranRoute extends PageRouteInfo<void> {
  const LaporanPengeluaranRoute({List<PageRouteInfo>? children})
      : super(
          LaporanPengeluaranRoute.name,
          initialChildren: children,
        );

  static const String name = 'LaporanPengeluaranRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PengeluaranRoute]
class PengeluaranRoute extends PageRouteInfo<void> {
  const PengeluaranRoute({List<PageRouteInfo>? children})
      : super(
          PengeluaranRoute.name,
          initialChildren: children,
        );

  static const String name = 'PengeluaranRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}


/// generated route for
/// [PengeluaranDaftarRoute]
class PengeluaranDaftarRoute extends PageRouteInfo<void> {
  const PengeluaranDaftarRoute({List<PageRouteInfo>? children})
      : super(
          PengeluaranDaftarRoute.name,
          initialChildren: children,
        );

  static const String name = 'PengeluaranDaftarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PengeluaranTambahRoute]
class PengeluaranTambahRoute extends PageRouteInfo<void> {
  const PengeluaranTambahRoute({List<PageRouteInfo>? children})
      : super(
          PengeluaranTambahRoute.name,
          initialChildren: children,
        );

  static const String name = 'PengeluaranTambahRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PenggunaDaftarRoute]
class PenggunaDaftarRoute extends PageRouteInfo<void> {
  const PenggunaDaftarRoute({List<PageRouteInfo>? children})
      : super(
          PenggunaDaftarRoute.name,
          initialChildren: children,
        );

  static const String name = 'PenggunaDaftarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PenggunaTambahRoute]
class PenggunaTambahRoute extends PageRouteInfo<void> {
  const PenggunaTambahRoute({List<PageRouteInfo>? children})
      : super(
          PenggunaTambahRoute.name,
          initialChildren: children,
        );

  static const String name = 'PenggunaTambahRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [Report]
class Report extends PageRouteInfo<void> {
  const Report({List<PageRouteInfo>? children})
      : super(
          Report.name,
          initialChildren: children,
        );

  static const String name = 'Report';

  static const PageInfo<void> page = PageInfo<void>(name);
}


/// generated route for
/// [SemuaAktivitasRoute]
class SemuaAktivitasRoute extends PageRouteInfo<void> {
  const SemuaAktivitasRoute({List<PageRouteInfo>? children})
      : super(
          SemuaAktivitasRoute.name,
          initialChildren: children,
        );

  static const String name = 'SemuaAktivitasRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}



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
    AspirasiRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AspirasiPage(),
      );
    },
    BroadcastDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BroadcastDaftarPage(),
      );
    },
    BroadcastTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BroadcastTambahPage(),
      );
    },
    DashboardKegiatanRoute.name: (routeData) {
      final args = routeData.argsAs<DashboardKegiatanRouteArgs>(
          orElse: () => const DashboardKegiatanRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DashboardKegiatanPage(key: args.key),
      );
    },
    DashboardKependudukanRoute.name: (routeData) {
      final args = routeData.argsAs<DashboardKependudukanRouteArgs>(
          orElse: () => const DashboardKependudukanRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DashboardKependudukanPage(key: args.key),
      );
    },
    DashboardKeuanganRoute.name: (routeData) {
      final args = routeData.argsAs<DashboardKeuanganRouteArgs>(
          orElse: () => const DashboardKeuanganRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DashboardKeuanganPage(key: args.key),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
    KegiatanDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KegiatanDaftarPage(),
      );
    },
    KegiatanDanBroadcastRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KegiatanDanBroadcastPage(),
      );
    },
    KegiatanTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KegiatanTambahPage(),
      );
    },
    KeluargaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KeluargaPage(),
      );
    },
    LaporanCetakRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LaporanCetakPage(),
      );
    },
    LaporanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LaporanPage(),
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
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MainDashboardRoute.name: (routeData) {
      final args = routeData.argsAs<MainDashboardRouteArgs>(
          orElse: () => const MainDashboardRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MainDashboardPage(key: args.key),
      );
    },
    PemasukanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PemasukanPage(),
      );
    },
    PenerimaanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PenerimaanPage(),
      );
    },
    PenerimaanWargaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PenerimaanWargaPage(),
      );
    },
    PengeluaranDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PengeluaranDaftarPage(),
      );
    },
    PengeluaranRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PengeluaranPage(),
      );
    },
    PengeluaranTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PengeluaranTambahPage(),
      );
    },
    PesanWargaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PesanWargaPage(),
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
    RumahDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RumahDaftarPage(),
      );
    },
    RumahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RumahPage(),
      );
    },
    RumahTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RumahTambahPage(),
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
    WargaTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WargaTambahPage(),
      );
    },
  };
}

/// generated route for
/// [AspirasiPage]
class AspirasiRoute extends PageRouteInfo<void> {
  const AspirasiRoute({List<PageRouteInfo>? children})
      : super(
          AspirasiRoute.name,
          initialChildren: children,
        );

  static const String name = 'AspirasiRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BroadcastDaftarPage]
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
/// [BroadcastTambahPage]
class BroadcastTambahRoute extends PageRouteInfo<void> {
  const BroadcastTambahRoute({List<PageRouteInfo>? children})
      : super(
          BroadcastTambahRoute.name,
          initialChildren: children,
        );

  static const String name = 'BroadcastTambahRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardKegiatanPage]
class DashboardKegiatanRoute extends PageRouteInfo<DashboardKegiatanRouteArgs> {
  DashboardKegiatanRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          DashboardKegiatanRoute.name,
          args: DashboardKegiatanRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'DashboardKegiatanRoute';

  static const PageInfo<DashboardKegiatanRouteArgs> page =
      PageInfo<DashboardKegiatanRouteArgs>(name);
}

class DashboardKegiatanRouteArgs {
  const DashboardKegiatanRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'DashboardKegiatanRouteArgs{key: $key}';
  }
}

/// generated route for
/// [DashboardKependudukanPage]
class DashboardKependudukanRoute
    extends PageRouteInfo<DashboardKependudukanRouteArgs> {
  DashboardKependudukanRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          DashboardKependudukanRoute.name,
          args: DashboardKependudukanRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'DashboardKependudukanRoute';

  static const PageInfo<DashboardKependudukanRouteArgs> page =
      PageInfo<DashboardKependudukanRouteArgs>(name);
}

class DashboardKependudukanRouteArgs {
  const DashboardKependudukanRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'DashboardKependudukanRouteArgs{key: $key}';
  }
}

/// generated route for
/// [DashboardKeuanganPage]
class DashboardKeuanganRoute extends PageRouteInfo<DashboardKeuanganRouteArgs> {
  DashboardKeuanganRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          DashboardKeuanganRoute.name,
          args: DashboardKeuanganRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'DashboardKeuanganRoute';

  static const PageInfo<DashboardKeuanganRouteArgs> page =
      PageInfo<DashboardKeuanganRouteArgs>(name);
}

class DashboardKeuanganRouteArgs {
  const DashboardKeuanganRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'DashboardKeuanganRouteArgs{key: $key}';
  }
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
/// [KegiatanDaftarPage]
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
/// [KegiatanDanBroadcastPage]
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
/// [KegiatanTambahPage]
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
/// [MainDashboardPage]
class MainDashboardRoute extends PageRouteInfo<MainDashboardRouteArgs> {
  MainDashboardRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          MainDashboardRoute.name,
          args: MainDashboardRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'MainDashboardRoute';

  static const PageInfo<MainDashboardRouteArgs> page =
      PageInfo<MainDashboardRouteArgs>(name);
}

class MainDashboardRouteArgs {
  const MainDashboardRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'MainDashboardRouteArgs{key: $key}';
  }
}

/// generated route for
/// [PemasukanPage]
class PemasukanRoute extends PageRouteInfo<void> {
  const PemasukanRoute({List<PageRouteInfo>? children})
      : super(
          PemasukanRoute.name,
          initialChildren: children,
        );

  static const String name = 'PemasukanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PenerimaanPage]
class PenerimaanRoute extends PageRouteInfo<void> {
  const PenerimaanRoute({List<PageRouteInfo>? children})
      : super(
          PenerimaanRoute.name,
          initialChildren: children,
        );

  static const String name = 'PenerimaanRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PenerimaanWargaPage]
class PenerimaanWargaRoute extends PageRouteInfo<void> {
  const PenerimaanWargaRoute({List<PageRouteInfo>? children})
      : super(
          PenerimaanWargaRoute.name,
          initialChildren: children,
        );

  static const String name = 'PenerimaanWargaRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PengeluaranDaftarPage]
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
/// [PengeluaranPage]
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
/// [PengeluaranTambahPage]
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
/// [PesanWargaPage]
class PesanWargaRoute extends PageRouteInfo<void> {
  const PesanWargaRoute({List<PageRouteInfo>? children})
      : super(
          PesanWargaRoute.name,
          initialChildren: children,
        );

  static const String name = 'PesanWargaRoute';

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
/// [RumahDaftarPage]
class RumahDaftarRoute extends PageRouteInfo<void> {
  const RumahDaftarRoute({List<PageRouteInfo>? children})
      : super(
          RumahDaftarRoute.name,
          initialChildren: children,
        );

  static const String name = 'RumahDaftarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RumahPage]
class RumahRoute extends PageRouteInfo<void> {
  const RumahRoute({List<PageRouteInfo>? children})
      : super(
          RumahRoute.name,
          initialChildren: children,
        );

  static const String name = 'RumahRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RumahTambahPage]
class RumahTambahRoute extends PageRouteInfo<void> {
  const RumahTambahRoute({List<PageRouteInfo>? children})
      : super(
          RumahTambahRoute.name,
          initialChildren: children,
        );

  static const String name = 'RumahTambahRoute';

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
        );

  static const String name = 'WargaTambahRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

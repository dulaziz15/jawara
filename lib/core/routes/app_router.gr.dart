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
    AspirasiEditRoute.name: (routeData) {
      final args = routeData.argsAs<AspirasiEditRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AspirasiEditPage(
          key: args.key,
          aspirasiId: args.aspirasiId,
        ),
      );
    },
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
    BroadcastDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<BroadcastDetailRouteArgs>(
          orElse: () => BroadcastDetailRouteArgs(
              broadcastId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: BroadcastDetailPage(
          key: args.key,
          broadcastId: args.broadcastId,
        ),
      );
    },
    BroadcastEditRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<BroadcastEditRouteArgs>(
          orElse: () =>
              BroadcastEditRouteArgs(broadcastId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: BroadcastEditPage(
          key: args.key,
          broadcastId: args.broadcastId,
        ),
      );
    },
    BroadcastTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BroadcastTambahPage(),
      );
    },
    ChannelDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChannelDaftarPage(),
      );
    },
    ChannelDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ChannelDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChannelDetailPage(
          key: args.key,
          channelId: args.channelId,
        ),
      );
    },
    ChannelEditRoute.name: (routeData) {
      final args = routeData.argsAs<ChannelEditRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChannelEditPage(
          key: args.key,
          channelId: args.channelId,
        ),
      );
    },
    ChannelRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChannelPage(),
      );
    },
    ChannelTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChannelTambahPage(),
      );
    },
    DaftarMutasiRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DaftarMutasiPage(),
      );
    },
    DaftarPenggunaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DaftarPenggunaPage(),
      );
    },
    DaftarWargaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WargaDaftarPage(),
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
    KategoriIuranRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const KategoriIuranPage(),
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
    KegiatanDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<KegiatanDetailRouteArgs>(
          orElse: () =>
              KegiatanDetailRouteArgs(kegiatanId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: KegiatanDetailPage(
          key: args.key,
          kegiatanId: args.kegiatanId,
        ),
      );
    },
    KegiatanEditRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<KegiatanEditRouteArgs>(
          orElse: () =>
              KegiatanEditRouteArgs(kegiatanId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: KegiatanEditPage(
          key: args.key,
          kegiatanId: args.kegiatanId,
        ),
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
    LaporanPemasukanDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LaporanPemasukanDetailRouteArgs>(
          orElse: () => LaporanPemasukanDetailRouteArgs(
              laporanPemasukanId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LaporanPemasukanDetailPage(
          key: args.key,
          laporanPemasukanId: args.laporanPemasukanId,
        ),
      );
    },
    LaporanPemasukanLainDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LaporanPemasukanLainDetailRouteArgs>(
          orElse: () => LaporanPemasukanLainDetailRouteArgs(
              laporanPemasukanId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LaporanPemasukanLainDetailPage(
          key: args.key,
          laporanPemasukanId: args.laporanPemasukanId,
        ),
      );
    },
    LaporanPemasukanRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LaporanPemasukanPage(),
      );
    },
    LaporanPengeluaranDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LaporanPengeluaranDetailRouteArgs>(
          orElse: () => LaporanPengeluaranDetailRouteArgs(
              laporanPengeluaranId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LaporanPengeluaranDetailPage(
          key: args.key,
          laporanPengeluaranId: args.laporanPengeluaranId,
        ),
      );
    },
    LaporanPengeluaranRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LaporanPengeluaranPage(),
      );
    },
    ListAktivitasRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ListAktivitasPage(),
      );
    },
    MachineLearningRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EtnicPredictionPage(),
      );
    },
    LogAktivitasRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LogAktivitasPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MainDashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainDashboardPage(),
      );
    },
    ManajemenPenggunaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ManajemenPenggunaPage(),
      );
    },
    MutasiKeluargaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MutasiKeluargaPage(),
      );
    },
    PemasukanDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PemasukanDaftarPage(),
      );
    },
    PemasukanLainTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PemasukanLainTambahPage(),
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
    PengeluaranDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PengeluaranDetailRouteArgs>(
          orElse: () => PengeluaranDetailRouteArgs(
              pengeluaranId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PengeluaranDetailPage(
          key: args.key,
          pengeluaranId: args.pengeluaranId,
        ),
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
    PenggunaDetailRoute.name: (routeData) {
      final args = routeData.argsAs<PenggunaDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PenggunaDetailPage(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    PenggunaEditRoute.name: (routeData) {
      final args = routeData.argsAs<PenggunaEditRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PenggunaEditPage(
          key: args.key,
          userId: args.userId,
        ),
      );
    },
    PenggunaTambahRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PenggunaTambahPage(),
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
    TagihIuranRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TagihIuranPage(),
      );
    },
    TagihanDaftarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TagihanDaftarPage(),
      );
    },
    TagihanDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TagihanDetailRouteArgs>(
          orElse: () =>
              TagihanDetailRouteArgs(tagihanId: pathParams.getString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TagihanDetailPage(
          key: args.key,
          tagihanId: args.tagihanId,
        ),
      );
    },
    TambahMutasiRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TambahMutasiPage(),
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
/// [AspirasiEditPage]
class AspirasiEditRoute extends PageRouteInfo<AspirasiEditRouteArgs> {
  AspirasiEditRoute({
    Key? key,
    required String aspirasiId,
    List<PageRouteInfo>? children,
  }) : super(
          AspirasiEditRoute.name,
          args: AspirasiEditRouteArgs(
            key: key,
            aspirasiId: aspirasiId,
          ),
          initialChildren: children,
        );

  static const String name = 'AspirasiEditRoute';

  static const PageInfo<AspirasiEditRouteArgs> page =
      PageInfo<AspirasiEditRouteArgs>(name);
}

class AspirasiEditRouteArgs {
  const AspirasiEditRouteArgs({
    this.key,
    required this.aspirasiId,
  });

  final Key? key;

  final String aspirasiId;

  @override
  String toString() {
    return 'AspirasiEditRouteArgs{key: $key, aspirasiId: $aspirasiId}';
  }
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
/// [BroadcastDetailPage]
class BroadcastDetailRoute extends PageRouteInfo<BroadcastDetailRouteArgs> {
  BroadcastDetailRoute({
    Key? key,
    required String broadcastId,
    List<PageRouteInfo>? children,
  }) : super(
          BroadcastDetailRoute.name,
          args: BroadcastDetailRouteArgs(
            key: key,
            broadcastId: broadcastId,
          ),
          rawPathParams: {'id': broadcastId},
          initialChildren: children,
        );

  static const String name = 'BroadcastDetailRoute';

  static const PageInfo<BroadcastDetailRouteArgs> page =
      PageInfo<BroadcastDetailRouteArgs>(name);
}

class BroadcastDetailRouteArgs {
  const BroadcastDetailRouteArgs({
    this.key,
    required this.broadcastId,
  });

  final Key? key;

  final String broadcastId;

  @override
  String toString() {
    return 'BroadcastDetailRouteArgs{key: $key, broadcastId: $broadcastId}';
  }
}

/// generated route for
/// [BroadcastEditPage]
class BroadcastEditRoute extends PageRouteInfo<BroadcastEditRouteArgs> {
  BroadcastEditRoute({
    Key? key,
    required String broadcastId,
    List<PageRouteInfo>? children,
  }) : super(
          BroadcastEditRoute.name,
          args: BroadcastEditRouteArgs(
            key: key,
            broadcastId: broadcastId,
          ),
          rawPathParams: {'id': broadcastId},
          initialChildren: children,
        );

  static const String name = 'BroadcastEditRoute';

  static const PageInfo<BroadcastEditRouteArgs> page =
      PageInfo<BroadcastEditRouteArgs>(name);
}

class BroadcastEditRouteArgs {
  const BroadcastEditRouteArgs({
    this.key,
    required this.broadcastId,
  });

  final Key? key;

  final String broadcastId;

  @override
  String toString() {
    return 'BroadcastEditRouteArgs{key: $key, broadcastId: $broadcastId}';
  }
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
/// [ChannelDaftarPage]
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
/// [ChannelDetailPage]
class ChannelDetailRoute extends PageRouteInfo<ChannelDetailRouteArgs> {
  ChannelDetailRoute({
    Key? key,
    required String channelId,
    List<PageRouteInfo>? children,
  }) : super(
          ChannelDetailRoute.name,
          args: ChannelDetailRouteArgs(
            key: key,
            channelId: channelId,
          ),
          initialChildren: children,
        );

  static const String name = 'ChannelDetailRoute';

  static const PageInfo<ChannelDetailRouteArgs> page =
      PageInfo<ChannelDetailRouteArgs>(name);
}

class ChannelDetailRouteArgs {
  const ChannelDetailRouteArgs({
    this.key,
    required this.channelId,
  });

  final Key? key;

  final String channelId;

  @override
  String toString() {
    return 'ChannelDetailRouteArgs{key: $key, channelId: $channelId}';
  }
}

/// generated route for
/// [ChannelEditPage]
class ChannelEditRoute extends PageRouteInfo<ChannelEditRouteArgs> {
  ChannelEditRoute({
    Key? key,
    required String channelId,
    List<PageRouteInfo>? children,
  }) : super(
          ChannelEditRoute.name,
          args: ChannelEditRouteArgs(
            key: key,
            channelId: channelId,
          ),
          initialChildren: children,
        );

  static const String name = 'ChannelEditRoute';

  static const PageInfo<ChannelEditRouteArgs> page =
      PageInfo<ChannelEditRouteArgs>(name);
}

class ChannelEditRouteArgs {
  const ChannelEditRouteArgs({
    this.key,
    required this.channelId,
  });

  final Key? key;

  final String channelId;

  @override
  String toString() {
    return 'ChannelEditRouteArgs{key: $key, channelId: $channelId}';
  }
}

/// generated route for
/// [ChannelPage]
class ChannelRoute extends PageRouteInfo<void> {
  const ChannelRoute({List<PageRouteInfo>? children})
      : super(
          ChannelRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChannelRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChannelTambahPage]
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
/// [DaftarMutasiPage]
class DaftarMutasiRoute extends PageRouteInfo<void> {
  const DaftarMutasiRoute({List<PageRouteInfo>? children})
      : super(
          DaftarMutasiRoute.name,
          initialChildren: children,
        );

  static const String name = 'DaftarMutasiRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DaftarPenggunaPage]
class DaftarPenggunaRoute extends PageRouteInfo<void> {
  const DaftarPenggunaRoute({List<PageRouteInfo>? children})
      : super(
          DaftarPenggunaRoute.name,
          initialChildren: children,
        );

  static const String name = 'DaftarPenggunaRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DaftarWargaPage]
class DaftarWargaRoute extends PageRouteInfo<void> {
  const DaftarWargaRoute({List<PageRouteInfo>? children})
      : super(
          DaftarWargaRoute.name,
          initialChildren: children,
        );

  static const String name = 'DaftarWargaRoute';

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
/// [KategoriIuranPage]
class KategoriIuranRoute extends PageRouteInfo<void> {
  const KategoriIuranRoute({List<PageRouteInfo>? children})
      : super(
          KategoriIuranRoute.name,
          initialChildren: children,
        );

  static const String name = 'KategoriIuranRoute';

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
/// [KegiatanDetailPage]
class KegiatanDetailRoute extends PageRouteInfo<KegiatanDetailRouteArgs> {
  KegiatanDetailRoute({
    Key? key,
    required String kegiatanId,
    List<PageRouteInfo>? children,
  }) : super(
          KegiatanDetailRoute.name,
          args: KegiatanDetailRouteArgs(
            key: key,
            kegiatanId: kegiatanId,
          ),
          rawPathParams: {'id': kegiatanId},
          initialChildren: children,
        );

  static const String name = 'KegiatanDetailRoute';

  static const PageInfo<KegiatanDetailRouteArgs> page =
      PageInfo<KegiatanDetailRouteArgs>(name);
}

class KegiatanDetailRouteArgs {
  const KegiatanDetailRouteArgs({
    this.key,
    required this.kegiatanId,
  });

  final Key? key;

  final String kegiatanId;

  @override
  String toString() {
    return 'KegiatanDetailRouteArgs{key: $key, kegiatanId: $kegiatanId}';
  }
}

/// generated route for
/// [KegiatanEditPage]
class KegiatanEditRoute extends PageRouteInfo<KegiatanEditRouteArgs> {
  KegiatanEditRoute({
    Key? key,
    required String kegiatanId,
    List<PageRouteInfo>? children,
  }) : super(
          KegiatanEditRoute.name,
          args: KegiatanEditRouteArgs(
            key: key,
            kegiatanId: kegiatanId,
          ),
          rawPathParams: {'id': kegiatanId},
          initialChildren: children,
        );

  static const String name = 'KegiatanEditRoute';

  static const PageInfo<KegiatanEditRouteArgs> page =
      PageInfo<KegiatanEditRouteArgs>(name);
}

class KegiatanEditRouteArgs {
  const KegiatanEditRouteArgs({
    this.key,
    required this.kegiatanId,
  });

  final Key? key;

  final String kegiatanId;

  @override
  String toString() {
    return 'KegiatanEditRouteArgs{key: $key, kegiatanId: $kegiatanId}';
  }
}

/// generated route for
/// [EtnicPredictionPage]
class EtnicPredictionRoute extends PageRouteInfo<void> {
  const EtnicPredictionRoute({List<PageRouteInfo>? children})
      : super(
          EtnicPredictionRoute.name,
          initialChildren: children,
        );

  static const String name = 'EtnicPredictionRoute';

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
/// [LaporanPemasukanDetailPage]
class LaporanPemasukanDetailRoute
    extends PageRouteInfo<LaporanPemasukanDetailRouteArgs> {
  LaporanPemasukanDetailRoute({
    Key? key,
    required String laporanPemasukanId,
    List<PageRouteInfo>? children,
  }) : super(
          LaporanPemasukanDetailRoute.name,
          args: LaporanPemasukanDetailRouteArgs(
            key: key,
            laporanPemasukanId: laporanPemasukanId,
          ),
          rawPathParams: {'id': laporanPemasukanId},
          initialChildren: children,
        );

  static const String name = 'LaporanPemasukanDetailRoute';

  static const PageInfo<LaporanPemasukanDetailRouteArgs> page =
      PageInfo<LaporanPemasukanDetailRouteArgs>(name);
}

class LaporanPemasukanDetailRouteArgs {
  const LaporanPemasukanDetailRouteArgs({
    this.key,
    required this.laporanPemasukanId,
  });

  final Key? key;

  final String laporanPemasukanId;

  @override
  String toString() {
    return 'LaporanPemasukanDetailRouteArgs{key: $key, laporanPemasukanId: $laporanPemasukanId}';
  }
}

/// generated route for
/// [LaporanPemasukanLainDetailPage]
class LaporanPemasukanLainDetailRoute
    extends PageRouteInfo<LaporanPemasukanLainDetailRouteArgs> {
  LaporanPemasukanLainDetailRoute({
    Key? key,
    required String laporanPemasukanId,
    List<PageRouteInfo>? children,
  }) : super(
          LaporanPemasukanLainDetailRoute.name,
          args: LaporanPemasukanLainDetailRouteArgs(
            key: key,
            laporanPemasukanId: laporanPemasukanId,
          ),
          rawPathParams: {'id': laporanPemasukanId},
          initialChildren: children,
        );

  static const String name = 'LaporanPemasukanLainDetailRoute';

  static const PageInfo<LaporanPemasukanLainDetailRouteArgs> page =
      PageInfo<LaporanPemasukanLainDetailRouteArgs>(name);
}

class LaporanPemasukanLainDetailRouteArgs {
  const LaporanPemasukanLainDetailRouteArgs({
    this.key,
    required this.laporanPemasukanId,
  });

  final Key? key;

  final String laporanPemasukanId;

  @override
  String toString() {
    return 'LaporanPemasukanLainDetailRouteArgs{key: $key, laporanPemasukanId: $laporanPemasukanId}';
  }
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
/// [LaporanPengeluaranDetailPage]
class LaporanPengeluaranDetailRoute
    extends PageRouteInfo<LaporanPengeluaranDetailRouteArgs> {
  LaporanPengeluaranDetailRoute({
    Key? key,
    required String laporanPengeluaranId,
    List<PageRouteInfo>? children,
  }) : super(
          LaporanPengeluaranDetailRoute.name,
          args: LaporanPengeluaranDetailRouteArgs(
            key: key,
            laporanPengeluaranId: laporanPengeluaranId,
          ),
          rawPathParams: {'id': laporanPengeluaranId},
          initialChildren: children,
        );

  static const String name = 'LaporanPengeluaranDetailRoute';

  static const PageInfo<LaporanPengeluaranDetailRouteArgs> page =
      PageInfo<LaporanPengeluaranDetailRouteArgs>(name);
}

class LaporanPengeluaranDetailRouteArgs {
  const LaporanPengeluaranDetailRouteArgs({
    this.key,
    required this.laporanPengeluaranId,
  });

  final Key? key;

  final String laporanPengeluaranId;

  @override
  String toString() {
    return 'LaporanPengeluaranDetailRouteArgs{key: $key, laporanPengeluaranId: $laporanPengeluaranId}';
  }
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
/// [ListAktivitasPage]
class ListAktivitasRoute extends PageRouteInfo<void> {
  const ListAktivitasRoute({List<PageRouteInfo>? children})
      : super(
          ListAktivitasRoute.name,
          initialChildren: children,
        );

  static const String name = 'ListAktivitasRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LogAktivitasPage]
class LogAktivitasRoute extends PageRouteInfo<void> {
  const LogAktivitasRoute({List<PageRouteInfo>? children})
      : super(
          LogAktivitasRoute.name,
          initialChildren: children,
        );

  static const String name = 'LogAktivitasRoute';

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
class MainDashboardRoute extends PageRouteInfo<void> {
  const MainDashboardRoute({List<PageRouteInfo>? children})
      : super(
          MainDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainDashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ManajemenPenggunaPage]
class ManajemenPenggunaRoute extends PageRouteInfo<void> {
  const ManajemenPenggunaRoute({List<PageRouteInfo>? children})
      : super(
          ManajemenPenggunaRoute.name,
          initialChildren: children,
        );

  static const String name = 'ManajemenPenggunaRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MutasiKeluargaPage]
class MutasiKeluargaRoute extends PageRouteInfo<void> {
  const MutasiKeluargaRoute({List<PageRouteInfo>? children})
      : super(
          MutasiKeluargaRoute.name,
          initialChildren: children,
        );

  static const String name = 'MutasiKeluargaRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PemasukanDaftarPage]
class PemasukanDaftarRoute extends PageRouteInfo<void> {
  const PemasukanDaftarRoute({List<PageRouteInfo>? children})
      : super(
          PemasukanDaftarRoute.name,
          initialChildren: children,
        );

  static const String name = 'PemasukanDaftarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PemasukanLainTambahPage]
class PemasukanLainTambahRoute extends PageRouteInfo<void> {
  const PemasukanLainTambahRoute({List<PageRouteInfo>? children})
      : super(
          PemasukanLainTambahRoute.name,
          initialChildren: children,
        );

  static const String name = 'PemasukanLainTambahRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [PengeluaranDetailPage]
class PengeluaranDetailRoute extends PageRouteInfo<PengeluaranDetailRouteArgs> {
  PengeluaranDetailRoute({
    Key? key,
    required String pengeluaranId,
    List<PageRouteInfo>? children,
  }) : super(
          PengeluaranDetailRoute.name,
          args: PengeluaranDetailRouteArgs(
            key: key,
            pengeluaranId: pengeluaranId,
          ),
          rawPathParams: {'id': pengeluaranId},
          initialChildren: children,
        );

  static const String name = 'PengeluaranDetailRoute';

  static const PageInfo<PengeluaranDetailRouteArgs> page =
      PageInfo<PengeluaranDetailRouteArgs>(name);
}

class PengeluaranDetailRouteArgs {
  const PengeluaranDetailRouteArgs({
    this.key,
    required this.pengeluaranId,
  });

  final Key? key;

  final String pengeluaranId;

  @override
  String toString() {
    return 'PengeluaranDetailRouteArgs{key: $key, pengeluaranId: $pengeluaranId}';
  }
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
/// [PenggunaDetailPage]
class PenggunaDetailRoute extends PageRouteInfo<PenggunaDetailRouteArgs> {
  PenggunaDetailRoute({
    Key? key,
    required String userId,
    List<PageRouteInfo>? children,
  }) : super(
          PenggunaDetailRoute.name,
          args: PenggunaDetailRouteArgs(
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'PenggunaDetailRoute';

  static const PageInfo<PenggunaDetailRouteArgs> page =
      PageInfo<PenggunaDetailRouteArgs>(name);
}

class PenggunaDetailRouteArgs {
  const PenggunaDetailRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final String userId;

  @override
  String toString() {
    return 'PenggunaDetailRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [PenggunaEditPage]
class PenggunaEditRoute extends PageRouteInfo<PenggunaEditRouteArgs> {
  PenggunaEditRoute({
    Key? key,
    required String userId,
    List<PageRouteInfo>? children,
  }) : super(
          PenggunaEditRoute.name,
          args: PenggunaEditRouteArgs(
            key: key,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'PenggunaEditRoute';

  static const PageInfo<PenggunaEditRouteArgs> page =
      PageInfo<PenggunaEditRouteArgs>(name);
}

class PenggunaEditRouteArgs {
  const PenggunaEditRouteArgs({
    this.key,
    required this.userId,
  });

  final Key? key;

  final String userId;

  @override
  String toString() {
    return 'PenggunaEditRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [PenggunaTambahPage]
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
/// [TagihIuranPage]
class TagihIuranRoute extends PageRouteInfo<void> {
  const TagihIuranRoute({List<PageRouteInfo>? children})
      : super(
          TagihIuranRoute.name,
          initialChildren: children,
        );

  static const String name = 'TagihIuranRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TagihanDaftarPage]
class TagihanDaftarRoute extends PageRouteInfo<void> {
  const TagihanDaftarRoute({List<PageRouteInfo>? children})
      : super(
          TagihanDaftarRoute.name,
          initialChildren: children,
        );

  static const String name = 'TagihanDaftarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TagihanDetailPage]
class TagihanDetailRoute extends PageRouteInfo<TagihanDetailRouteArgs> {
  TagihanDetailRoute({
    Key? key,
    required String tagihanId,
    List<PageRouteInfo>? children,
  }) : super(
          TagihanDetailRoute.name,
          args: TagihanDetailRouteArgs(
            key: key,
            tagihanId: tagihanId,
          ),
          rawPathParams: {'id': tagihanId},
          initialChildren: children,
        );

  static const String name = 'TagihanDetailRoute';

  static const PageInfo<TagihanDetailRouteArgs> page =
      PageInfo<TagihanDetailRouteArgs>(name);
}

class TagihanDetailRouteArgs {
  const TagihanDetailRouteArgs({
    this.key,
    required this.tagihanId,
  });

  final Key? key;

  final String tagihanId;

  @override
  String toString() {
    return 'TagihanDetailRouteArgs{key: $key, tagihanId: $tagihanId}';
  }
}

/// generated route for
/// [TambahMutasiPage]
class TambahMutasiRoute extends PageRouteInfo<void> {
  const TambahMutasiRoute({List<PageRouteInfo>? children})
      : super(
          TambahMutasiRoute.name,
          initialChildren: children,
        );

  static const String name = 'TambahMutasiRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MachineLearningPage]
class MachineLearningRoute extends PageRouteInfo<void> {
  const MachineLearningRoute({List<PageRouteInfo>? children})
      : super(
          MachineLearningRoute.name,
          initialChildren: children,
        );

  static const String name = 'MachineLearningRoute';

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

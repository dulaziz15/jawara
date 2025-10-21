import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:jawara/presentation/pages/Channel/Channel.dart';
import 'package:jawara/presentation/pages/Channel/Channel_daftar.dart';
import 'package:jawara/presentation/pages/Channel/Channel_tambah.dart';
import 'package:jawara/presentation/pages/Channel/channel_detail.dart';
import 'package:jawara/presentation/pages/Channel/channel_edit.dart';
import 'package:jawara/presentation/pages/LogAktivitas/listAktivitas.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/pengguna_detail.dart';
import 'package:jawara/presentation/pages/auth/login_page.dart';
import 'package:jawara/presentation/pages/auth/register_page.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kependudukan.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_keuangan.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kegiatan.dart';
import 'package:jawara/presentation/pages/dashboard/main_dashboard.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_detail.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_edit.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_tambah.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_dan_broadcast.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_detail.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_edit.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_tambah.dart';
import 'package:jawara/presentation/pages/laporan/laporan.dart';
import 'package:jawara/presentation/pages/laporan/laporan_pengeluaran_detail.dart';
import 'package:jawara/presentation/pages/mutasiKeluarga/daftarMutasi.dart';
import 'package:jawara/presentation/pages/mutasiKeluarga/mutasiKeluarga.dart';
import 'package:jawara/presentation/pages/mutasiKeluarga/tambahMutasi.dart';
import 'package:jawara/presentation/pages/pemasukan/pemasukan.dart';
import 'package:jawara/presentation/pages/pemasukan/pemasukan_daftar.dart';
import 'package:jawara/presentation/pages/pemasukan/pemasukan_tambah.dart';
import 'package:jawara/presentation/pages/pemasukan/tagih_iuran.dart';
import 'package:jawara/presentation/pages/penerimaanWarga/penerimaan.dart';
import 'package:jawara/presentation/pages/penerimaanWarga/penerimaanWarga.dart';
import 'package:jawara/presentation/pages/pengeluaran/laporan_pemasukan_detail.dart';
import 'package:jawara/presentation/pages/pengeluaran/pengeluaran.dart';
import 'package:jawara/presentation/pages/pengeluaran/pengeluaran_detail.dart';

import 'package:jawara/presentation/pages/pesanWarga/aspirasi.dart';
import 'package:jawara/presentation/pages/pesanWarga/pesanWarga.dart';

import 'package:jawara/presentation/pages/setting/setting_page.dart';
import 'package:jawara/presentation/pages/report/report.dart';
import 'package:jawara/presentation/pages/report/report_finance.dart';

// Tambahan import (buat rute sesuai sidebar)
// import 'package:jawara/presentation/pages/dashboard/dashboard_kegiatan.dart';
// import 'package:jawara/presentation/pages/dashboard/dashboard_kependudukan.dart';

// import 'package:jawara/presentation/pages/warga/warga_daftar.dart';
// import 'package:jawara/presentation/pages/warga/warga_tambah.dart';
// import 'package:jawara/presentation/pages/warga/keluarga_page.dart';
// import 'package:jawara/presentation/pages/rumah/rumah_daftar.dart';
// import 'package:jawara/presentation/pages/rumah/rumah_tambah.dart';

import 'package:jawara/presentation/pages/pemasukan/kategori_iuran.dart';
import 'package:jawara/presentation/pages/pemasukan/pemasukan_daftar.dart';
import 'package:jawara/presentation/pages/pemasukan/tagihan_daftar.dart';
import 'package:jawara/presentation/pages/pemasukan/tagihan_detail.dart';
// import 'package:jawara/presentation/pages/pemasukan/pemasukan_lain_daftar.dart';
// import 'package:jawara/presentation/pages/pemasukan/pemasukan_lain_tambah.dart';

import 'package:jawara/presentation/pages/pengeluaran/pengeluaran_daftar.dart';
import 'package:jawara/presentation/pages/pengeluaran/pengeluaran_tambah.dart';

import 'package:jawara/presentation/pages/laporan/laporan_pemasukan.dart';
import 'package:jawara/presentation/pages/laporan/laporan_pengeluaran.dart';
import 'package:jawara/presentation/pages/laporan/laporan_cetak.dart';

import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_daftar.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_daftar.dart';
import 'package:jawara/presentation/pages/warga/daftar_rumah.dart';

// import 'package:jawara/presentation/pages/pesan/pesan_informasi.dart';
// import 'package:jawara/presentation/pages/penerimaan/penerimaan_daftar.dart';
// import 'package:jawara/presentation/pages/mutasi/mutasi_daftar.dart';
// import 'package:jawara/presentation/pages/mutasi/mutasi_tambah.dart';

// import 'package:jawara/presentation/pages/warga/daftar_warga.dart';
import 'package:jawara/presentation/pages/warga/keluarga.dart';
import 'package:jawara/presentation/pages/warga/rumah.dart';
import 'package:jawara/presentation/pages/warga/tambah_rumah.dart';
import 'package:jawara/presentation/pages/warga/tambah_warga.dart';
import 'package:jawara/presentation/pages/warga/warga.dart';
import 'package:jawara/presentation/pages/LogAktivitas/log_aktivitas.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/manajemen.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/daftar_pengguna.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/tambah_pengguna.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/pengguna_edit.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  final routes = [
    // === AUTH ===
    AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
    AutoRoute(page: RegisterRoute.page, path: '/register'),

    // === DASHBOARD ===
    AutoRoute(
      page: DashboardRoute.page,
      path: '/dashboard',
      children: [
        AutoRoute(page: MainDashboardRoute.page, path: 'main'),
        AutoRoute(page: DashboardKeuanganRoute.page, path: 'keuangan'),
        AutoRoute(page: DashboardKegiatanRoute.page, path: 'kegiatan'),
        AutoRoute(page: DashboardKependudukanRoute.page, path: 'kependudukan'),
      ],
    ),
    AutoRoute(
      page: ReportRoute.page,
      path: '/report',
      children: [AutoRoute(page: ReportFinanceRoute.page, path: 'finance')],
    ),

    AutoRoute(
      page: WargaRoute.page,
      path: '/warga',
      children: [
        // AutoRoute(page: WargaDaftarRoute.page, path: 'daftar'),
        AutoRoute(page: WargaTambahRoute.page, path: 'tambah'),
      ],
    ),
    AutoRoute(page: KeluargaRoute.page, path: '/keluarga'),

    AutoRoute(
      page: RumahRoute.page,
      path: '/rumah',
      children: [
        AutoRoute(page: RumahDaftarRoute.page, path: 'daftar'),
        AutoRoute(page: RumahTambahRoute.page, path: 'tambah'),
      ],
    ),

    // === PEMASUKAN ===
    AutoRoute(
      page: PemasukanRoute.page,
      path: '/pemasukan',
      children: [
        AutoRoute(page: TagihanDaftarRoute.page, path: 'tagihan_daftar'),
        AutoRoute(page: TagihanDetailRoute.page, path: 'tagihan_detail/:id'),
        AutoRoute(page: TagihIuranRoute.page, path: 'tagih_iuran'),
        AutoRoute(page: KategoriIuranRoute.page, path: 'kategori_iuran'),
      ],
    ),

    // === LAPORAN KEUANGAN ===
    AutoRoute(
      page: LaporanRoute.page,
      path: '/laporan',
      children: [
        AutoRoute(page: LaporanPemasukanRoute.page, path: 'pemasukan'),
        AutoRoute(page: LaporanPengeluaranRoute.page, path: 'pengeluaran'),
        AutoRoute(page: LaporanCetakRoute.page, path: 'cetak'),
        AutoRoute(page: LaporanPengeluaranDetailRoute.page, path: 'laporan_pengeluaran_detail/:id'),
      ],
    ),

    // === KEGIATAN & BROADCAST ===
    AutoRoute(
      page: KegiatanDanBroadcastRoute.page,
      path: '/kegiatandanbroadcast',
      children: [
        AutoRoute(page: KegiatanTambahRoute.page, path: 'kegiatan_tambah'),
        AutoRoute(page: KegiatanDaftarRoute.page, path: 'kegiatan_daftar'),
        AutoRoute(page: KegiatanDetailRoute.page, path: 'kegiatan_detail/:id'),
        AutoRoute(page: KegiatanEditRoute.page, path: 'kegiatan_edit/:id'),
        AutoRoute(page: BroadcastTambahRoute.page, path: 'broadcast_masuk'),
        AutoRoute(page: BroadcastDaftarRoute.page, path: 'broadcast_daftar'),
        AutoRoute(page: BroadcastDetailRoute.page, path: 'broadcast_detail/:id'),
        AutoRoute(page: BroadcastEditRoute.page, path: 'broadcast_edit/:id'),
      ],
    ),


    //pemasukan
    AutoRoute(
      page: PemasukanRoute.page,
      path: '/pemasukan',
      children: [
        AutoRoute(page: PemasukanLainDaftarRoute.page, path: 'daftar'),
        AutoRoute(page: PemasukanLainDetailRoute.page, path: 'detail/:id'),
        AutoRoute(page: PemasukanLainTambahRoute.page, path: 'tambah'),
      ],
    ),



    AutoRoute(
      page: PesanWargaRoute.page,
      path: '/pesanWarga',
      children: [AutoRoute(page: AspirasiRoute.page, path: 'aspirasi')],
    ),
    AutoRoute(
      page: PenerimaanWargaRoute.page,
      path: '/penerimaanWarga',
      children: [AutoRoute(page: PenerimaanRoute.page, path: 'penerimaan')],
    ),
    AutoRoute(
      page: MutasiKeluargaRoute.page,
      path: '/mutasiKeluarga',
      children: [
        AutoRoute(page: DaftarMutasiRoute.page, path: 'daftarMutasi'), 
        AutoRoute(page: TambahMutasiRoute.page, path: 'tambahMutasi')  
      ]
    ),

    AutoRoute(
      page: LogAktivitasRoute.page,
      path: '/log',
      children: [
        AutoRoute(page: ListAktivitasRoute.page, path: 'aktivitas'),
      ],
    ),

    AutoRoute(
      page: ManajemenPenggunaRoute.page,
      path: '/user',
      children: [
        AutoRoute(page: DaftarPenggunaRoute.page, path: 'daftar'),
        AutoRoute(page: PenggunaEditRoute.page, path: 'edit/:id'),
        AutoRoute(page: PenggunaDetailRoute.page, path: 'detail/:id'),
        AutoRoute(page: PenggunaTambahRoute.page, path: 'tambah'),
      ],
    ),

    AutoRoute(
      page: ChannelRoute.page,
      path: '/channel',
      children: [
        AutoRoute(page: ChannelTambahRoute.page, path: 'tambah'),
        AutoRoute(page: ChannelDetailRoute.page, path: 'detail/:id'),
        AutoRoute(page: ChannelEditRoute.page, path: 'edit/:id'),
        AutoRoute(page: ChannelDaftarRoute.page, path: 'daftar'),
      ],
    ),
  ];
}

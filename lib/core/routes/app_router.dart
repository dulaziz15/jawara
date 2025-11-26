import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

// Auth
import 'package:jawara/presentation/pages/auth/login_page.dart';
import 'package:jawara/presentation/pages/auth/register_page.dart';

// Dashboard
import 'package:jawara/presentation/pages/dashboard/dashboard.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kependudukan.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_keuangan.dart';
import 'package:jawara/presentation/pages/dashboard/dashboard_kegiatan.dart';
import 'package:jawara/presentation/pages/dashboard/main_dashboard.dart';

// Report
import 'package:jawara/presentation/pages/report/report.dart';
import 'package:jawara/presentation/pages/report/report_finance.dart';

// Warga & Keluarga & Rumah
import 'package:jawara/presentation/pages/warga/warga.dart';
import 'package:jawara/presentation/pages/warga/daftar_warga.dart';
import 'package:jawara/presentation/pages/warga/tambah_warga.dart';
import 'package:jawara/presentation/pages/warga/keluarga.dart';
import 'package:jawara/presentation/pages/warga/rumah.dart';
import 'package:jawara/presentation/pages/warga/daftar_rumah.dart';
import 'package:jawara/presentation/pages/warga/tambah_rumah.dart';

// Pemasukan
import 'package:jawara/presentation/pages/pemasukan/pemasukan.dart';
import 'package:jawara/presentation/pages/pemasukan/pemasukan_daftar.dart';
import 'package:jawara/presentation/pages/pemasukan/pemasukan_tambah.dart';
import 'package:jawara/presentation/pages/pemasukan/pemasukan_detail.dart'; // Pastikan file ini ada/digunakan
import 'package:jawara/presentation/pages/pemasukan/tagihan_daftar.dart';
import 'package:jawara/presentation/pages/pemasukan/tagihan_detail.dart';
import 'package:jawara/presentation/pages/pemasukan/tagih_iuran.dart';
import 'package:jawara/presentation/pages/pemasukan/kategori_iuran.dart';

// Pengeluaran
import 'package:jawara/presentation/pages/pengeluaran/pengeluaran.dart';
import 'package:jawara/presentation/pages/pengeluaran/pengeluaran_daftar.dart';
import 'package:jawara/presentation/pages/pengeluaran/pengeluaran_tambah.dart';
import 'package:jawara/presentation/pages/pengeluaran/pengeluaran_detail.dart';

// Laporan
import 'package:jawara/presentation/pages/laporan/laporan.dart';
import 'package:jawara/presentation/pages/laporan/laporan_pemasukan.dart';
import 'package:jawara/presentation/pages/laporan/laporan_pemasukan_detail.dart';
import 'package:jawara/presentation/pages/laporan/laporan_pengeluaran.dart';
import 'package:jawara/presentation/pages/laporan/laporan_pengeluaran_detail.dart';
import 'package:jawara/presentation/pages/laporan/laporan_cetak.dart';

// Kegiatan & Broadcast
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_dan_broadcast.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_daftar.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_tambah.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_detail.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/kegiatan_edit.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_daftar.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_tambah.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_detail.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/broadcast_edit.dart';

// Pesan & Penerimaan Warga & Mutasi
import 'package:jawara/presentation/pages/pesanWarga/pesanWarga.dart';
import 'package:jawara/presentation/pages/pesanWarga/aspirasi.dart';
import 'package:jawara/presentation/pages/penerimaanWarga/penerimaanWarga.dart';
import 'package:jawara/presentation/pages/penerimaanWarga/penerimaan.dart';
import 'package:jawara/presentation/pages/mutasiKeluarga/mutasiKeluarga.dart';
import 'package:jawara/presentation/pages/mutasiKeluarga/daftarMutasi.dart';
import 'package:jawara/presentation/pages/mutasiKeluarga/tambahMutasi.dart';

// Log & Settings & Manajemen User
import 'package:jawara/presentation/pages/LogAktivitas/log_aktivitas.dart';
import 'package:jawara/presentation/pages/LogAktivitas/listAktivitas.dart';
import 'package:jawara/presentation/pages/setting/setting_page.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/manajemen.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/daftar_pengguna.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/tambah_pengguna.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/pengguna_edit.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/pengguna_detail.dart';

// Channel
import 'package:jawara/presentation/pages/Channel/channel.dart';
import 'package:jawara/presentation/pages/Channel/channel_daftar.dart';
import 'package:jawara/presentation/pages/Channel/channel_tambah.dart';
import 'package:jawara/presentation/pages/Channel/channel_detail.dart';
import 'package:jawara/presentation/pages/Channel/channel_edit.dart';

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

    // === REPORT ===
    AutoRoute(
      page: ReportRoute.page,
      path: '/report',
      children: [AutoRoute(page: ReportFinanceRoute.page, path: 'finance')],
    ),

    // === WARGA & KELUARGA ===
    AutoRoute(
      page: WargaRoute.page,
      path: '/warga',
      children: [
        AutoRoute(page: WargaDaftarRoute.page, path: 'daftar'),
        AutoRoute(page: WargaTambahRoute.page, path: 'tambah'),
      ],
    ),
    AutoRoute(page: KeluargaRoute.page, path: '/keluarga'),

    // === RUMAH ===
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
        AutoRoute(page: PemasukanDaftarRoute.page, path: 'daftar'),
        // Perhatikan: LaporanPemasukanLainDetailRoute biasanya dipakai di sini
        AutoRoute(page: LaporanPemasukanLainDetailRoute.page, path: 'pemasukan_detail/:id'),
        AutoRoute(page: PemasukanLainTambahRoute.page, path: 'tambah'),
      ],
    ),

    // === PENGELUARAN ===
    AutoRoute(
      page: PengeluaranRoute.page,
      path: '/pengeluaran',
      children: [
        AutoRoute(page: PengeluaranDaftarRoute.page, path: 'daftar'),
        AutoRoute(page: PengeluaranTambahRoute.page, path: 'tambah'),
        AutoRoute(page: PengeluaranDetailRoute.page, path: 'detail/:id'),
      ],
    ),

    // === LAPORAN KEUANGAN ===
    AutoRoute(
      page: LaporanRoute.page,
      path: '/laporan',
      children: [
        AutoRoute(page: LaporanPemasukanRoute.page, path: 'pemasukan'),
        AutoRoute(page: LaporanPemasukanDetailRoute.page, path: 'detail_pemasukan/:id'),
        AutoRoute(page: LaporanPengeluaranRoute.page, path: 'pengeluaran'),
        AutoRoute(page: LaporanPengeluaranDetailRoute.page, path: 'laporan_pengeluaran_detail/:id'),
        AutoRoute(page: LaporanCetakRoute.page, path: 'cetak'),
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

    // === PESAN & PENERIMAAN ===
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

    // === MUTASI ===
    AutoRoute(
      page: MutasiKeluargaRoute.page,
      path: '/mutasiKeluarga',
      children: [
        AutoRoute(page: DaftarMutasiRoute.page, path: 'daftarMutasi'),
        AutoRoute(page: TambahMutasiRoute.page, path: 'tambahMutasi')
      ],
    ),

    // === LOG & SETTINGS ===
    AutoRoute(
      page: LogAktivitasRoute.page,
      path: '/log',
      children: [
        AutoRoute(page: ListAktivitasRoute.page, path: 'aktivitas'),
      ],
    ),
    AutoRoute(page: SettingsRoute.page, path: '/settings'),

    // === MANAJEMEN USER ===
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

    // === CHANNEL ===
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
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // Buat kontrol ekspansi menu
  bool dashboardExpanded = false;
  bool wargaExpanded = false;
  bool pemasukanExpanded = false;
  bool pengeluaranExpanded = false;
  bool laporanExpanded = false;
  bool kegiatanExpanded = false;
  bool pesanExpanded = false;
  bool penerimaanExpanded = false;
  bool mutasiExpanded = false;
  bool logExpanded = false;
  bool userExpanded = false;
  bool channelExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const DrawerHeader(
  decoration: BoxDecoration(
    color: Color(0xFF6C63FF),
    borderRadius: BorderRadius.only(
      // bottomLeft: Radius.circular(20),
      // bottomRight: Radius.circular(20),
      // topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  ),
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu_book_rounded,
          color: Colors.white,
          size: 48,
        ),
        SizedBox(height: 10),
        Text(
          "Jawara Pintar",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  ),
),



          // DASHBOARD
          ExpansionTile(
            title: const Text("Dashboard"),
            leading: const Icon(Icons.dashboard_outlined),
            initiallyExpanded: dashboardExpanded,
            onExpansionChanged: (v) => setState(() => dashboardExpanded = v),
            children: [
              ListTile(
                title: const Text("Main Dashboard"),
                onTap: () => context.router.pushNamed('/dashboard/main'),
              ),
              ListTile(
                title: const Text("Keuangan"),
                onTap: () => context.router.pushNamed('/dashboard/keuangan'),
              ),
              ListTile(
                title: const Text("Kegiatan"),
                onTap: () => context.router.pushNamed('/dashboard/kegiatan'),
              ),
              ListTile(
                title: const Text("Kependudukan"),
                onTap: () => context.router.pushNamed('/dashboard/kependudukan'),
              ),
            ],
          ),

          // DATA WARGA & RUMAH
          ExpansionTile(
            title: const Text("Data Warga & Rumah"),
            leading: const Icon(Icons.people_outline),
            initiallyExpanded: wargaExpanded,
            onExpansionChanged: (v) => setState(() => wargaExpanded = v),
            children: [
              ListTile(
                title: const Text("Warga - Daftar"),
                onTap: () => context.router.pushNamed('/warga/daftar'),
              ),
              ListTile(
                title: const Text("Warga - Tambah"),
                onTap: () => context.router.pushNamed('/warga/tambah'),
              ),
              ListTile(
                title: const Text("Keluarga"),
                onTap: () => context.router.pushNamed('/keluarga'),
              ),
              ListTile(
                title: const Text("Rumah - Daftar"),
                onTap: () => context.router.pushNamed('/rumah/daftar'),
              ),
              ListTile(
                title: const Text("Rumah - Tambah"),
                onTap: () => context.router.pushNamed('/rumah/tambah'),
              ),
            ],
          ),

          // PEMASUKAN
          ExpansionTile(
            title: const Text("Pemasukan"),
            leading: const Icon(Icons.attach_money_outlined),
            initiallyExpanded: pemasukanExpanded,
            onExpansionChanged: (v) => setState(() => pemasukanExpanded = v),
            children: [
              ListTile(
                title: const Text("Kategori Iuran"),
                onTap: () => context.router.pushNamed('/pemasukan/kategori_iuran'),
              ),
              ListTile(
                title: const Text("Tagih Iuran"),
                onTap: () => context.router.pushNamed('/pemasukan/tagih_iuran'),
              ),
              ListTile(
                title: const Text("Tagihan"),
                onTap: () => context.router.pushNamed('/pemasukan/tagihan_daftar'),
              ),
              ListTile(
                title: const Text("Pemasukan Lain - Daftar"),
                onTap: () => context.router.pushNamed('/pemasukan/daftar'),
              ),
              ListTile(
                title: const Text("Pemasukan Lain - Tambah"),
                onTap: () => context.router.pushNamed('/pemasukan/tambah'),
              ),
            ],
          ),

          // PENGELUARAN
          ExpansionTile(
            title: const Text("Pengeluaran"),
            leading: const Icon(Icons.money_off_outlined),
            initiallyExpanded: pengeluaranExpanded,
            onExpansionChanged: (v) => setState(() => pengeluaranExpanded = v),
            children: [
              ListTile(
                title: const Text("Daftar"),
                onTap: () => context.router.pushNamed('/pengeluaran/daftar'),
              ),
              ListTile(
                title: const Text("Tambah"),
                onTap: () => context.router.pushNamed('/pengeluaran/tambah'),
              ),
            ],
          ),

          // LAPORAN KEUANGAN
          ExpansionTile(
            title: const Text("Laporan Keuangan"),
            leading: const Icon(Icons.receipt_long_outlined),
            initiallyExpanded: laporanExpanded,
            onExpansionChanged: (v) => setState(() => laporanExpanded = v),
            children: [
              ListTile(
                title: const Text("Semua Pemasukan"),
                onTap: () => context.router.pushNamed('/laporan/pemasukan'),
              ),
              ListTile(
                title: const Text("Semua Pengeluaran"),
                onTap: () => context.router.pushNamed('/laporan/pengeluaran'),
              ),
              ListTile(
                title: const Text("Cetak Laporan"),
                onTap: () => context.router.pushNamed('/laporan/cetak'),
              ),
            ],
          ),

          // KEGIATAN & BROADCAST
          ExpansionTile(
            title: const Text("Kegiatan & Broadcast"),
            leading: const Icon(Icons.event_note_outlined),
            initiallyExpanded: kegiatanExpanded,
            onExpansionChanged: (v) => setState(() => kegiatanExpanded = v),
            children: [
              ListTile(
                title: const Text("Kegiatan - Daftar"),
                onTap: () => context.router.pushNamed('/kegiatandanbroadcast/kegiatan_daftar'),
              ),
              ListTile(
                title: const Text("Kegiatan - Tambah"),
                onTap: () => context.router.pushNamed('/kegiatandanbroadcast/kegiatan_tambah'),
              ),
              ListTile(
                title: const Text("Broadcast - Daftar"),
                onTap: () => context.router.pushNamed('/kegiatandanbroadcast/broadcast_daftar'),
              ),
              ListTile(
                title: const Text("Broadcast - Tambah"),
                onTap: () => context.router.pushNamed('/kegiatandanbroadcast/broadcast_masuk'),
              ),
            ],
          ),

          // PESAN WARGA
          ExpansionTile(
            title: const Text("Pesan Warga"),
            leading: const Icon(Icons.chat_outlined),
            initiallyExpanded: pesanExpanded,
            onExpansionChanged: (v) => setState(() => pesanExpanded = v),
            children: [
              ListTile(
                title: const Text("Informasi & Aspirasi"),
                onTap: () => context.router.pushNamed('/pesanWarga/aspirasi'),
              ),
            ],
          ),

          // PENERIMAAN WARGA
          ExpansionTile(
            title: const Text("Penerimaan Warga"),
            leading: const Icon(Icons.how_to_reg_outlined),
            initiallyExpanded: penerimaanExpanded,
            onExpansionChanged: (v) => setState(() => penerimaanExpanded = v),
            children: [
              ListTile(
                title: const Text("Penerimaan Warga"),
                onTap: () => context.router.pushNamed('/penerimaanWarga/penerimaan'),
              ),
            ],
          ),

          // MUTASI KELUARGA
          ExpansionTile(
            title: const Text("Mutasi Keluarga"),
            leading: const Icon(Icons.swap_horiz_outlined),
            initiallyExpanded: mutasiExpanded,
            onExpansionChanged: (v) => setState(() => mutasiExpanded = v),
            children: [
              ListTile(
                title: const Text("Daftar"),
                onTap: () => context.router.pushNamed('/mutasiKeluarga/daftarMutasi'),
              ),
              ListTile(
                title: const Text("Tambah"),
                onTap: () => context.router.pushNamed('/mutasiKeluarga/tambahMutasi'),
              ),
            ],
          ),

          // LOG AKTIVITAS
          ExpansionTile(
            title: const Text("Log Aktivitas"),
            leading: const Icon(Icons.history_outlined),
            initiallyExpanded: logExpanded,
            onExpansionChanged: (v) => setState(() => logExpanded = v),
            children: [
              ListTile(
                title: const Text("Semua Aktivitas"),
                onTap: () => context.router.pushNamed('/log/aktivitas'),
              ),
            ],
          ),

          // MANAJEMEN PENGGUNA
          ExpansionTile(
            title: const Text("Manajemen Pengguna"),
            leading: const Icon(Icons.manage_accounts_outlined),
            initiallyExpanded: userExpanded,
            onExpansionChanged: (v) => setState(() => userExpanded = v),
            children: [
              ListTile(
                title: const Text("Daftar Pengguna"),
                onTap: () => context.router.pushNamed('/user/daftar'),
              ),
              ListTile(
                title: const Text("Tambah Pengguna"),
                onTap: () => context.router.pushNamed('/user/tambah'),
              ),
            ],
          ),

          // CHANNEL TRANSFER
          ExpansionTile(
            title: const Text("Channel Transfer"),
            leading: const Icon(Icons.swap_vert_outlined),
            initiallyExpanded: channelExpanded,
            onExpansionChanged: (v) => setState(() => channelExpanded = v),
            children: [
              ListTile(
                title: const Text("Daftar Channel"),
                onTap: () => context.router.pushNamed('/channel/daftar'),
              ),
              ListTile(
                title: const Text("Tambah Channel"),
                onTap: () => context.router.pushNamed('/channel/tambah'),
              ),
            ],
          ),

           // ML
          ExpansionTile(
            title: const Text("Machine Learning"),
            leading: const Icon(Icons.swap_vert_outlined),
            initiallyExpanded: channelExpanded,
            onExpansionChanged: (v) => setState(() => channelExpanded = v),
            children: [
              ListTile(
                title: const Text("Etnic Prediction"),
                onTap: () => context.router.pushNamed('/ml/etnic'),
              ),
            ],
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => context.router.replaceNamed('/login'),
          ),
        ],
      ),
    );
  }
}



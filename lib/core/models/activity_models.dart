class ActivityModel {
  final int no;
  final String description;
  final String actor;
  final String date;

  const ActivityModel({
    required this.no,
    required this.description,
    required this.actor,
    required this.date,
  });
}

/// === DATA DUMMY ===
final List<ActivityModel> daftarAktivitas = const [
  ActivityModel(
    no: 1,
    description: 'Menambahkan rumah baru dengan alamat: fasda',
    actor: 'Admin Jawara',
    date: '10 Oktober 2025',
  ),
  ActivityModel(
    no: 2,
    description: 'Menyetujui pesan warga: tes',
    actor: 'Admin Jawara',
    date: '11 Oktober 2025',
  ),
  ActivityModel(
    no: 3,
    description: 'Menghapus event: Lomba 17agustus pada ate 16 Agustus 2025',
    actor: 'Admin Jawara',
    date: '14 Oktober 2025',
  ),
  ActivityModel(
    no: 4,
    description: 'Menambahkan pengguna baru: John Doe',
    actor: 'Admin Jawara',
    date: '15 Oktober 2025',
  ),
  ActivityModel(
    no: 5,
    description: 'Mengedit data warga: Jane Smith',
    actor: 'Admin Jawara',
    date: '16 Oktober 2025',
  ),
  ActivityModel(
    no: 6,
    description: 'Menolak permintaan: Pembangunan jalan',
    actor: 'Admin Jawara',
    date: '17 Oktober 2025',
  ),
  ActivityModel(
    no: 7,
    description: 'Menyetujui laporan keuangan bulan Oktober',
    actor: 'Admin Jawara',
    date: '18 Oktober 2025',
  ),
  ActivityModel(
    no: 8,
    description: 'Menghapus broadcast: Pengumuman RT',
    actor: 'Admin Jawara',
    date: '19 Oktober 2025',
  ),
  ActivityModel(
    no: 9,
    description: 'Menambahkan kegiatan: Gotong Royong',
    actor: 'Admin Jawara',
    date: '20 Oktober 2025',
  ),
  ActivityModel(
    no: 10,
    description: 'Mengupdate status pengguna: Aktif',
    actor: 'Admin Jawara',
    date: '21 Oktober 2025',
  ),
];

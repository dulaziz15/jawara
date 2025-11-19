// model untuk pengeluaran
class PengeluaranModel {
  int? id;
  String namaPengeluaran, kategoriPengeluaran, bukti;
  int verifikatorId; // **DIREVISI:** Relasi ke UserModel.id
  double jumlahPengeluaran;
  DateTime tanggalPengeluaran, tanggalTerverifikasi;

  PengeluaranModel({
    this.id,
    required this.namaPengeluaran,
    required this.kategoriPengeluaran,
    required this.verifikatorId, // **DIREVISI**
    required this.bukti,
    required this.jumlahPengeluaran,
    required this.tanggalPengeluaran,
    required this.tanggalTerverifikasi,
  });

  // konversi dari map ke object
  factory PengeluaranModel.fromMap(Map<String, dynamic> map) {
    return PengeluaranModel(
      id: map['id'],
      namaPengeluaran: map['nama_pengeluaran'],
      jumlahPengeluaran: map['jumlah_pengeluaran'] is int ? (map['jumlah_pengeluaran'] as int).toDouble() : map['jumlah_pengeluaran'],
      tanggalPengeluaran: DateTime.parse(map['tanggal_pengeluaran']),
      kategoriPengeluaran: map['kategori_pengeluaran'],
      verifikatorId: map['verifikator_id'], // Menggunakan verifikator_id
      bukti: map['bukti'],
      tanggalTerverifikasi: DateTime.parse(map['tanggal_terverifikasi']),
    );
  }

  // konversi dari object ke map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_pengeluaran': namaPengeluaran,
      'kategori_pengeluaran': kategoriPengeluaran,
      'verifikator_id': verifikatorId, // Menggunakan verifikator_id
      'bukti': bukti,
      'jumlah_pengeluaran': jumlahPengeluaran,
      'tanggal_pengeluaran': tanggalPengeluaran.toIso8601String(),
      'tanggal_terverifikasi': tanggalTerverifikasi.toIso8601String(),
    };
  }
}

List<PengeluaranModel> dummyPengeluaran = [
  PengeluaranModel(
    id: 1,
    namaPengeluaran: 'Pembelian ATK Kantor',
    kategoriPengeluaran: 'Operasional',
    verifikatorId: 201, // ID Andi Wijaya
    bukti: 'bukti_atk.jpg',
    jumlahPengeluaran: 350000.0,
    tanggalPengeluaran: DateTime(2025, 1, 12),
    tanggalTerverifikasi: DateTime(2025, 1, 13),
  ),
  PengeluaranModel(
    id: 2,
    namaPengeluaran: 'Listrik Bulanan',
    kategoriPengeluaran: 'Tagihan',
    verifikatorId: 202, // ID Sinta Dewi
    bukti: 'bukti_listrik.pdf',
    jumlahPengeluaran: 1250000.0,
    tanggalPengeluaran: DateTime(2025, 1, 15),
    tanggalTerverifikasi: DateTime(2025, 1, 16),
  ),
  PengeluaranModel(
    id: 3,
    namaPengeluaran: 'Pembelian Bahan Konsumsi',
    kategoriPengeluaran: 'Konsumsi',
    verifikatorId: 103, // ID Budi Santoso
    bukti: 'bukti_konsumsi.jpg',
    jumlahPengeluaran: 785000.0,
    tanggalPengeluaran: DateTime(2025, 2, 1),
    tanggalTerverifikasi: DateTime(2025, 2, 2),
  ),
  PengeluaranModel(
    id: 4,
    namaPengeluaran: 'Maintenance Server',
    kategoriPengeluaran: 'Teknologi',
    verifikatorId: 203, // ID Rizky Maulana
    bukti: 'bukti_server.pdf',
    jumlahPengeluaran: 2500000.0,
    tanggalPengeluaran: DateTime(2025, 2, 10),
    tanggalTerverifikasi: DateTime(2025, 2, 12),
  ),
  PengeluaranModel(
    id: 5,
    namaPengeluaran: 'Perjalanan Dinas Bandung',
    kategoriPengeluaran: 'Perjalanan Dinas',
    verifikatorId: 204, // ID Dina Kartika
    bukti: 'bukti_perjalanan.jpg',
    jumlahPengeluaran: 3100000.0,
    tanggalPengeluaran: DateTime(2025, 3, 5),
    tanggalTerverifikasi: DateTime(2025, 3, 6),
  ),
  PengeluaranModel(
    id: 6,
    namaPengeluaran: 'Sewa Gedung Acara',
    kategoriPengeluaran: 'Event',
    verifikatorId: 205, // ID Agus Prasetyo
    bukti: 'bukti_sewa.pdf',
    jumlahPengeluaran: 5200000.0,
    tanggalPengeluaran: DateTime(2025, 4, 8),
    tanggalTerverifikasi: DateTime(2025, 4, 10),
  ),
  PengeluaranModel(
    id: 7,
    namaPengeluaran: 'Honor Narasumber',
    kategoriPengeluaran: 'Kegiatan',
    verifikatorId: 206, // ID Maya Putri
    bukti: 'bukti_honor.jpg',
    jumlahPengeluaran: 1500000.0,
    tanggalPengeluaran: DateTime(2025, 4, 20),
    tanggalTerverifikasi: DateTime(2025, 4, 21),
  ),
  PengeluaranModel(
    id: 8,
    namaPengeluaran: 'Pembelian Software Lisensi',
    kategoriPengeluaran: 'Teknologi',
    verifikatorId: 207, // ID Andri Setiawan
    bukti: 'bukti_lisensi.pdf',
    jumlahPengeluaran: 4600000.0,
    tanggalPengeluaran: DateTime(2025, 5, 3),
    tanggalTerverifikasi: DateTime(2025, 5, 4),
  ),
  PengeluaranModel(
    id: 9,
    namaPengeluaran: 'Cetak Brosur Promosi',
    kategoriPengeluaran: 'Marketing',
    verifikatorId: 208, // ID Tasya Amelia
    bukti: 'bukti_brosur.jpg',
    jumlahPengeluaran: 875000.0,
    tanggalPengeluaran: DateTime(2025, 5, 15),
    tanggalTerverifikasi: DateTime(2025, 5, 17),
  ),
  PengeluaranModel(
    id: 10,
    namaPengeluaran: 'Perawatan Kendaraan Operasional',
    kategoriPengeluaran: 'Operasional',
    verifikatorId: 209, // ID Fajar Ramadhan
    bukti: 'bukti_kendaraan.pdf',
    jumlahPengeluaran: 1900000.0,
    tanggalPengeluaran: DateTime(2025, 6, 1),
    tanggalTerverifikasi: DateTime(2025, 6, 2),
  ),
];
// model untuk pemasukan
class PemasukanModel {
  int? id;
  String namaPemasukan, kategoriPemasukan, buktiPemasukan; 
  int verifikatorId;
  double jumlahPemasukan;
  DateTime tanggalPemasukan, tanggalTerverifikasi;

  PemasukanModel({
    this.id,
    required this.namaPemasukan,
    required this.kategoriPemasukan,
    required this.verifikatorId, 
    required this.buktiPemasukan,
    required this.jumlahPemasukan,
    required this.tanggalPemasukan,
    required this.tanggalTerverifikasi,
  });

  // konversi dari map ke object
  factory PemasukanModel.fromMap(Map<String, dynamic> map) {
    return PemasukanModel(
      id: map['id'],
      namaPemasukan: map['nama_pemasukan'],
      jumlahPemasukan: map['jumlah_pemasukan'] is int ? (map['jumlah_pemasukan'] as int).toDouble() : map['jumlah_pemasukan'],
      tanggalPemasukan: DateTime.parse(map['tanggal_pemasukan']),
      kategoriPemasukan: map['kategori_pemasukan'],
      verifikatorId: map['verifikator_id'], // Menggunakan verifikator_id
      buktiPemasukan: map['buktiPemasukan'],
      tanggalTerverifikasi: DateTime.parse(map['tanggal_terverifikasi']),
    );
  }

  // konversi dari object ke map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_pemasukan': namaPemasukan,
      'kategori_pemasukan': kategoriPemasukan,
      'verifikator_id': verifikatorId, // Menggunakan verifikator_id
      'buktiPemasukan': buktiPemasukan,
      'jumlah_pemasukan': jumlahPemasukan,
      'tanggal_pemasukan': tanggalPemasukan.toIso8601String(),
      'tanggal_terverifikasi': tanggalTerverifikasi.toIso8601String(),
    };
  }
}

List<PemasukanModel> dummyPemasukan = [
  PemasukanModel(
    id: 1,
    namaPemasukan: 'Iuran Warga Bulan Januari',
    kategoriPemasukan: 'Iuran',
    verifikatorId: 201, // ID Andi Wijaya
    buktiPemasukan: 'bukti_iuran_januari.jpg',
    jumlahPemasukan: 5000000.0,
    tanggalPemasukan: DateTime(2025, 1, 15),
    tanggalTerverifikasi: DateTime(2025, 1, 16),
  ),
  PemasukanModel(
    id: 2,
    namaPemasukan: 'Penjualan Produk UMKM',
    kategoriPemasukan: 'Penjualan',
    verifikatorId: 202, // ID Sinta Dewi
    buktiPemasukan: 'bukti_penjualan.pdf',
    jumlahPemasukan: 2500000.0,
    tanggalPemasukan: DateTime(2025, 1, 20),
    tanggalTerverifikasi: DateTime(2025, 1, 21),
  ),
  PemasukanModel(
    id: 3,
    namaPemasukan: 'Donasi Sosial',
    kategoriPemasukan: 'Donasi',
    verifikatorId: 103, // ID Budi Santoso
    buktiPemasukan: 'bukti_donasi.jpg',
    jumlahPemasukan: 1500000.0,
    tanggalPemasukan: DateTime(2025, 2, 5),
    tanggalTerverifikasi: DateTime(2025, 2, 6),
  ),
  PemasukanModel(
    id: 4,
    namaPemasukan: 'Pendapatan Sewa Gedung',
    kategoriPemasukan: 'Sewa',
    verifikatorId: 203, // ID Rizky Maulana
    buktiPemasukan: 'bukti_sewa.pdf',
    jumlahPemasukan: 3000000.0,
    tanggalPemasukan: DateTime(2025, 2, 10),
    tanggalTerverifikasi: DateTime(2025, 2, 12),
  ),
  PemasukanModel(
    id: 5,
    namaPemasukan: 'Bantuan Pemerintah',
    kategoriPemasukan: 'Bantuan',
    verifikatorId: 204, // ID Dina Kartika
    buktiPemasukan: 'bukti_bantuan.jpg',
    jumlahPemasukan: 10000000.0,
    tanggalPemasukan: DateTime(2025, 3, 1),
    tanggalTerverifikasi: DateTime(2025, 3, 2),
  ),
  PemasukanModel(
    id: 6,
    namaPemasukan: 'Pendapatan Jasa Konsultasi',
    kategoriPemasukan: 'Jasa',
    verifikatorId: 205, // ID Agus Prasetyo
    buktiPemasukan: 'bukti_konsultasi.pdf',
    jumlahPemasukan: 4000000.0,
    tanggalPemasukan: DateTime(2025, 3, 15),
    tanggalTerverifikasi: DateTime(2025, 3, 16),
  ),
  PemasukanModel(
    id: 7,
    namaPemasukan: 'Iuran Warga Bulan Februari',
    kategoriPemasukan: 'Iuran',
    verifikatorId: 206, // ID Maya Putri
    buktiPemasukan: 'bukti_iuran_februari.jpg',
    jumlahPemasukan: 5200000.0,
    tanggalPemasukan: DateTime(2025, 4, 1),
    tanggalTerverifikasi: DateTime(2025, 4, 2),
  ),
  PemasukanModel(
    id: 8,
    namaPemasukan: 'Pendapatan Investasi',
    kategoriPemasukan: 'Investasi',
    verifikatorId: 207, // ID Andri Setiawan
    buktiPemasukan: 'bukti_investasi.pdf',
    jumlahPemasukan: 8000000.0,
    tanggalPemasukan: DateTime(2025, 4, 10),
    tanggalTerverifikasi: DateTime(2025, 4, 11),
  ),
  PemasukanModel(
    id: 9,
    namaPemasukan: 'Sumbangan Masyarakat',
    kategoriPemasukan: 'Sumbangan',
    verifikatorId: 208, // ID Tasya Amelia
    buktiPemasukan: 'bukti_sumbangan.jpg',
    jumlahPemasukan: 2000000.0,
    tanggalPemasukan: DateTime(2025, 5, 5),
    tanggalTerverifikasi: DateTime(2025, 5, 6),
  ),
  PemasukanModel(
    id: 10,
    namaPemasukan: 'Pendapatan Event',
    kategoriPemasukan: 'Event',
    verifikatorId: 209, // ID Fajar Ramadhan
    buktiPemasukan: 'bukti_event.pdf',
    jumlahPemasukan: 3500000.0,
    tanggalPemasukan: DateTime(2025, 5, 20),
    tanggalTerverifikasi: DateTime(2025, 5, 21),
  ),
];
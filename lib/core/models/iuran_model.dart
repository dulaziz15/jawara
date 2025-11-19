// model untuk iuran
class IuranModel {
  int? id;
  String namaIuran, kategoriIuran;
  int verifikatorId; // **DIREVISI:** Relasi ke UserModel.id
  String bukti;
  double jumlah;
  DateTime tanggalIuran, tanggalTerverifikasi;

  IuranModel({
    this.id,
    required this.namaIuran,
    required this.kategoriIuran,
    required this.verifikatorId, // **DIREVISI**
    required this.bukti,
    required this.jumlah,
    required this.tanggalIuran,
    required this.tanggalTerverifikasi,
  });

  // konversi dari map ke object
  factory IuranModel.fromMap(Map<String, dynamic> map) {
    return IuranModel(
      id: map['id'],
      namaIuran: map['nama_iuran'],
      jumlah: map['jumlah'] is int ? (map['jumlah'] as int).toDouble() : map['jumlah'],
      tanggalIuran: DateTime.parse(map['tanggal_iuran']),
      kategoriIuran: map['kategori_iuran'],
      verifikatorId: map['verifikator_id'], // Menggunakan verifikator_id
      bukti: map['bukti'],
      tanggalTerverifikasi: DateTime.parse(map['tanggal_terverifikasi']),
    );
  }

  // konversi dari object ke map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_iuran': namaIuran,
      'kategori_iuran': kategoriIuran,
      'verifikator_id': verifikatorId, // Menggunakan verifikator_id
      'bukti': bukti,
      'jumlah': jumlah,
      'tanggal_iuran': tanggalIuran.toIso8601String(),
      'tanggal_terverifikasi': tanggalTerverifikasi.toIso8601String(),
    };
  }
}

List<IuranModel> dummyIuran = [
  IuranModel(
    id: 1,
    namaIuran: 'Iuran Kebersihan Bulanan',
    kategoriIuran: 'Kebersihan',
    verifikatorId: 201, // ID Andi Wijaya
    bukti: 'bukti_iuran_kebersihan_januari.jpg',
    jumlah: 500000.0,
    tanggalIuran: DateTime(2025, 1, 15),
    tanggalTerverifikasi: DateTime(2025, 1, 16),
  ),
  IuranModel(
    id: 2,
    namaIuran: 'Iuran Keamanan Bulanan',
    kategoriIuran: 'Keamanan',
    verifikatorId: 202, // ID Sinta Dewi
    bukti: 'bukti_iuran_keamanan_februari.pdf',
    jumlah: 750000.0,
    tanggalIuran: DateTime(2025, 2, 15),
    tanggalTerverifikasi: DateTime(2025, 2, 16),
  ),
  IuranModel(
    id: 3,
    namaIuran: 'Iuran Sosial',
    kategoriIuran: 'Sosial',
    verifikatorId: 103, // ID Budi Santoso
    bukti: 'bukti_iuran_sosial_maret.jpg',
    jumlah: 300000.0,
    tanggalIuran: DateTime(2025, 3, 15),
    tanggalTerverifikasi: DateTime(2025, 3, 16),
  ),
  IuranModel(
    id: 4,
    namaIuran: 'Iuran Infrastruktur Bulanan',
    kategoriIuran: 'Infrastruktur',
    verifikatorId: 203, // ID Rizky Maulana
    bukti: 'bukti_iuran_infrastruktur_april.pdf',
    jumlah: 1000000.0,
    tanggalIuran: DateTime(2025, 4, 15),
    tanggalTerverifikasi: DateTime(2025, 4, 16),
  ),
  IuranModel(
    id: 5,
    namaIuran: 'Iuran Pendidikan Bulanan',
    kategoriIuran: 'Pendidikan',
    verifikatorId: 204, // ID Dina Kartika
    bukti: 'bukti_iuran_pendidikan_mei.jpg',
    jumlah: 600000.0,
    tanggalIuran: DateTime(2025, 5, 15),
    tanggalTerverifikasi: DateTime(2025, 5, 16),
  ),
];
// model untuk iuran
class IuranModel {
  int? id;
  String namaIuran, kategoriIuran, verifikator, bukti;
  double jumlah;
  DateTime tanggalIuran, tanggalTerverifikasi;

  IuranModel({
    this.id,
    required this.namaIuran,
    required this.kategoriIuran,
    required this.verifikator,
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
      jumlah: map['jumlah'],
      tanggalIuran: DateTime.parse(map['tanggal_iuran']),
      kategoriIuran: map['kategori_iuran'],
      verifikator: map['verifikator'],
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
      'verifikator': verifikator,
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
    verifikator: 'Andi Wijaya',
    bukti: 'bukti_iuran_kebersihan_januari.jpg',
    jumlah: 500000.0,
    tanggalIuran: DateTime(2025, 1, 15),
    tanggalTerverifikasi: DateTime(2025, 1, 16),
  ),
  IuranModel(
    id: 2,
    namaIuran: 'Iuran Keamanan Bulanan',
    kategoriIuran: 'Keamanan',
    verifikator: 'Sinta Dewi',
    bukti: 'bukti_iuran_keamanan_februari.pdf',
    jumlah: 750000.0,
    tanggalIuran: DateTime(2025, 2, 15),
    tanggalTerverifikasi: DateTime(2025, 2, 16),
  ),
  IuranModel(
    id: 3,
    namaIuran: 'Iuran Sosial',
    kategoriIuran: 'Sosial',
    verifikator: 'Budi Santoso',
    bukti: 'bukti_iuran_sosial_maret.jpg',
    jumlah: 300000.0,
    tanggalIuran: DateTime(2025, 3, 15),
    tanggalTerverifikasi: DateTime(2025, 3, 16),
  ),
  IuranModel(
    id: 4,
    namaIuran: 'Iuran Infrastruktur Bulanan',
    kategoriIuran: 'Infrastruktur',
    verifikator: 'Rizky Maulana',
    bukti: 'bukti_iuran_infrastruktur_april.pdf',
    jumlah: 1000000.0,
    tanggalIuran: DateTime(2025, 4, 15),
    tanggalTerverifikasi: DateTime(2025, 4, 16),
  ),
  IuranModel(
    id: 5,
    namaIuran: 'Iuran Pendidikan Bulanan',
    kategoriIuran: 'Pendidikan',
    verifikator: 'Dina Kartika',
    bukti: 'bukti_iuran_pendidikan_mei.jpg',
    jumlah: 600000.0,
    tanggalIuran: DateTime(2025, 5, 15),
    tanggalTerverifikasi: DateTime(2025, 5, 16),
  ),
];

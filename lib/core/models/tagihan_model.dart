// model untuk tagihan
class TagihanModel {
  int? id;
  String kodeIuran; // unique
  String namaIuran; // terhubung dengan iuran models
  String kategori; // terhubung dengan iuran model
  String periode;
  double nominal;
  String status; // unpaid/paid
  String namaKK; // terhubung dengan family model
  String alamat;
  String metodePembayaran;
  String bukti;
  String alasanPenolakan;

  TagihanModel({
    this.id,
    required this.kodeIuran,
    required this.namaIuran,
    required this.kategori,
    required this.periode,
    required this.nominal,
    required this.status,
    required this.namaKK,
    required this.alamat,
    required this.metodePembayaran,
    required this.bukti,
    required this.alasanPenolakan,
  });

  // konversi dari map ke object
  factory TagihanModel.fromMap(Map<String, dynamic> map) {
    return TagihanModel(
      id: map['id'],
      kodeIuran: map['kode_iuran'],
      namaIuran: map['nama_iuran'],
      kategori: map['kategori'],
      periode: map['periode'],
      nominal: map['nominal'],
      status: map['status'],
      namaKK: map['nama_kk'],
      alamat: map['alamat'],
      metodePembayaran: map['metode_pembayaran'],
      bukti: map['bukti'],
      alasanPenolakan: map['alasan_penolakan'],
    );
  }

  // konversi dari object ke map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kode_iuran': kodeIuran,
      'nama_iuran': namaIuran,
      'kategori': kategori,
      'periode': periode,
      'nominal': nominal,
      'status': status,
      'nama_kk': namaKK,
      'alamat': alamat,
      'metode_pembayaran': metodePembayaran,
      'bukti': bukti,
      'alasan_penolakan': alasanPenolakan,
    };
  }
}

List<TagihanModel> dummyTagihan = [
  TagihanModel(
    id: 1,
    kodeIuran: 'IUR-KEB-001',
    namaIuran: 'Iuran Kebersihan Bulan Januari',
    kategori: 'Kebersihan',
    periode: 'Januari 2025',
    nominal: 50000.0,
    status: 'paid',
    namaKK: 'Ahmad Surya',
    alamat: 'Jl. Merdeka No. 1',
    metodePembayaran: 'Transfer Bank',
    bukti: 'bukti_transfer_kebersihan.jpg',
    alasanPenolakan: '',
  ),
  TagihanModel(
    id: 2,
    kodeIuran: 'IUR-KAM-002',
    namaIuran: 'Iuran Keamanan Bulan Februari',
    kategori: 'Keamanan',
    periode: 'Februari 2025',
    nominal: 75000.0,
    status: 'unpaid',
    namaKK: 'Budi Santoso',
    alamat: 'Jl. Sudirman No. 15',
    metodePembayaran: '',
    bukti: '',
    alasanPenolakan: '',
  ),
  TagihanModel(
    id: 3,
    kodeIuran: 'IUR-SOS-003',
    namaIuran: 'Iuran Sosial Bulan Maret',
    kategori: 'Sosial',
    periode: 'Maret 2025',
    nominal: 30000.0,
    status: 'paid',
    namaKK: 'Citra Dewi',
    alamat: 'Jl. Diponegoro No. 8',
    metodePembayaran: 'Cash',
    bukti: 'bukti_cash_sosial.jpg',
    alasanPenolakan: '',
  ),
  TagihanModel(
    id: 4,
    kodeIuran: 'IUR-INF-004',
    namaIuran: 'Iuran Infrastruktur Bulan April',
    kategori: 'Infrastruktur',
    periode: 'April 2025',
    nominal: 100000.0,
    status: 'unpaid',
    namaKK: 'Dedi Rahman',
    alamat: 'Jl. Veteran No. 22',
    metodePembayaran: '',
    bukti: '',
    alasanPenolakan: '',
  ),
  TagihanModel(
    id: 5,
    kodeIuran: 'IUR-PEN-005',
    namaIuran: 'Iuran Pendidikan Bulan Mei',
    kategori: 'Pendidikan',
    periode: 'Mei 2025',
    nominal: 60000.0,
    status: 'paid',
    namaKK: 'Eka Putri',
    alamat: 'Jl. Asia Afrika No. 5',
    metodePembayaran: 'E-Wallet',
    bukti: 'bukti_ewallet_pendidikan.jpg',
    alasanPenolakan: '',
  ),
];

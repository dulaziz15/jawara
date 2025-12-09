// model untuk tagihan
class TagihanModel {
  final String? docId;
  final String kodeIuran; 
  final String namaIuran; 
  final String kategori; 
  final String periode;
  final double nominal;
  final String status;
  final String nik; 
  final String metodePembayaran;
  final String bukti;
  final String alasanPenolakan;
  final String namaWarga; // Tambahan field untuk menyimpan nama warga hasil JOIN
  final String alamatWarga;

  
  TagihanModel({
    this.docId,
    required this.kodeIuran,
    required this.namaIuran,
    required this.kategori,
    required this.periode,
    required this.nominal,
    required this.status,
    required this.nik, 
    required this.metodePembayaran,
    required this.bukti,
    required this.alasanPenolakan,
    required this.namaWarga,
    required this.alamatWarga,
  });

// konversi dari map ke object
  factory TagihanModel.fromMap(Map<String, dynamic> map, String id, {String? namaWargaFromJoin, String? alamatWargaFromJoin}) {
    return TagihanModel(
      docId: id, // Gunakan 'id' dari parameter agar ID dokumen terbaca
      kodeIuran: map['kode_iuran'] ?? '',
      namaIuran: map['nama_iuran'] ?? '',
      kategori: map['kategori'] ?? '',
      periode: map['periode'] ?? '',
      
      // --- PERBAIKAN UTAMA DI SINI ---
      // (map['nominal'] as num?) akan mendeteksi apakah itu int atau double
      // ?.toDouble() mengubahnya jadi double
      // ?? 0.0 memberikan nilai default 0 jika datanya kosong (null)
      nominal: (map['nominal'] as num?)?.toDouble() ?? 0.0,
      // --------------------------------
      
      status: map['status'] ?? 'unpaid',
      nik: map['nik'] ?? '', 
      metodePembayaran: map['metode_pembayaran'] ?? '',
      bukti: map['bukti'] ?? '',
      alasanPenolakan: map['alasan_penolakan'] ?? '',
      
      // --- PERBAIKAN LOGIC JOIN ---
      // Kamu lupa memasukkan variabel 'namaWargaFromJoin' ke sini
      namaWarga: namaWargaFromJoin ?? map['nama_warga'] ?? '', 
      alamatWarga: alamatWargaFromJoin ?? map['alamat_warga'] ?? '', 
    );
  }
  // konversi dari object ke map
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'kode_iuran': kodeIuran,
      'nama_iuran': namaIuran,
      'kategori': kategori,
      'periode': periode,
      'nominal': nominal,
      'status': status,
      'nik': nik, // Menggunakan nik
      'metode_pembayaran': metodePembayaran,
      'bukti': bukti,
      'alasan_penolakan': alasanPenolakan,
    };
  }
}

// List<TagihanModel> dummyTagihan = [
//   TagihanModel(
//     docId: '1',
//     kodeIuran: 'IUR-KEB-001',
//     namaIuran: 'Iuran Kebersihan Bulan Januari',
//     kategori: 'Kebersihan',
//     periode: 'Januari 2025',
//     nominal: 50000.0,
//     status: 'paid',
//     nik: '1111111111111111', // NIK Ahmad Surya
//     metodePembayaran: 'Transfer Bank',
//     bukti: 'bukti_transfer_kebersihan.jpg',
//     alasanPenolakan: '',
//   ),
//   TagihanModel(
//     docId: '2',
//     kodeIuran: 'IUR-KAM-002',
//     namaIuran: 'Iuran Keamanan Bulan Februari',
//     kategori: 'Keamanan',
//     periode: 'Februari 2025',
//     nominal: 75000.0,
//     status: 'unpaid',
//     nik: '2222222222222222', // NIK Budi Santoso
//     metodePembayaran: '',
//     bukti: '',
//     alasanPenolakan: '',
//   ),
//   TagihanModel(
//     docId: '3',
//     kodeIuran: 'IUR-SOS-003',
//     namaIuran: 'Iuran Sosial Bulan Maret',
//     kategori: 'Sosial',
//     periode: 'Maret 2025',
//     nominal: 30000.0,
//     status: 'paid',
//     nik: '3333333333333333', // NIK Citra Dewi
//     metodePembayaran: 'Cash',
//     bukti: 'bukti_cash_sosial.jpg',
//     alasanPenolakan: '',
//   ),
//   TagihanModel(
//     docId: '4',
//     kodeIuran: 'IUR-INF-004',
//     namaIuran: 'Iuran Infrastruktur Bulan April',
//     kategori: 'Infrastruktur',
//     periode: 'April 2025',
//     nominal: 100000.0,
//     status: 'unpaid',
//     nik: '4444444444444444', // NIK Dedi Rahman
//     metodePembayaran: '',
//     bukti: '',
//     alasanPenolakan: '',
//   ),
//   TagihanModel(
//     docId: '5',
//     kodeIuran: 'IUR-PEN-005',
//     namaIuran: 'Iuran Pendidikan Bulan Mei',
//     kategori: 'Pendidikan',
//     periode: 'Mei 2025',
//     nominal: 60000.0,
//     status: 'paid',
//     nik: '5555555555555555', // NIK Eka Putri
//     metodePembayaran: 'E-Wallet',
//     bukti: 'bukti_ewallet_pendidikan.jpg',
//     alasanPenolakan: '',
//   ),
// ];
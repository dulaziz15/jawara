class UserModel {
  final int id; // Primary Key
  final String nama; // Nama Warga
  final String nik; // Unique Key
  final String email;
  final String idKeluarga;
  final String jenisKelamin;
  final String statusDomisili; // Aktif / Nonaktif
  final String statusHidup; // Hidup / Meninggal
  final String buktiIdentitas; // Path gambar KTP

  const UserModel({
    required this.id,
    required this.nama,
    required this.nik,
    required this.email,
    required this.idKeluarga,
    required this.jenisKelamin,
    required this.statusDomisili,
    required this.statusHidup,
    required this.buktiIdentitas,
  });

  // ===============================================
  // 📥 Konversi dari Map (Firestore/JSON) ke Object
  // ===============================================
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] is String ? int.tryParse(map['id']) ?? 0 : map['id'] as int,
      nama: map['nama'] as String,
      nik: map['nik'] as String,
      email: map['email'] as String,
      idKeluarga: map['idKeluarga'] as String,
      jenisKelamin: map['jenisKelamin'] as String,
      statusDomisili: map['statusDomisili'] as String,
      statusHidup: map['statusHidup'] as String,
      buktiIdentitas: map['buktiIdentitas'] as String,
    );
  }

  // ===============================================
  // 📤 Konversi dari Object ke Map (Firestore Write)
  // ===============================================
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nik': nik,
      'email': email,
      'idKeluarga': idKeluarga,
      'jenisKelamin': jenisKelamin,
      'statusDomisili': statusDomisili,
      'statusHidup': statusHidup,
      'buktiIdentitas': buktiIdentitas,
    };
  }
}

final List<UserModel> daftarPengguna = const [
  UserModel(
    id: 101,
    nama: 'Admin Jawara',
    email: 'admin@jawara.com',
    nik: '1234567890123451',
    idKeluarga: 'F001',
    jenisKelamin: 'Laki-laki',
    statusDomisili: 'Aktif',
    statusHidup: 'Hidup',
    buktiIdentitas: 'assets/images/ktp_admin.jpg',
  ),
  UserModel(
    id: 102,
    nama: 'Ahmad Surya',
    email: 'ahmad@warga.com',
    nik: '1111111111111111',
    idKeluarga: 'F111',
    jenisKelamin: 'Laki-laki',
    statusDomisili: 'Aktif',
    statusHidup: 'Hidup',
    buktiIdentitas: 'assets/images/ktp_ahmad.jpg',
  ),
  UserModel(
    id: 103,
    nama: 'Budi Santoso',
    email: 'budi@warga.com',
    nik: '2222222222222222',
    idKeluarga: 'F222',
    jenisKelamin: 'Laki-laki',
    statusDomisili: 'Aktif',
    statusHidup: 'Hidup',
    buktiIdentitas: 'assets/images/ktp_budi.jpg',
  ),
  UserModel(
    id: 104,
    nama: 'Citra Dewi',
    email: 'citra@warga.com',
    nik: '3333333333333333',
    idKeluarga: 'F333',
    jenisKelamin: 'Perempuan',
    statusDomisili: 'Aktif',
    statusHidup: 'Hidup',
    buktiIdentitas: 'assets/images/ktp_citra.jpg',
  ),
  UserModel(
    id: 105,
    nama: 'Dedi Rahman',
    email: 'dedi@warga.com',
    nik: '4444444444444444',
    idKeluarga: 'F444',
    jenisKelamin: 'Laki-laki',
    statusDomisili: 'Aktif',
    statusHidup: 'Hidup',
    buktiIdentitas: 'assets/images/ktp_dedi.jpg',
  ),
  UserModel(
    id: 106,
    nama: 'Eka Putri',
    email: 'eka@warga.com',
    nik: '5555555555555555',
    idKeluarga: 'F555',
    jenisKelamin: 'Perempuan',
    statusDomisili: 'Aktif',
    statusHidup: 'Hidup',
    buktiIdentitas: 'assets/images/ktp_eka.jpg',
  ),
];

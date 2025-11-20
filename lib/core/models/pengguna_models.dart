class UserModel {
  final int id; // Primary Key
  final String nama;
  final String email;
  final String status;
  final String role;
  final String nik; // Unique Key
  final String noHp;
  final String jenisKelamin;

  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.status,
    required this.role,
    required this.nik,
    required this.noHp,
    required this.jenisKelamin,
  });

  // ===============================================
  // 📥 Konversi dari Map (Firestore/JSON) ke Object
  // ===============================================
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      // ID sering kali disimpan sebagai string di Firestore, 
      // jadi kita pastikan konversi ke int aman:
      id: map['id'] is String ? int.tryParse(map['id']) ?? 0 : map['id'] as int,
      nama: map['nama'] as String,
      email: map['email'] as String,
      status: map['status'] as String,
      role: map['role'] as String,
      nik: map['nik'] as String,
      noHp: map['noHp'] as String,
      jenisKelamin: map['jenisKelamin'] as String,
    );
  }

  // ===============================================
  // 📤 Konversi dari Object ke Map (Untuk Firestore Write)
  // ===============================================
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'status': status,
      'role': role,
      'nik': nik,
      'noHp': noHp,
      'jenisKelamin': jenisKelamin,
    };
  }
}

// Data Dummy Aktor/Pengguna (Tidak berubah)
final List<UserModel> daftarPengguna = const [
  UserModel(
    id: 101, // Admin Jawara
    nama: 'Admin Jawara',
    email: 'admin@jawara.com',
    status: 'Aktif',
    role: 'Admin',
    nik: '1234567890123451',
    noHp: '081234567891',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 102, // Kepala Keluarga A
    nama: 'Ahmad Surya',
    email: 'ahmad@warga.com',
    status: 'Aktif',
    role: 'Warga',
    nik: '1111111111111111',
    noHp: '081111111111',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 103, // Kepala Keluarga B
    nama: 'Budi Santoso',
    email: 'budi@warga.com',
    status: 'Aktif',
    role: 'Warga',
    nik: '2222222222222222',
    noHp: '082222222222',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 104,
    nama: 'Citra Dewi',
    email: 'citra@warga.com',
    status: 'Aktif',
    role: 'Warga',
    nik: '3333333333333333',
    noHp: '083333333333',
    jenisKelamin: 'Perempuan',
  ),
  UserModel(
    id: 105,
    nama: 'Dedi Rahman',
    email: 'dedi@warga.com',
    status: 'Aktif',
    role: 'Warga',
    nik: '4444444444444444',
    noHp: '084444444444',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 106,
    nama: 'Eka Putri',
    email: 'eka@warga.com',
    status: 'Aktif',
    role: 'Warga',
    nik: '5555555555555555',
    noHp: '085555555555',
    jenisKelamin: 'Perempuan',
  ),
  // Verifikator/PJ yang ada di model lain
  UserModel(
    id: 201, nama: 'Andi Wijaya', email: 'andi@verif.com', status: 'Aktif', role: 'Verifikator', nik: '9000000000000001', noHp: '089000000001', jenisKelamin: 'Laki-laki'),
  UserModel(
    id: 202, nama: 'Sinta Dewi', email: 'sinta@verif.com', status: 'Aktif', role: 'Verifikator', nik: '9000000000000002', noHp: '089000000002', jenisKelamin: 'Perempuan'),
  UserModel(
    id: 203, nama: 'Rizky Maulana', email: 'rizky@verif.com', status: 'Aktif', role: 'Verifikator', nik: '9000000000000003', noHp: '089000000003', jenisKelamin: 'Laki-laki'),
  UserModel(
    id: 204, nama: 'Dina Kartika', email: 'dina@verif.com', status: 'Aktif', role: 'Verifikator', nik: '9000000000000004', noHp: '089000000004', jenisKelamin: 'Perempuan'),
  UserModel(
    id: 205, nama: 'Agus Prasetyo', email: 'agus@verif.com', status: 'Aktif', role: 'Verifikator', nik: '9000000000000005', noHp: '089000000005', jenisKelamin: 'Laki-laki'),
  UserModel(
    id: 206, nama: 'Maya Putri', email: 'maya@verif.com', status: 'Aktif', role: 'Verifikator', nik: '9000000000000006', noHp: '089000000006', jenisKelamin: 'Perempuan'),
  UserModel(
    id: 207, nama: 'Andri Setiawan', email: 'andri@verif.com', status: 'Aktif', role: 'Verifikator', nik: '9000000000000007', noHp: '089000000007', jenisKelamin: 'Laki-laki'),
  UserModel(
    id: 208, nama: 'Tasya Amelia', email: 'tasya@verif.com', status: 'Aktif', role: 'Verifikator', nik: '9000000000000008', noHp: '089000000008', jenisKelamin: 'Perempuan'),
  UserModel(
    id: 209, nama: 'Fajar Ramadhan', email: 'fajar@verif.com', status: 'Aktif', role: 'Verifikator', nik: '9000000000000009', noHp: '089000000009', jenisKelamin: 'Laki-laki'),
  UserModel(
    id: 301, nama: 'John Doe', email: 'john@kegiatan.com', status: 'Aktif', role: 'PJ Kegiatan', nik: '8000000000000001', noHp: '088000000001', jenisKelamin: 'Laki-laki'),
  UserModel(
    id: 302, nama: 'Jane Smith', email: 'jane@kegiatan.com', status: 'Aktif', role: 'PJ Kegiatan', nik: '8000000000000002', noHp: '088000000002', jenisKelamin: 'Perempuan'),
  UserModel(
    id: 303, nama: 'Alice Johnson', email: 'alice@kegiatan.com', status: 'Aktif', role: 'PJ Kegiatan', nik: '8000000000000003', noHp: '088000000003', jenisKelamin: 'Perempuan'),
  UserModel(
    id: 304, nama: 'Bob Brown', email: 'bob@kegiatan.com', status: 'Aktif', role: 'PJ Kegiatan', nik: '8000000000000004', noHp: '088000000004', jenisKelamin: 'Laki-laki'),
];
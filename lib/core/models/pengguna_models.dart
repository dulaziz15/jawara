class UserModel {
  final int id;
  final String nama;
  final String email;
  final String status;
  final String role;
  final String nik;
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
}

/// === DATA DUMMY ===
final List<UserModel> daftarPengguna = const [
  UserModel(
    id: 1,
    nama: 'dewqedwddw',
    email: 'admiwewen1@gmail.com',
    status: 'Diterima',
    role: 'Admin',
    nik: '1234567890123451',
    noHp: '081234567891',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 2,
    nama: 'Rendha Putra Rahmadya',
    email: 'rendhazuper@gmail.com',
    status: 'Diproses',
    role: 'Admin',
    nik: '1234567890123452',
    noHp: '081234567892',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 3,
    nama: 'bla',
    email: 'y@gmail.com',
    status: 'Ditolak',
    role: 'Admin',
    nik: '1234567890123453',
    noHp: '081234567893',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 4,
    nama: 'Anti Micin',
    email: 'antimicin3@gmail.com',
    status: 'Diterima',
    role: 'Admin',
    nik: '1234567890123454',
    noHp: '081234567894',
    jenisKelamin: 'Perempuan',
  ),
  UserModel(
    id: 5,
    nama: 'ijat4',
    email: 'ijat4@gmail.com',
    status: 'Diproses',
    role: 'Admin',
    nik: '1234567890123455',
    noHp: '081234567895',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 6,
    nama: 'ijat3',
    email: 'ijat3@gmail.com',
    status: 'Diterima',
    role: 'Admin',
    nik: '1234567890123456',
    noHp: '081234567896',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 7,
    nama: 'ijat2',
    email: 'ijat2@gmail.com',
    status: 'Ditolak',
    role: 'Admin',
    nik: '1234567890123457',
    noHp: '081234567897',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 8,
    nama: 'AFIFAH KHOIRUNNISA',
    email: 'afi@gmail.com',
    status: 'Diterima',
    role: 'Warga',
    nik: '1234567890123458',
    noHp: '081234567898',
    jenisKelamin: 'Perempuan',
  ),
  UserModel(
    id: 9,
    nama: 'Raudhil Firdaus Naufal',
    email: 'raudhilfirdausn@gmail.com',
    status: 'Diproses',
    role: 'Warga',
    nik: '1234567890123459',
    noHp: '081234567899',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 10,
    nama: 'varizky naldiba rimra',
    email: 'zelectra1011@gmail.com',
    status: 'Diterima',
    role: 'Warga',
    nik: '1234567890123460',
    noHp: '081234567890',
    jenisKelamin: 'Laki-laki',
  ),
];

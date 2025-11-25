// --- DATA MODEL ---
class RegistrationData {
  final int no;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin; // 'L' atau 'P'
  final String fotoIdentitasAsset;
  final String statusRegistrasi; // Pending / Diterima / Ditolak

  const RegistrationData({
    required this.no,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.fotoIdentitasAsset,
    required this.statusRegistrasi,
  });
}

// --- DUMMY DATA ---
final List<RegistrationData> dummyRegistrationData = const [
  RegistrationData(
    no: 1,
    nama: 'Mara Nunez',
    nik: '1234567890123456',
    email: 'mara.nunez@gmail.com',
    jenisKelamin: 'P',
    fotoIdentitasAsset: 'assets/1.png',
    statusRegistrasi: 'Pending',
  ),
  RegistrationData(
    no: 2,
    nama: 'Sinta Sulistya',
    nik: '1234567890987654',
    email: 'sinta.sulistya@gmail.com',
    jenisKelamin: 'P',
    fotoIdentitasAsset: 'assets/2.png',
    statusRegistrasi: 'Pending',
  ),
  RegistrationData(
    no: 3,
    nama: 'Intan Sari',
    nik: '2025202520252025',
    email: 'intan.sari@gmail.com',
    jenisKelamin: 'P',
    fotoIdentitasAsset: 'assets/3.png',
    statusRegistrasi: 'Pending',
  ),
  RegistrationData(
    no: 4,
    nama: 'Abdul Aziz',
    nik: '3201122501050002',
    email: 'abdul.aziz@gmail.com',
    jenisKelamin: 'L',
    fotoIdentitasAsset: 'assets/4.png',
    statusRegistrasi: 'Pending',
  ),
  RegistrationData(
    no: 5,
    nama: 'Budi Pratama',
    nik: '3201122501050003',
    email: 'budi.pratama@gmail.com',
    jenisKelamin: 'L',
    fotoIdentitasAsset: 'assets/5.png',
    statusRegistrasi: 'Diterima',
  ),
  RegistrationData(
    no: 6,
    nama: 'Dewi Kartika',
    nik: '3201122501050004',
    email: 'dewi.kartika@gmail.com',
    jenisKelamin: 'P',
    fotoIdentitasAsset: 'assets/6.png',
    statusRegistrasi: 'Diterima',
  ),
  RegistrationData(
    no: 7,
    nama: 'Eko Saputra',
    nik: '3201122501050005',
    email: 'eko.saputra@gmail.com',
    jenisKelamin: 'L',
    fotoIdentitasAsset: 'assets/7.png',
    statusRegistrasi: 'Diterima',
  ),
  RegistrationData(
    no: 8,
    nama: 'Fitri Ananda',
    nik: '3201122501050006',
    email: 'fitri.ananda@gmail.com',
    jenisKelamin: 'P',
    fotoIdentitasAsset: 'assets/8.png',
    statusRegistrasi: 'Ditolak',
  ),
  RegistrationData(
    no: 9,
    nama: 'Gilang Ramadan',
    nik: '3201122501050007',
    email: 'gilang.ramadan@gmail.com',
    jenisKelamin: 'L',
    fotoIdentitasAsset: 'assets/9.png',
    statusRegistrasi: 'Ditolak',
  ),
];

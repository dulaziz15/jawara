// mutasi_model.dart
class MutasiData {
  final int no;
  final String keluarga;
  final String alamatLama;
  final String alamatBaru;
  final String tanggalMutasi;
  final String jenisMutasi;
  final String alasan;

  const MutasiData({
    required this.no,
    required this.keluarga,
    required this.alamatLama,
    required this.alamatBaru,
    required this.tanggalMutasi,
    required this.jenisMutasi,
    required this.alasan,
  });

  // Method untuk membuat copy dengan perubahan tertentu
  MutasiData copyWith({
    int? no,
    String? keluarga,
    String? alamatLama,
    String? alamatBaru,
    String? tanggalMutasi,
    String? jenisMutasi,
    String? alasan,
  }) {
    return MutasiData(
      no: no ?? this.no,
      keluarga: keluarga ?? this.keluarga,
      alamatLama: alamatLama ?? this.alamatLama,
      alamatBaru: alamatBaru ?? this.alamatBaru,
      tanggalMutasi: tanggalMutasi ?? this.tanggalMutasi,
      jenisMutasi: jenisMutasi ?? this.jenisMutasi,
      alasan: alasan ?? this.alasan,
    );
  }

  // Convert to Map untuk serialization
  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'keluarga': keluarga,
      'alamatLama': alamatLama,
      'alamatBaru': alamatBaru,
      'tanggalMutasi': tanggalMutasi,
      'jenisMutasi': jenisMutasi,
      'alasan': alasan,
    };
  }

  // Create from Map untuk deserialization
  factory MutasiData.fromMap(Map<String, dynamic> map) {
    return MutasiData(
      no: map['no'] as int,
      keluarga: map['keluarga'] as String,
      alamatLama: map['alamatLama'] as String,
      alamatBaru: map['alamatBaru'] as String,
      tanggalMutasi: map['tanggalMutasi'] as String,
      jenisMutasi: map['jenisMutasi'] as String,
      alasan: map['alasan'] as String,
    );
  }

  @override
  String toString() {
    return 'MutasiData(no: $no, keluarga: $keluarga, jenisMutasi: $jenisMutasi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MutasiData &&
        other.no == no &&
        other.keluarga == keluarga &&
        other.alamatLama == alamatLama &&
        other.alamatBaru == alamatBaru &&
        other.tanggalMutasi == tanggalMutasi &&
        other.jenisMutasi == jenisMutasi &&
        other.alasan == alasan;
  }

  @override
  int get hashCode {
    return no.hashCode ^
        keluarga.hashCode ^
        alamatLama.hashCode ^
        alamatBaru.hashCode ^
        tanggalMutasi.hashCode ^
        jenisMutasi.hashCode ^
        alasan.hashCode;
  }
}

// Data Dummy Provider
class MutasiDataProvider {
  static const List<MutasiData> dummyData = [
    MutasiData(
      no: 1,
      keluarga: 'Keluarga Rendha Putra Rahmadya',
      alamatLama: 'Jl. Merdeka No. 123, Jakarta Pusat',
      alamatBaru: 'Jl. Sudirman No. 456, Jakarta Selatan',
      tanggalMutasi: '15-10-2025',
      jenisMutasi: 'Pindah Domisili',
      alasan: 'Pekerjaan',
    ),
    MutasiData(
      no: 2,
      keluarga: 'Keluarga Anti Micin',
      alamatLama: 'Jl. Pahlawan No. 78, Bandung',
      alamatBaru: 'Jl. Gatot Subroto No. 90, Surabaya',
      tanggalMutasi: '20-10-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Pendidikan',
    ),
    MutasiData(
      no: 3,
      keluarga: 'Keluarga Varizky Naldiba Rimra',
      alamatLama: 'Jl. Melati No. 11, Yogyakarta',
      alamatBaru: 'Jl. Kenanga No. 22, Semarang',
      tanggalMutasi: '25-10-2025',
      jenisMutasi: 'Pindah Domisili',
      alasan: 'Keluarga',
    ),
    MutasiData(
      no: 4,
      keluarga: 'Keluarga Ijat',
      alamatLama: 'Jl. Mawar No. 33, Medan',
      alamatBaru: 'Jl. Anggrek No. 44, Palembang',
      tanggalMutasi: '30-10-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Bisnis',
    ),
    MutasiData(
      no: 5,
      keluarga: 'Keluarga Raudhli Firdaus Naufal',
      alamatLama: 'Jl. Diponegoro No. 55, Semarang',
      alamatBaru: 'Jl. Ahmad Yani No. 66, Jakarta',
      tanggalMutasi: '05-11-2025',
      jenisMutasi: 'Pindah Provinsi',
      alasan: 'Pekerjaan',
    ),
    MutasiData(
      no: 6,
      keluarga: 'Keluarga Surya Dharma',
      alamatLama: 'Jl. Gajah Mada No. 77, Denpasar',
      alamatBaru: 'Jl. Thamrin No. 88, Medan',
      tanggalMutasi: '10-11-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Bisnis',
    ),
    MutasiData(
      no: 7,
      keluarga: 'Keluarga Putri Maharani',
      alamatLama: 'Jl. Merpati No. 99, Malang',
      alamatBaru: 'Jl. Rajawali No. 111, Surabaya',
      tanggalMutasi: '15-11-2025',
      jenisMutasi: 'Pindah Domisili',
      alasan: 'Pendidikan',
    ),
    MutasiData(
      no: 8,
      keluarga: 'Keluarga Ahmad Fauzi',
      alamatLama: 'Jl. Cendrawasih No. 222, Bogor',
      alamatBaru: 'Jl. Elang No. 333, Bandung',
      tanggalMutasi: '20-11-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Keluarga',
    ),
    MutasiData(
      no: 9,
      keluarga: 'Keluarga Sari Indah',
      alamatLama: 'Jl. Kenari No. 444, Yogyakarta',
      alamatBaru: 'Jl. Merak No. 555, Solo',
      tanggalMutasi: '25-11-2025',
      jenisMutasi: 'Pindah Domisili',
      alasan: 'Pekerjaan',
    ),
    MutasiData(
      no: 10,
      keluarga: 'Keluarga Budi Santoso',
      alamatLama: 'Jl. Jalak No. 666, Surakarta',
      alamatBaru: 'Jl. Kutilang No. 777, Semarang',
      tanggalMutasi: '30-11-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Bisnis',
    ),
  ];

  // Method untuk mendapatkan jenis mutasi yang tersedia
  static List<String> getAvailableJenisMutasi() {
    final jenisSet = <String>{'Semua'};
    for (var data in dummyData) {
      jenisSet.add(data.jenisMutasi);
    }
    return jenisSet.toList();
  }
}
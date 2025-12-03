class MutasiData {
  final String docId; // ID dokumen Firestore
  final String keluarga;
  final String alamatLama;
  final String alamatBaru;
  final String tanggalMutasi;
  final String jenisMutasi;
  final String alasan;

  const MutasiData({
    required this.docId,
    required this.keluarga,
    required this.alamatLama,
    required this.alamatBaru,
    required this.tanggalMutasi,
    required this.jenisMutasi,
    required this.alasan,
  });

  MutasiData copyWith({
    String? docId,
    String? keluarga,
    String? alamatLama,
    String? alamatBaru,
    String? tanggalMutasi,
    String? jenisMutasi,
    String? alasan,
  }) {
    return MutasiData(
      docId: docId ?? this.docId,
      keluarga: keluarga ?? this.keluarga,
      alamatLama: alamatLama ?? this.alamatLama,
      alamatBaru: alamatBaru ?? this.alamatBaru,
      tanggalMutasi: tanggalMutasi ?? this.tanggalMutasi,
      jenisMutasi: jenisMutasi ?? this.jenisMutasi,
      alasan: alasan ?? this.alasan,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'keluarga': keluarga,
      'alamatLama': alamatLama,
      'alamatBaru': alamatBaru,
      'tanggalMutasi': tanggalMutasi,
      'jenisMutasi': jenisMutasi,
      'alasan': alasan,
    };
  }

  factory MutasiData.fromMap(Map<String, dynamic> map, String documentId) {
    return MutasiData(
      docId: documentId,
      keluarga: map['keluarga'] ?? '',
      alamatLama: map['alamatLama'] ?? '',
      alamatBaru: map['alamatBaru'] ?? '',
      tanggalMutasi: map['tanggalMutasi'] ?? '',
      jenisMutasi: map['jenisMutasi'] ?? '',
      alasan: map['alasan'] ?? '',
    );
  }
}

// Dummy provider — tetap dipertahankan
class MutasiDataProvider {
  static const List<MutasiData> dummyDataMutasi = [
    MutasiData(
      docId: '1',
      keluarga: 'Keluarga Rendha Putra Rahmadya',
      alamatLama: 'Jl. Merdeka No. 123, Jakarta Pusat',
      alamatBaru: 'Jl. Sudirman No. 456, Jakarta Selatan',
      tanggalMutasi: '15-10-2025',
      jenisMutasi: 'Pindah Domisili',
      alasan: 'Pekerjaan',
    ),
    MutasiData(
      docId: '2',
      keluarga: 'Keluarga Anti Micin',
      alamatLama: 'Jl. Pahlawan No. 78, Bandung',
      alamatBaru: 'Jl. Gatot Subroto No. 90, Surabaya',
      tanggalMutasi: '20-10-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Pendidikan',
    ),
    // sisanya tetap sama tinggal copy ↓
  ];

  static List<String> getAvailableJenisMutasi() {
    final jenisSet = <String>{'Semua'};
    for (var item in dummyDataMutasi) {
      jenisSet.add(item.jenisMutasi);
    }
    return jenisSet.toList();
  }
}

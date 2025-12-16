class WargaModel {
  final String docId; // ID Dokumen Firestore
  final String nik; // NIK sebagai unique key bisnis
  final String nama;
  final String keluarga; // Bisa referensi ID Keluarga atau Nama Keluarga
  final DateTime? tanggalLahir; // Tanggal Lahir (opsional)
  final String jenisKelamin;
  final String statusDomisili;
  final String statusHidup;

  WargaModel({
    required this.docId,
    required this.nik,
    required this.nama,
    required this.keluarga,
    this.tanggalLahir,
    required this.jenisKelamin,
    required this.statusDomisili,
    required this.statusHidup,
  });

  // Convert dari Map (Firestore) ke Object
  factory WargaModel.fromMap(Map<String, dynamic> map, String id) {
    return WargaModel(
      docId: id,
      nik: map['nik'] as String? ?? '',
      nama: map['nama'] as String? ?? 'tanpa nama',
      keluarga: map['keluarga'] as String? ?? '',
      // Parse tanggal lahir jika ada
      tanggalLahir: map['tanggalLahir'] != null ? DateTime.tryParse(map['tanggalLahir'] as String) : null,
      jenisKelamin: map['jenisKelamin'] as String? ?? 'Laki-laki',
      statusDomisili: map['statusDomisili'] as String? ?? 'Aktif',
      statusHidup: map['statusHidup'] as String? ?? 'Hidup',
    );
  }

  // Convert dari Object ke Map (untuk simpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nik': nik,
      'nama': nama,
      'keluarga': keluarga,
      'tanggalLahir': tanggalLahir?.toIso8601String(),
      'jenisKelamin': jenisKelamin,
      'statusDomisili': statusDomisili,
      'statusHidup': statusHidup,
    };
  }
}
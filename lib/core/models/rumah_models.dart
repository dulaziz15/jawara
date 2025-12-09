class RumahModel {
  final String id;      // ID Dokumen (untuk keperluan koding/query)
  final String no;      // Nomor Rumah (Data yang tampil)
  final String alamat;
  final String status;

  RumahModel({
    required this.id,
    required this.no,
    required this.alamat,
    required this.status,
  });

  factory RumahModel.fromMap(Map<String, dynamic> map, String docId) {
    return RumahModel(
      id: docId,
      // Ambil 'no' dari database, kalau null kasih string kosong
      no: map['no'] as String? ?? '', 
      alamat: map['alamat'] as String? ?? '',
      status: map['status'] as String? ?? 'Tersedia',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'alamat': alamat,
      'status': status,
    };
  }
}
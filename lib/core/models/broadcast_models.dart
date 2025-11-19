// model untuk broadcast
class BroadcastModels {
  int? id;
  String judulBroadcast, isiPesan, kategoriBroadcast, lampiranGambar, lampiranDokumen; 
  int dibuatOlehId; // **DIREVISI:** Relasi ke UserModel.id
  DateTime tanggalPublikasi;

  BroadcastModels({
    this.id,
    required this.judulBroadcast,
    required this.isiPesan,
    required this.kategoriBroadcast,
    required this.tanggalPublikasi,
    required this.dibuatOlehId, // **DIREVISI**
    required this.lampiranGambar,
    required this.lampiranDokumen,
  });

  // konversi dari map ke object
  factory BroadcastModels.fromMap(Map<String, dynamic> map) {
    return BroadcastModels(
      id: map['id'],
      judulBroadcast: map['judulBroadcast'],
      tanggalPublikasi: DateTime.parse(map['tanggalPublikasi']),
      isiPesan: map['isiPesan'],
      kategoriBroadcast: map['kategoriBroadcast'],
      dibuatOlehId: map['dibuatOlehId'], // Menggunakan ID
      lampiranGambar: map['lampiranGambar'],
      lampiranDokumen: map['lampiranDokumen'],
    );
  }

  // konversi dari object ke map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judulBroadcast': judulBroadcast,
      'isiPesan': isiPesan,
      'kategoriBroadcast': kategoriBroadcast,
      'tanggalPublikasi': tanggalPublikasi.toIso8601String(),
      'dibuatOlehId': dibuatOlehId, // Menggunakan ID
      'lampiranGambar': lampiranGambar,
      'lampiranDokumen': lampiranDokumen,
    };
  }
}

List<BroadcastModels> dummyBroadcast = [
  BroadcastModels(
    id: 1,
    judulBroadcast: 'Pengumuman Libur Nasional',
    isiPesan: 'Hari Senin, 20 Oktober 2025, akan diliburkan karena perayaan Hari Nasional.',
    kategoriBroadcast: 'Pengumuman',
    tanggalPublikasi: DateTime(2025, 10, 16),
    dibuatOlehId: 101, // ID Admin Jawara
    lampiranGambar: 'libur_nasional.jpg',
    lampiranDokumen: 'libur_nasional.pdf',
  ),
  // ... (sisanya menggunakan ID 101)
];
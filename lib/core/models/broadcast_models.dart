// model untuk broadcast
import 'package:cloud_firestore/cloud_firestore.dart';

class BroadcastModels {
  String docId;
  String judulBroadcast, isiPesan, kategoriBroadcast, lampiranGambar, lampiranDokumen; 
  String dibuatOlehId; // **DIREVISI:** Relasi ke UserModel.id
  DateTime tanggalPublikasi;

  BroadcastModels({
    required this.docId,
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
      docId: map['docId'],
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
      'docId': docId,
      'judulBroadcast': judulBroadcast,
      'isiPesan': isiPesan,
      'kategoriBroadcast': kategoriBroadcast,
      'tanggalPublikasi': tanggalPublikasi.toIso8601String(),
      'dibuatOlehId': dibuatOlehId, // Menggunakan ID
      'lampiranGambar': lampiranGambar,
      'lampiranDokumen': lampiranDokumen,
    };
  }

  // static BroadcastModels fromFirestore(DocumentSnapshot<Object?> snap) {}
}

List<BroadcastModels> dummyBroadcast = [
  BroadcastModels(
    docId: "1",
    judulBroadcast: 'Pengumuman Libur Nasional',
    isiPesan: 'Hari Senin, 20 Oktober 2025, akan diliburkan karena perayaan Hari Nasional.',
    kategoriBroadcast: 'Pengumuman',
    tanggalPublikasi: DateTime(2025, 10, 16),
    dibuatOlehId: '101', // ID Admin Jawara
    lampiranGambar: 'libur_nasional.jpg',
    lampiranDokumen: 'libur_nasional.pdf',
  ),
  // ... (sisanya menggunakan ID 101)
];
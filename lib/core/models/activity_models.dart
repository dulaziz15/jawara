import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String docId ; // ID dokumen Firestore
  final String description;
  final String actor; 
  // 💡 PERUBAHAN: Menggunakan DateTime untuk mempermudah sorting dan filtering
  final DateTime date; 

  const ActivityModel({
    required this.docId,
    required this.description,
    required this.actor,
    required this.date,
  });

  // Konversi dari Object ke Map (Untuk Firestore Write/Simpan)
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'description': description,
      'actor': actor,
      // 🔑 Mengubah DateTime menjadi Timestamp (Tipe data ideal di Firestore)
      'date': Timestamp.fromDate(date), 
    };
  }

  // Konversi dari Map ke Object (Untuk Firestore Read/Ambil)
  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      docId: map['docId'] as String,
      description: map['description'] as String,
      actor: map['actor'] as String,
      // 🔑 Mengubah Timestamp dari Firestore menjadi DateTime di Dart
      date: (map['date'] as Timestamp).toDate(), 
    );
  }
}
/// === DATA DUMMY (Setelah Konversi ke DateTime) ===
final List<ActivityModel> daftarAktivitas = [
  ActivityModel(
    docId: "1",
    description: 'Menambahkan rumah baru dengan alamat: fasda',
    actor: 'Admin Jawara',
    // 10 Oktober 2025
    date: DateTime(2025, 10, 10), 
  ),
  ActivityModel(
    docId: "2",
    description: 'Menyetujui pesan warga: tes',
    actor: 'Admin Jawara',
    // 11 Oktober 2025
    date: DateTime(2025, 10, 11), 
  ),
  ActivityModel(
    docId: "3",
    description: 'Menghapus event: Lomba 17agustus pada ate 16 Agustus 2025',
    actor: 'Admin Jawara',
    // 14 Oktober 2025
    date: DateTime(2025, 10, 14), 
  ),
  ActivityModel(
    docId: "4",
    description: 'Menambahkan pengguna baru: John Doe',
    actor: 'Admin Jawara',
    // 15 Oktober 2025
    date: DateTime(2025, 10, 15), 
  ),
  ActivityModel(
    docId: "5",
    description: 'Mengedit data warga: Jane Smith',
    actor: 'Admin Jawara',
    // 16 Oktober 2025
    date: DateTime(2025, 10, 16), 
  ),

];
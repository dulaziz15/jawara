import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String docId;
  final String description;
  final String actor;
  final DateTime date;

  const ActivityModel({
    required this.docId,
    required this.description,
    required this.actor,
    required this.date,
  });

  // Konversi ke Map (Simpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'actor': actor,
      'date': Timestamp.fromDate(date), // DateTime -> Timestamp
    };
  }

  // Konversi dari Map (Ambil dari Firestore)
  factory ActivityModel.fromMap(Map<String, dynamic> map, String docId) {
    return ActivityModel(
      docId: docId,
      description: map['description'] ?? '',
      actor: map['actor'] ?? 'System',
      // Handle jika data null atau format Timestamp
      date: (map['date'] is Timestamp) 
          ? (map['date'] as Timestamp).toDate() 
          : DateTime.now(),
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
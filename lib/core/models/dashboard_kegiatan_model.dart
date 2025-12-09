import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardKegiatanModel {
  final String id;           // Firestore doc.id
  final String actor;        // "Admin Jawara"
  final String description;  // "Mengedit data warga..."
  final String docId;        // "5"
  final DateTime date;       // Timestamp

  DashboardKegiatanModel({
    required this.id,
    required this.actor,
    required this.description,
    required this.docId,
    required this.date,
  });

  // FROM FIRESTORE
  factory DashboardKegiatanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DashboardKegiatanModel(
      id: doc.id,
      actor: data['actor'] ?? '',
      description: data['description'] ?? '',
      docId: data['docId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // TO MAP (ADD / UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'actor': actor,
      'description': description,
      'docId': docId,
      'date': Timestamp.fromDate(date),
    };
  }
}

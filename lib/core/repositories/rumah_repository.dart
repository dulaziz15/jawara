import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/rumah_models.dart';

class RumahRepository {
  final CollectionReference _collection = 
      FirebaseFirestore.instance.collection('rumah');

  Stream<List<RumahModel>> getAllRumah() {
    // Bisa diurutkan berdasarkan 'no' biar rapi
    return _collection.orderBy('no').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RumahModel.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      }).toList();
    });
  }

  Future<void> addRumah(String no, String alamat, String status) async {
    await _collection.add({
      'no': no,
      'alamat': alamat,
      'status': status,
      'created_at': FieldValue.serverTimestamp(), // Opsional: untuk sorting
    });
  }

  // Update sekarang menerima 'no' juga
  Future<void> updateRumah(String docId, String no, String alamat, String status) async {
    await _collection.doc(docId).update({
      'no': no,
      'alamat': alamat,
      'status': status,
    });
  }

  Future<void> deleteRumah(String docId) async {
    await _collection.doc(docId).delete();
  }
}
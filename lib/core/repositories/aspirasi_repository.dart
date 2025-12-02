import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/aspirasi_models.dart'; 

class AspirasiRepository {
  // Nama collection di Firestore
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('aspirasi');

  // READ: Ambil data secara Realtime (Stream)
  Stream<List<AspirasiModels>> getAspirasi() {
    return _collection
        .orderBy('tanggalPublikasi', descending: true) // Urutkan dari yang terbaru
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AspirasiModels.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> updateAspirasi(AspirasiModels aspirasi) async {
    try {
      await _collection.doc(aspirasi.docId).update(aspirasi.toMap());
    } catch (e) {
      throw Exception('Gagal mengupdate data: $e');
    }
  }

  // DELETE: Hapus Aspirasi
  Future<void> deleteAspirasi(String docId) async {
    try {
      await _collection.doc(docId).delete();
    } catch (e) {
      throw Exception('Gagal menghapus data: $e');
    }
  }

  // (Opsional) UPDATE: Update Status jika diperlukan
  Future<void> updateStatus(String docId, String newStatus) async {
    try {
      await _collection.doc(docId).update({'kategoriBroadcast': newStatus});
    } catch (e) {
      throw Exception('Gagal update status: $e');
    }
  }

  Future<AspirasiModels?> getAspirasiByDocId(String docId) async {
    try {
      final doc = await _collection.doc(docId).get();
      if (doc.exists && doc.data() != null) {
        return AspirasiModels.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      }
      return null;
    } catch (e) {
      // Return null atau throw error sesuai kebutuhan
      print("Error getById: $e");
      return null;
    }
  }
}
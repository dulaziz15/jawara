import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/pemasukan_model.dart';

class PemasukanRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _pemasukanCollection = FirebaseFirestore.instance
      .collection('pemasukan');

  // ==========================================================
  // PEMASUKAN (CRUD Penuh)
  // ==========================================================
  
  // C: Create
  Future<void> addPemasukan(PemasukanModel pemasukan) async =>
      await _pemasukanCollection.add(pemasukan.toMap());

  // R: Get Pemasukan (Stream - Realtime List)
  Stream<List<PemasukanModel>> getPemasukan() {
    return _pemasukanCollection
        .orderBy('tanggal_pemasukan', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // Perbaikan: Gunakan parameter kedua untuk docId
            return PemasukanModel.fromMap(data, doc.id); 
          }).toList();
        });
  }

  // U: Update Pemasukan
  Future<void> updatePemasukan(PemasukanModel pemasukan) async {
    // Pastikan docId tidak null sebelum update
    if (pemasukan.docId == null) return;
    
    await _pemasukanCollection
        .doc(pemasukan.docId) // docId sudah String, tidak perlu to String
        .update(pemasukan.toMap());
  }

  // D: Delete Pemasukan
  Future<void> deletePemasukan(String docId) async =>
      await _pemasukanCollection.doc(docId).delete();

  // R: Get Pemasukan by doc id (Future - Single Data)
  Future<PemasukanModel?> getPemasukanByDocId(String docId) async {
    try {
      // PERBAIKAN 1: Gunakan _pemasukanCollection (variable yang benar)
      final docSnapshot = await _pemasukanCollection.doc(docId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        
        // PERBAIKAN 2: Return PemasukanModel (Bukan PengeluaranModel)
        // PERBAIKAN 3: Masukkan data dan docSnapshot.id terpisah
        return PemasukanModel.fromMap(data, docSnapshot.id);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal ambil data: $e');
    }
  }
}
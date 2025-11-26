import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';

class PengeluaranRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _pengeluaranCollection = FirebaseFirestore.instance
      .collection('pengeluaran');

  // ==========================================================
  // PENGELUARAN (CRUD Penuh)
  // ==========================================================
  
  // C: Create
  Future<void> addPengeluaran(PengeluaranModel pengeluaran) async =>
      await _pengeluaranCollection.add(pengeluaran.toMap());

  // R: Get Pengeluaran (Stream List)
  Stream<List<PengeluaranModel>> getPengeluaran() {
    return _pengeluaranCollection
        .orderBy('tanggal_pengeluaran', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            
            // PERBAIKAN: Gunakan 2 parameter (Map data, String docId)
            // Sesuai dengan Model yang sudah kita ubah sebelumnya
            return PengeluaranModel.fromMap(data, doc.id); 
          }).toList();
        });
  }

  // U: Update Pengeluaran
  Future<void> updatePengeluaran(PengeluaranModel pengeluaran) async {
    // Pastikan kita punya ID Dokumen untuk diupdate
    // (Gunakan field docId atau docId sesuai nama di Model Anda)
    if (pengeluaran.docId.isEmpty) return; 

    await _pengeluaranCollection
        .doc(pengeluaran.docId) 
        .update(pengeluaran.toMap());
  }

  // D: Delete Pengeluaran
  Future<void> deletePengeluaran(String docId) async =>
      await _pengeluaranCollection.doc(docId).delete();

  // R: Get Single Detail by Document ID (Future)
  // Fungsi ini dipanggil oleh Halaman Detail
  Future<PengeluaranModel?> getPengeluaranByDocId(String docId) async {
    try {
      // PERBAIKAN: Gunakan .doc(docId).get() 
      // Karena docId adalah String alamat dokumen, bukan field 'id' (angka)
      final docSnapshot = await _pengeluaranCollection.doc(docId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        
        // PERBAIKAN: Masukkan data dan ID dokumen terpisah
        return PengeluaranModel.fromMap(data, docSnapshot.id);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal ambil data: $e');
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';

class PengeluaranRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _pengeluaranCollection = FirebaseFirestore.instance
      .collection('pengeluaran');

  // ==========================================================
  // PENGELUARAN (CRUD Penuh)
  // ==========================================================
  Future<void> addPengeluaran(PengeluaranModel pengeluaran) async =>
      await _pengeluaranCollection.add(pengeluaran.toMap());

  // R: Get Pengeluaran (Stream)
  Stream<List<PengeluaranModel>> getPengeluaran() {
    return _pengeluaranCollection
        .orderBy('tanggal_pengeluaran', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return PengeluaranModel.fromMap({...data});
          }).toList();
        });
  }

  // U: Update Pengeluaran
  Future<void> updatePengeluaran(PengeluaranModel pengeluaran) async =>
      await _pengeluaranCollection
          .doc(pengeluaran.id.toString())
          .update(pengeluaran.toMap());

  // D: Delete Pengeluaran
  Future<void> deletePengeluaran(String pengeluaranId) async =>
      await _pengeluaranCollection.doc(pengeluaranId).delete();

  // R: Get Pengeluaran by int id (Future)
  Future<PengeluaranModel?> getPengeluaranByIntId(int id) async {
  try {
    final snapshot = await _pengeluaranCollection
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      
      // PANGGIL with fromMap (Sekarang pakai 2 parameter)
      return PengeluaranModel.fromMap(data);
    }
    return null;
  } catch (e) {
    throw Exception('Gagal: $e');
  }
}
}

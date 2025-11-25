import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/pemasukan_model.dart';

class PemasukanRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _pemasukanCollection = FirebaseFirestore.instance
      .collection('pemasukan');

  // ==========================================================
  // PEMASUKAN (CRUD Penuh)
  // ==========================================================
  Future<void> addPemasukan(PemasukanModel pemasukan) async =>
      await _pemasukanCollection.add(pemasukan.toMap());

  // R: Get Pemasukan (Stream)
  Stream<List<PemasukanModel>> getPemasukan() {
    return _pemasukanCollection
        .orderBy('tanggal_pemasukan', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return PemasukanModel.fromMap({...data});
          }).toList();
        });
  }

  // U: Update Pemasukan
  Future<void> updatePemasukan(PemasukanModel pemasukan) async =>
      await _pemasukanCollection
          .doc(pemasukan.id.toString())
          .update(pemasukan.toMap());

  // D: Delete Pemasukan
  Future<void> deletePemasukan(String pemasukanId) async =>
      await _pemasukanCollection.doc(pemasukanId).delete();

  // R: Get Pemasukan by int id (Future)
  Future<PemasukanModel?> getPemasukanByIntId(int id) async {
    try {
      final snapshot = await _pemasukanCollection
          .where('id', isEqualTo: id)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        // PANGGIL with fromMap (Sekarang pakai 2 parameter)
        return PemasukanModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal: $e');
    }
  }
}

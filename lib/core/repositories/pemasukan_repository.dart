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
            return PemasukanModel.fromMap({...data, 'id': doc.id});
          }).toList();
        });
  }

  Future<void> updatePemasukan(PemasukanModel pemasukan) async =>
      await _pemasukanCollection
          .doc(pemasukan.id.toString())
          .update(pemasukan.toMap());
          
  Future<void> deletePemasukan(String pemasukanId) async =>
      await _pemasukanCollection.doc(pemasukanId).delete();
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/pemasukan_model.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';

class FinanceRepository {
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
            return PengeluaranModel.fromMap({...data, 'id': doc.id});
          }).toList();
        });
  }

  Future<void> updatePengeluaran(PengeluaranModel pengeluaran) async =>
      await _pengeluaranCollection
          .doc(pengeluaran.id.toString())
          .update(pengeluaran.toMap());
          
  Future<void> deletePengeluaran(String pengeluaranId) async =>
      await _pengeluaranCollection.doc(pengeluaranId).delete();
}

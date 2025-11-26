import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/iuran_models.dart';

class IuranRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _iuranCollection = FirebaseFirestore.instance
      .collection('iuran');

  // ==========================================================
  // IURAN (CRUD Penuh)
  // ==========================================================
  Future<void> addIuran(IuranModel iuran) async =>
      await _iuranCollection.add(iuran.toMap());

  // R: Get Iuran (Stream)
  Stream<List<IuranModel>> getIuran() {
    return _iuranCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return IuranModel.fromMap({...data, 'docId': doc.id});
      }).toList();
    });
  }

  // U: Update Iuran 
  Future<void> updateIuran(IuranModel iuran) async =>
      await _iuranCollection
          .doc(iuran.docId.toString())
          .update(iuran.toMap());

  // D: Delete Iuran 
  Future<void> deleteIuran(String iuranId) async =>
      await _iuranCollection.doc(iuranId).delete();
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/kegiatan_models.dart';

class KegiatanRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _kegiatanCollection = FirebaseFirestore.instance
      .collection('kegiatan');
 
  // ==========================================================
  // KEGIATAN (CRUD Penuh)
  // ==========================================================
  Future<void> addKegiatan(KegiatanModel kegiatan) async =>
      await _kegiatanCollection.add(kegiatan.toMap());

  // R
  Stream<List<KegiatanModel>> getKegiatan() {
    return _kegiatanCollection
        .orderBy('tanggal_pelaksanaan', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return KegiatanModel.fromMap({...data, 'docId': doc.id});
          }).toList();
        });
  }

  // R: Get Kegiatan by DocId
  Future<KegiatanModel?> getKegiatanByDocId(String docId) async {
    try {
      final doc = await _kegiatanCollection.doc(docId).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // Pastikan ID dokumen disertakan
        return KegiatanModel.fromMap({...data, 'docId': doc.id});
      }
      return null;
    } catch (e) {
      // Anda bisa log error di sini
      return null;
    }
  }

  // U
  Future<void> updateKegiatan(KegiatanModel kegiatan) async =>
      await _kegiatanCollection
          .doc(kegiatan.docId.toString())
          .update(kegiatan.toMap());

  // D
  Future<void> deleteKegiatan(String kegiatanId) async =>
      await _kegiatanCollection.doc(kegiatanId).delete();

}

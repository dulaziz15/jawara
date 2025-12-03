import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/kegiatan_models.dart';

class KegiatanRepository {
  final CollectionReference _kegiatanCollection =
      FirebaseFirestore.instance.collection('kegiatan');

  // ==========================================================
  // ADD (C)
  // ==========================================================
  Future<void> addKegiatan(KegiatanModel kegiatan) async {
  try {
    // 1️⃣ siapkan data tanpa docId agar Firestore generate ID otomatis
    final data = kegiatan.toMap();
    data.remove('docId');

    // 2️⃣ add dulu ke Firestore dan dapatkan document reference
    final docRef = await _kegiatanCollection.add(data);

    // 3️⃣ update field docId pada dokumen yang baru dibuat
    await docRef.update({'docId': docRef.id});

  } catch (e) {
    throw Exception("Gagal menambahkan kegiatan: $e");
  }
}

  // ==========================================================
  // READ (R)
  // ==========================================================

  Stream<List<KegiatanModel>> getKegiatan() {
    return _kegiatanCollection
        .orderBy('tanggal_pelaksanaan', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return KegiatanModel.fromMap({
              ...data,
              'docId': doc.id, // docId disisipkan manual dari Firestore
            });
          }).toList();
        });
  }

  // ==========================================================
  // UPDATE (U)
  // ==========================================================
  Future<void> updateKegiatan(KegiatanModel kegiatan) async {
    try {
      final data = kegiatan.toMap();
      data.remove('docId'); // docId tidak ikut diupdate ke Firestore
      await _kegiatanCollection.doc(kegiatan.docId).update(data);
    } catch (e) {
      throw Exception("Gagal mengupdate kegiatan: $e");
    }
  }

  // ==========================================================
  // DELETE (D)
  // ==========================================================
  Future<void> deleteKegiatan(String kegiatanId) async {
    try {
      await _kegiatanCollection.doc(kegiatanId).delete();
    } catch (e) {
      throw Exception("Gagal menghapus kegiatan: $e");
    }
  }
}

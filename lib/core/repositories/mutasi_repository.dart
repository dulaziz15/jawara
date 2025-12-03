import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/mutasi_model.dart';

class MutasiRepository {
  final _collection = FirebaseFirestore.instance.collection('mutasi');

  // Ambil semua mutasi
  Future<List<MutasiData>> getAllMutasi() async {
    try {
      final snapshot = await _collection.get();

      if (snapshot.docs.isEmpty) {
        // jika Firebase kosong, kembalikan dummy
        return MutasiDataProvider.dummyDataMutasi;
      }

      return snapshot.docs
          .map((doc) => MutasiData.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      // jika terjadi error Firebase, gunakan dummy
      return MutasiDataProvider.dummyDataMutasi;
    }
  }

  // Tambah data
  Future<void> addMutasi(MutasiData data) async {
    await _collection.add(data.toMap());
  }

  // Update data
  Future<void> updateMutasi(MutasiData data) async {
    await _collection.doc(data.docId).update(data.toMap());
  }

  // Hapus data
  Future<void> deleteMutasi(String docId) async {
    await _collection.doc(docId).delete();
  }

  // Ambil data berdasarkan ID
  Future<MutasiData?> getMutasiById(String docId) async {
    final doc = await _collection.doc(docId).get();
    if (!doc.exists) return null;
    return MutasiData.fromMap(doc.data()!, doc.id);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/kategori_iuran_models.dart';

class KategoriIuranRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Nama Collection
  final String _collection = 'kategori_iuran';

  // ========================================================================
  // CRUD (Create, Read, Update, Delete)
  // ========================================================================

  // 1. READ: Mengembalikan List<KategoriIuranModel> agar UI mudah membacanya
  Stream<List<KategoriIuranModel>> getKategoriIuranStream() {
    return _firestore
        .collection(_collection)
        .snapshots() // Tidak perlu orderBy nama dulu jika mau filter manual di UI
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return KategoriIuranModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // 2. CREATE: Menerima Model (bukan cuma String)
  Future<void> addKategoriIuran(KategoriIuranModel data) async {
    await _firestore.collection(_collection).add(data.toMap());
  }

  // 3. UPDATE: Edit Data (Method ini tadinya tidak ada di repo Anda)
  Future<void> updateKategoriIuran(KategoriIuranModel data) async {
    await _firestore
        .collection(_collection)
        .doc(data.docId)
        .update(data.toMap());
  }

  // 4. DELETE: Hapus Data
  Future<void> deleteKategoriIuran(String docId) async {
    await _firestore.collection(_collection).doc(docId).delete();
  }
}
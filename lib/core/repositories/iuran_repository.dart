import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/kategori_iuran_models.dart';

class IuranRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========================================================================
  // PERBAIKAN DI SINI: SESUAIKAN DENGAN NAMA DI FIREBASE ANDA
  // ========================================================================
  final String _colMasterIuran = 'iuran';            // Collection Data Utama
  final String _colLabelKategori = 'kategori_iuran'; // Collection Data Dropdown

  // 1. BAGIAN DROPDOWN (Label Kategori)
  Stream<List<String>> getLabelKategori() {
    return _firestore
        .collection(_colLabelKategori)
        .orderBy('nama') // Pastikan field di Firebase namanya 'nama'
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['nama'] as String).toList();
    });
  }

  // 2. BAGIAN CRUD DATA IURAN
  Stream<List<KategoriIuranModel>> getMasterIuran() {
    return _firestore.collection(_colMasterIuran).snapshots().map((snapshot) {
      // DEBUGGING: Cek data masuk di Console
      print("🔥 Mengambil data dari collection: $_colMasterIuran");
      print("🔥 Jumlah dokumen ditemukan: ${snapshot.docs.length}");
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        print("   📄 Data Dokumen ID ${doc.id}: $data"); // Lihat isi data mentah
        
        return KategoriIuranModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  // CREATE
  Future<void> addMasterKategoriIuran(KategoriIuranModel data) async {
    await _firestore.collection(_colMasterIuran).add(data.toMap());
  }

  // UPDATE
  Future<void> updateMasterIuran(KategoriIuranModel data) async {
    await _firestore
        .collection(_colMasterIuran)
        .doc(data.docId)
        .update(data.toMap());
  }

  // DELETE
  Future<void> deleteMasterIuran(String docId) async {
    await _firestore.collection(_colMasterIuran).doc(docId).delete();
  }
}
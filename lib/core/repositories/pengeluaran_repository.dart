import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';

class PengeluaranRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _pengeluaranCollection = FirebaseFirestore.instance
      .collection('pengeluaran');

  // ==========================================================
  // UPLOAD GAMBAR (BUKTI)
  // ==========================================================
  Future<String> uploadBukti(File file) async {
    try {
      final FirebaseStorage _storage = FirebaseStorage.instance;
      String fileName = 'bukti_${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      Reference ref = _storage.ref().child('bukti_pengeluaran/$fileName');

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Gagal upload bukti: $e');
    }
  }
  // ==========================================================
  // PENGELUARAN (CRUD Penuh)
  // ==========================================================

  Future<void> addPengeluaran(PengeluaranModel pengeluaran) async {
    // 1. Generate Doc ID otomatis
    DocumentReference docRef = _pengeluaranCollection.doc();

    // 2. Update model dengan Doc ID baru
    final data = pengeluaran.toMap();
    data['docId'] = docRef.id;

    // 3. Simpan
    await docRef.set(data);
  }

  // R: Get Pengeluaran (Stream List)
  Stream<List<PengeluaranModel>> getPengeluaran() {
    return _pengeluaranCollection
        .orderBy('tanggal_pengeluaran', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // PERBAIKAN: Gunakan 2 parameter (Map data, String docId)
            // Sesuai dengan Model yang sudah kita ubah sebelumnya
            return PengeluaranModel.fromMap(data, doc.id);
          }).toList();
        });
  }

  // U: Update Pengeluaran
  Future<void> updatePengeluaran(PengeluaranModel pengeluaran) async {
    // Pastikan kita punya ID Dokumen untuk diupdate
    // (Gunakan field docId atau docId sesuai nama di Model Anda)
    if (pengeluaran.docId.isEmpty) return;

    await _pengeluaranCollection
        .doc(pengeluaran.docId)
        .update(pengeluaran.toMap());
  }

  // D: Delete Pengeluaran
  Future<void> deletePengeluaran(String docId) async =>
      await _pengeluaranCollection.doc(docId).delete();

  // R: Get Single Detail by Document ID (Future)
  Future<PengeluaranModel?> getPengeluaranByDocId(String docId) async {
    try {
      // PERBAIKAN: Gunakan .doc(docId).get()
      // Karena docId adalah String alamat dokumen, bukan field 'id' (angka)
      final docSnapshot = await _pengeluaranCollection.doc(docId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        // PERBAIKAN: Masukkan data dan ID dokumen terpisah
        return PengeluaranModel.fromMap(data, docSnapshot.id);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal ambil data: $e');
    }
  }
}

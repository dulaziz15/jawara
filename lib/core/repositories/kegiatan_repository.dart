import 'dart:io'; // Tambahkan ini
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Tambahkan ini
import 'package:jawara/core/models/kegiatan_models.dart';
import 'package:path/path.dart' as path; // Pastikan path terinstall

class KegiatanRepository {
  final CollectionReference _kegiatanCollection =
      FirebaseFirestore.instance.collection('kegiatan');
  
  // 1. Instance Storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 2. Fungsi Upload File
  Future<String> uploadFile(File file) async {
    try {
      String fileName = path.basename(file.path);
      String uniqueName = "${DateTime.now().millisecondsSinceEpoch}_$fileName";
      
      // Simpan di folder kegiatan_dokumentasi
      Reference ref = _storage.ref().child('kegiatan_dokumentasi/$uniqueName');
      
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Gagal upload dokumentasi: $e');
    }
  }

  // ==========================================================
  // ADD (C)
  // ==========================================================
  Future<void> addKegiatan(KegiatanModel kegiatan) async {
    try {
      final data = kegiatan.toMap();
      data.remove('docId');
      final docRef = await _kegiatanCollection.add(data);
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
          'docId': doc.id,
        });
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

  // ==========================================================
  // UPDATE (U)
  // ==========================================================
  Future<void> updateKegiatan(KegiatanModel kegiatan) async {
      final data = kegiatan.toMap();
      data.remove('docId'); 
      await _kegiatanCollection.doc(kegiatan.docId).update(data);
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

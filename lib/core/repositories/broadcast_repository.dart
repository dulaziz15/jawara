import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jawara/core/models/broadcast_models.dart';
import 'package:path/path.dart' as path;

class BroadcastRepository {
 // 1. Definisikan _broadcastCollection
  final CollectionReference _broadcastCollection =
      FirebaseFirestore.instance.collection('broadcasts');

  // 2. DEFINISIKAN _storage DI SINI (Ini yang bikin error sebelumnya)
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // --- FUNGSI UPLOAD FILE ---
  Future<String> uploadFile(File file, String folderName) async {
    try {
      // Ambil nama file asli
      String fileName = path.basename(file.path);
      // Buat nama unik dengan timestamp agar tidak bentrok
      String uniqueName = "${DateTime.now().millisecondsSinceEpoch}_$fileName";
      
      // Referensi ke Firebase Storage
      Reference ref = _storage.ref().child('$folderName/$uniqueName');
      
      // Proses Upload
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      
      // Ambil URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Gagal upload file: $e');
    }
  }

  // --- CREATE DATA ---
  Future<void> addBroadcast(BroadcastModels broadcast) async {
    DocumentReference docRef = _broadcastCollection.doc();
    
    // Set ID jika kosong
    if (broadcast.docId.isEmpty) {
      broadcast.docId = docRef.id;
    }
    
    final data = broadcast.toMap();
    await docRef.set(data);
  }

  // R (List)
  Stream<List<BroadcastModels>> getBroadcasts() {
    return _broadcastCollection
        .orderBy('tanggalPublikasi', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return BroadcastModels.fromMap({...data, 'docId': doc.id});
          }).toList();
        });
  }

  // R (Detail - TAMBAHKAN INI)
  Future<BroadcastModels?> getBroadcastByDocId(String docId) async {
    try {
      final doc = await _broadcastCollection.doc(docId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return BroadcastModels.fromMap({...data, 'docId': doc.id});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // U
  Future<void> updateBroadcast(BroadcastModels broadcast) async =>
      await _broadcastCollection.doc(broadcast.docId).update(broadcast.toMap());

  // D
  Future<void> deleteBroadcast(String broadcastId) async =>
      await _broadcastCollection.doc(broadcastId).delete();
}

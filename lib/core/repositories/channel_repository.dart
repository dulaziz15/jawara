import 'dart:io'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:jawara/core/models/channel_models.dart';
import 'package:path/path.dart' as path; 

class ChannelRepository {
  // 1. Instance Firestore
  final CollectionReference _channelCollection = FirebaseFirestore.instance
      .collection('channels');

  // 2. Instance Storage (TAMBAHKAN INI AGAR _storage TIDAK MERAH)
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ==========================================================
  // CHANNEL (CRUD Penuh)
  // ==========================================================
  
  // Upload gambar
  Future<String> uploadImage(File file, String folderName) async {
    try {
      // Membuat nama file unik agar tidak tertimpa
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      
      // Referensi lokasi file di storage (misal: channel_images/qr/123123.jpg)
      Reference ref = _storage.ref().child('$folderName/$fileName');
      
      // Upload file
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      
      // Ambil URL download setelah selesai upload
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  // ==========================================================
  // 2. FUNGSI ADD CHANNEL (Simpan docId ke dalam field)
  // ==========================================================
  Future<void> addChannel(ChannelModel channel) async {
    // A. Buat referensi dokumen kosong dulu untuk mendapatkan ID unik
    DocumentReference docRef = _channelCollection.doc();
    
    // B. Ambil ID yang baru dibuat
    String generatedId = docRef.id;

    // C. Update model dengan ID tersebut
    final data = channel.toMap();
    data['docId'] = generatedId; // <--- INI KUNCINYA

    // D. Simpan data menggunakan .set() bukan .add()
    await docRef.set(data);
  }

  // R: Get Channels (Stream)
  Stream<List<ChannelModel>> getChannels() {
    return _channelCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChannelModel.fromMap({...data, 'docId': doc.id});
      }).toList();
    });
  }

  // U: Update Channel
  Future<void> updateChannel(String docId, Map<String, dynamic> data) async {
    try {
      await _channelCollection.doc(docId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // D: Delete Channel
  Future<void> deleteChannel(String channelId) async =>
      await _channelCollection.doc(channelId).delete();

  // R: Get Channel by ID
  Future<ChannelModel?> getChannelByDocId(String channelId) async {
    final doc = await _channelCollection.doc(channelId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return ChannelModel.fromMap({...data, 'docId': doc.id});
    }
    return null;
  }
}
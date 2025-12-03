import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/broadcast_models.dart';

class BroadcastRepository {
  final CollectionReference _broadcastCollection = 
      FirebaseFirestore.instance.collection('broadcasts');

  // C
  Future<void> addBroadcast(BroadcastModels broadcast) async {
    // Generate ID manual atau biarkan auto-id, tapi kita butuh ID-nya
    // Cara aman: buat doc ref dulu
    DocumentReference docRef = _broadcastCollection.doc();
    final data = broadcast.toMap();
    data['docId'] = docRef.id; // Simpan ID ke dalam field
    
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
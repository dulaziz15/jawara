import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/broadcast_models.dart';

class BroadcastRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _broadcastCollection = 
      FirebaseFirestore.instance.collection('broadcasts');

  // ==========================================================
  // BROADCAST (CRUD Penuh)
  // ==========================================================
  Future<void> addBroadcast(BroadcastModels broadcast) async => await _broadcastCollection.add(broadcast.toMap());
  
  // R
  Stream<List<BroadcastModels>> getBroadcasts() {
    return _broadcastCollection.orderBy('tanggalPublikasi', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return BroadcastModels.fromMap({...data, 'docId': doc.id});
      }).toList();
    });
  }
  
  Future<void> updateBroadcast(BroadcastModels broadcast) async => await _broadcastCollection.doc(broadcast.docId.toString()).update(broadcast.toMap());
  Future<void> deleteBroadcast(String broadcastId) async => await _broadcastCollection.doc(broadcastId).delete();

}
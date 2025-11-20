import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/broadcast_models.dart';
import 'package:jawara/core/models/kegiatan_models.dart';
import 'package:jawara/core/models/activity_models.dart'; 

class BroadcastRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _broadcastCollection = 
      FirebaseFirestore.instance.collection('broadcasts');
  final CollectionReference _kegiatanCollection = 
      FirebaseFirestore.instance.collection('kegiatan');
  final CollectionReference _activityCollection = 
      FirebaseFirestore.instance.collection('activities'); 


  // ==========================================================
  // BROADCAST (CRUD Penuh)
  // ==========================================================
  Future<void> addBroadcast(BroadcastModels broadcast) async => await _broadcastCollection.add(broadcast.toMap());
  
  // R
  Stream<List<BroadcastModels>> getBroadcasts() {
    return _broadcastCollection.orderBy('tanggalPublikasi', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return BroadcastModels.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }
  
  Future<void> updateBroadcast(BroadcastModels broadcast) async => await _broadcastCollection.doc(broadcast.id.toString()).update(broadcast.toMap());
  Future<void> deleteBroadcast(String broadcastId) async => await _broadcastCollection.doc(broadcastId).delete();


  // ==========================================================
  // KEGIATAN (CRUD Penuh)
  // ==========================================================
  Future<void> addKegiatan(KegiatanModel kegiatan) async => await _kegiatanCollection.add(kegiatan.toMap());
  
  // R
  Stream<List<KegiatanModel>> getKegiatan() {
    return _kegiatanCollection.orderBy('tanggal_pelaksanaan', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return KegiatanModel.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }
  
  Future<void> updateKegiatan(KegiatanModel kegiatan) async => await _kegiatanCollection.doc(kegiatan.id.toString()).update(kegiatan.toMap());
  
  // D
  Future<void> deleteKegiatan(String kegiatanId) async => await _kegiatanCollection.doc(kegiatanId).delete();


  // ==========================================================
  // ACTIVITY (Log Audit: CR Saja)
  // ==========================================================
  // C: Tambah Log Aktivitas
  Future<void> addActivity(ActivityModel activity) async => await _activityCollection.add(activity.toMap());
  
  // R: Get Log Aktivitas (Stream)
  Stream<List<ActivityModel>> getActivities() {
    return _activityCollection
        .orderBy('date', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      final activityList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ActivityModel.fromMap({...data, 'id': doc.id}); 
      }).toList();
      return activityList;
    });
  }
  // U & D dihilangkan
}
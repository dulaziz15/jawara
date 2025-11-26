import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/activity_models.dart'; 

class BroadcastRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _activityCollection = 
      FirebaseFirestore.instance.collection('activities'); 

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
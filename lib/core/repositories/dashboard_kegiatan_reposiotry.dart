import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/dashboard_kegiatan_model.dart';
import 'package:jawara/core/models/kegiatan_models.dart';

class DashboardKegiatanRepository {
  final CollectionReference _col =
      FirebaseFirestore.instance.collection('activities');

  // TOTAL DATA
  Stream<int> getTotalActivities() {
    return _col.snapshots().map((snap) => snap.docs.length);
  }

  // ACTIVITY TERBARU
  Stream<List<DashboardKegiatanModel>> getRecentActivities() {
    return _col
        .orderBy('date', descending: true)
        .limit(10)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => DashboardKegiatanModel.fromFirestore(d)).toList());
  }

  // KEGIATAN LEWAT
  Stream<int> getActivityLewat() {
    return _col
        .where('date', isLessThan: Timestamp.fromDate(DateTime.now()))
        .snapshots()
        .map((s) => s.docs.length);
  }

  // KEGIATAN HARI INI
  Stream<int> getActivityHariIni() {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return _col
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(today))
        .where('date',
            isLessThan: Timestamp.fromDate(today.add(Duration(days: 1))))
        .snapshots()
        .map((s) => s.docs.length);
  }

  // AKAN DATANG
  Stream<int> getActivityAkanDatang() {
    return _col
        .where('date', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .snapshots()
        .map((s) => s.docs.length);
  }

  // PER-ACTOR (Penanggung Jawab)
  Stream<Map<String, int>> getActorTerbanyak() {
    return _col.snapshots().map((snapshot) {
      Map<String, int> result = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final actor = data['actor'] ?? 'Unknown';

        result[actor] = (result[actor] ?? 0) + 1;
      }

      return result;
    });
  }

  // DATA PER BULAN
  Stream<int> getActivitiesPerMonth(int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    return _col
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .map((snap) => snap.docs.length);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/dashboard_kegiatan_model.dart';

class DashboardKegiatanRepository {
  final CollectionReference _col =
      FirebaseFirestore.instance.collection('kegiatan');

  // TOTAL DATA
  Stream<int> getTotalActivities() {
    return _col.snapshots().map((snap) => snap.docs.length);
  }

  // ACTIVITY TERBARU
  Stream<List<DashboardKegiatanModel>> getRecentActivities() {
    return _col
        .orderBy('tanggal_pelaksanaan', descending: true)
        .limit(10)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => DashboardKegiatanModel.fromFirestore(d)).toList());
  }

  // KEGIATAN LEWAT (tanggal < hari ini)
  Stream<int> getActivityLewat() {
    final now = DateTime.now();

    return _col
        .where('tanggal_pelaksanaan', isLessThan: now)
        .snapshots()
        .map((s) => s.docs.length);
  }

  // KEGIATAN HARI INI
  Stream<int> getActivityHariIni() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day + 1);

    return _col
        .where('tanggal_pelaksanaan', isGreaterThanOrEqualTo: start)
        .where('tanggal_pelaksanaan', isLessThan: end)
        .snapshots()
        .map((s) => s.docs.length);
  }

  // AKAN DATANG (tanggal > hari ini)
  Stream<int> getActivityAkanDatang() {
    final now = DateTime.now();

    return _col
        .where('tanggal_pelaksanaan', isGreaterThan: now)
        .snapshots()
        .map((s) => s.docs.length);
  }

  // PER-ACTOR (Penanggung Jawab)
  Stream<Map<String, int>> getActorTerbanyak() {
    return _col.snapshots().map((snapshot) {
      Map<String, int> result = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final actor = data['penanggung_jawab_id'] ?? 'Unknown';

        result[actor] = (result[actor] ?? 0) + 1;
      }

      return result;
    });
  }

  // TOTAL PER BULAN
  Stream<int> getActivitiesPerMonth(int month, int year) {
    final start = DateTime(year, month, 1);
    final end = (month < 12) 
        ? DateTime(year, month + 1, 1) 
        : DateTime(year + 1, 1, 1);

    return _col
        .where('tanggal_pelaksanaan', isGreaterThanOrEqualTo: start)
        .where('tanggal_pelaksanaan', isLessThan: end)
        .snapshots()
        .map((snap) => snap.docs.length);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/dashboard_kegiatan_model.dart';
import 'package:jawara/core/models/kegiatan_models.dart';

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

  // KEGIATAN LEWAT (COUNT)
  Stream<int> getActivityLewat() {
    // Events with date strictly before the start of today
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return _col
        .where('tanggal_pelaksanaan', isLessThan: Timestamp.fromDate(today))
        .snapshots()
        .map((s) => s.docs.length);
  }

  // KEGIATAN HARI INI (COUNT)
  Stream<int> getActivityHariIni() {
    // Events that fall within today's date (00:00:00 - 23:59:59)
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final tomorrow = today.add(Duration(days: 1));

    return _col
        .where('tanggal_pelaksanaan', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
        .where('tanggal_pelaksanaan', isLessThan: Timestamp.fromDate(tomorrow))
        .snapshots()
        .map((s) => s.docs.length);
  }

  // AKAN DATANG (COUNT)
  Stream<int> getActivityAkanDatang() {
    // Events from the start of tomorrow onward
    final tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 1));

    return _col
        .where('tanggal_pelaksanaan', isGreaterThanOrEqualTo: Timestamp.fromDate(tomorrow))
        .snapshots()
        .map((s) => s.docs.length);
  }

  // KEGIATAN LEWAT (LIST)
  Stream<List<DashboardKegiatanModel>> getKegiatanLewatList({int limit = 5}) {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return _col
        .where('tanggal_pelaksanaan', isLessThan: Timestamp.fromDate(today))
        .orderBy('tanggal_pelaksanaan', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => DashboardKegiatanModel.fromFirestore(d)).toList());
  }

  // KEGIATAN HARI INI (LIST)
  Stream<List<DashboardKegiatanModel>> getKegiatanHariIniList({int limit = 10}) {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final tomorrow = today.add(Duration(days: 1));

    return _col
        .where('tanggal_pelaksanaan', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
        .where('tanggal_pelaksanaan', isLessThan: Timestamp.fromDate(tomorrow))
        .orderBy('tanggal_pelaksanaan')
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => DashboardKegiatanModel.fromFirestore(d)).toList());
  }

  // AKAN DATANG (LIST)
  Stream<List<DashboardKegiatanModel>> getKegiatanAkanDatangList({int limit = 5}) {
    final tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 1));

    return _col
        .where('tanggal_pelaksanaan', isGreaterThanOrEqualTo: Timestamp.fromDate(tomorrow))
        .orderBy('tanggal_pelaksanaan')
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => DashboardKegiatanModel.fromFirestore(d)).toList());
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
        .where('tanggal_pelaksanaan', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('tanggal_pelaksanaan', isLessThan: Timestamp.fromDate(end))
        .snapshots() 
        .map((snap) => snap.docs.length);
  }
}
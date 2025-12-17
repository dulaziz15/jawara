import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DashboardKeuanganRepository {
  final CollectionReference _pemasukanCollection =
      FirebaseFirestore.instance.collection('pemasukan');

  final CollectionReference _pengeluaranCollection =
      FirebaseFirestore.instance.collection('pengeluaran');

  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ==============================
  // PEMASUKAN PER BULAN (STRING DATE)
  // ==============================
  Stream<double> pemasukanPerBulan(int bulan, int tahun) {
    final bulanStr = bulan.toString().padLeft(2, '0');
    final prefix = "$tahun-$bulanStr";

    return _pemasukanCollection
        .where('tanggal_pemasukan', isGreaterThanOrEqualTo: "$prefix-01")
        .where('tanggal_pemasukan', isLessThan: "$prefix-32")
        .snapshots()
        .map((snapshot) {
      double total = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += (data['jumlah_pemasukan']?.toDouble() ?? 0);
      }

      return total;
    });
  }

  // ==============================
  // PENGELUARAN PER BULAN (STRING DATE)
  // ==============================
  Stream<double> pengeluaranPerBulan(int bulan, int tahun) {
    final bulanStr = bulan.toString().padLeft(2, '0');
    final prefix = "$tahun-$bulanStr";

    return _pengeluaranCollection
        .where('tanggal_pengeluaran', isGreaterThanOrEqualTo: "$prefix-01")
        .where('tanggal_pengeluaran', isLessThan: "$prefix-32")
        .snapshots()
        .map((snapshot) {
      double total = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += (data['jumlah_pengeluaran']?.toDouble() ?? 0);
      }

      return total;
    });
  }

  // ==============================
  // TOTAL PEMASUKAN
  // ==============================
  Stream<double> getTotalPemasukan() {
    return _pemasukanCollection.snapshots().map((snapshot) {
      double total = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += (data['jumlah_pemasukan']?.toDouble() ?? 0.0);
      }
      return total;
    });
  }

  // ==============================
  // TOTAL PENGELUARAN
  // ==============================
  Stream<double> getTotalPengeluaran() {
    return _pengeluaranCollection.snapshots().map((snapshot) {
      double total = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        total += (data['jumlah_pengeluaran']?.toDouble() ?? 0.0);
      }
      return total;
    });
  }

  // ==============================
  // JUMLAH TRANSAKSI (TOTAL: Pemasukan + Pengeluaran)
  // ==============================
  Stream<int> getJumlahTransaksi() {
    // 1. Ambil jumlah dokumen pemasukan
    final pemasukanStream = _pemasukanCollection.snapshots().map((s) => s.docs.length);
    
    // 2. Ambil jumlah dokumen pengeluaran
    final pengeluaranStream = _pengeluaranCollection.snapshots().map((s) => s.docs.length);

    // 3. Gabungkan keduanya
    return StreamZip([pemasukanStream, pengeluaranStream])
        .map((values) => (values[0] as int) + (values[1] as int));
  }

  // JUMLAH TRANSAKSI DI BULAN TERPILIH (pemasukan + pengeluaran)
  Stream<int> getJumlahTransaksiPerBulan(int bulan, int tahun) {
    final bulanStr = bulan.toString().padLeft(2, '0');
    final prefix = "$tahun-$bulanStr";

    final pemasukan = _pemasukanCollection
        .where('tanggal_pemasukan', isGreaterThanOrEqualTo: "$prefix-01")
        .where('tanggal_pemasukan', isLessThan: "$prefix-32")
        .snapshots()
        .map((s) => s.docs.length);

    final pengeluaran = _pengeluaranCollection
        .where('tanggal_pengeluaran', isGreaterThanOrEqualTo: "$prefix-01")
        .where('tanggal_pengeluaran', isLessThan: "$prefix-32")
        .snapshots()
        .map((s) => s.docs.length);

    return StreamZip([pemasukan, pengeluaran]).map((values) => (values[0] as int) + (values[1] as int));
  }
}

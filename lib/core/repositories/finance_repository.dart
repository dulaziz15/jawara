import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/pemasukan_model.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';
import 'package:jawara/core/models/tagihan_model.dart';

class FinanceRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _pemasukanCollection = FirebaseFirestore.instance.collection('pemasukan');
  final CollectionReference _pengeluaranCollection = FirebaseFirestore.instance.collection('pengeluaran');
  final CollectionReference _tagihanCollection = FirebaseFirestore.instance.collection('tagihan');


  // ==========================================================
  // PEMASUKAN (CRUD Penuh)
  // ==========================================================
  Future<void> addPemasukan(PemasukanModel pemasukan) async => await _pemasukanCollection.add(pemasukan.toMap());
  
  // R: Get Pemasukan (Stream)
  Stream<List<PemasukanModel>> getPemasukan() {
    return _pemasukanCollection.orderBy('tanggal_pemasukan', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PemasukanModel.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }
  
  Future<void> updatePemasukan(PemasukanModel pemasukan) async => await _pemasukanCollection.doc(pemasukan.id.toString()).update(pemasukan.toMap());
  Future<void> deletePemasukan(String pemasukanId) async => await _pemasukanCollection.doc(pemasukanId).delete();


  // ==========================================================
  // PENGELUARAN (CRUD Penuh)
  // ==========================================================
  Future<void> addPengeluaran(PengeluaranModel pengeluaran) async => await _pengeluaranCollection.add(pengeluaran.toMap());
  
  // R: Get Pengeluaran (Stream)
  Stream<List<PengeluaranModel>> getPengeluaran() {
    return _pengeluaranCollection.orderBy('tanggal_pengeluaran', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PengeluaranModel.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }
  
  Future<void> updatePengeluaran(PengeluaranModel pengeluaran) async => await _pengeluaranCollection.doc(pengeluaran.id.toString()).update(pengeluaran.toMap());
  Future<void> deletePengeluaran(String pengeluaranId) async => await _pengeluaranCollection.doc(pengeluaranId).delete();


  // ==========================================================
  // TAGIHAN (CRUD Penuh)
  // ==========================================================
  Future<void> addTagihan(TagihanModel tagihan) async => await _tagihanCollection.add(tagihan.toMap());
  
  // R: Get Tagihan (Stream)
  Stream<List<TagihanModel>> getAllTagihan() {
    return _tagihanCollection.orderBy('periode', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TagihanModel.fromMap({...data, 'id': doc.id});
      }).toList();
    });
  }
  
  Future<void> updateTagihan(TagihanModel tagihan) async => await _tagihanCollection.doc(tagihan.id.toString()).update(tagihan.toMap());
  Future<void> deleteTagihan(String tagihanId) async => await _tagihanCollection.doc(tagihanId).delete();
}
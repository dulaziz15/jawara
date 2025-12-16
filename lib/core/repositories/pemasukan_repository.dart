import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:jawara/core/models/pemasukan_model.dart';
import 'package:jawara/core/repositories/pengguna_repository.dart';

class PemasukanRepository {
  final CollectionReference _pemasukanCollection =
      FirebaseFirestore.instance.collection('pemasukan');

  // ==========================================================
  // PEMASUKAN (CRUD Penuh)
  // ==========================================================

  Future<String> addPemasukan(PemasukanModel pemasukan) async {
    final DocumentReference docRef = _pemasukanCollection.doc();
    final data = pemasukan.toMap();
    data['docId'] = docRef.id;
    await docRef.set(data);
    return docRef.id;
  }

  Stream<List<PemasukanModel>> getPemasukan() {
    return _pemasukanCollection
        .orderBy('tanggal_pemasukan', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PemasukanModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  Future<void> updatePemasukan(PemasukanModel pemasukan) async {
    if (pemasukan.docId == null) return;

    await _pemasukanCollection
        .doc(pemasukan.docId)
        .update(pemasukan.toMap());
  }

  Future<void> deletePemasukan(String docId) async =>
      await _pemasukanCollection.doc(docId).delete();

  // ==========================================================
  // GET BY DOC ID (DETAIL)
  // ==========================================================
  Future<PemasukanModel?> getPemasukanByDocId(String docId) async {
    try {
      final docSnapshot = await _pemasukanCollection.doc(docId).get();
      final data = docSnapshot.data() as Map<String, dynamic>;
      final pemasukan = PemasukanModel.fromMap(data, docSnapshot.id);

      // ================= DEBUG VERIFIKATOR =================
      if (pemasukan.verifikatorId != null &&
          pemasukan.verifikatorId!.isNotEmpty) {
        try {
          final pengguna = await PenggunaRepository().getUserByDocId(
            pemasukan.verifikatorId,
          );

          if (pengguna == null) {
          } else {
            pemasukan.verifikatorNama = pengguna.nama;
          }
        } catch (e, s) {
          debugPrintStack(stackTrace: s);
        }
      } else {
      }
      // ======================================================

      return pemasukan;
    } catch (e, s) {
      debugPrint('🔥 Gagal ambil data pemasukan: $e');
      debugPrintStack(stackTrace: s);
      throw Exception('Gagal ambil data: $e');
    }
  }
}

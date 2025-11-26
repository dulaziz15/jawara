import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/family_models.dart';

class FamilyRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _familyCollection = FirebaseFirestore.instance
      .collection('families');

  // ==========================================================
  // FAMILY (Data Keluarga Master - CRUD Penuh)
  // ==========================================================
  // R: Stream semua Family
  Stream<List<Family>> getAllFamilies() {
    return _familyCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Family.fromMap(data);
      }).toList();
    });
  }

  // R: Ambil data Family berdasarkan NIK (Future)
  Future<Family?> getFamilyByNoKk(String noKk) async {
    final docSnapshot = await _familyCollection.doc(noKk).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return Family.fromMap(data);
    }
    return null;
  }

  // C: Tambah Family (NIK digunakan sebagai ID Dokumen)
  Future<void> addFamily(Family family) async {
    await _familyCollection.doc(family.noKk).set(family.toMap());
  }

  // U: Update Family
  Future<void> updateFamily(Family family) async {
    await _familyCollection.doc(family.noKk).update(family.toMap());
  }

  // D: Delete Family
  Future<void> deleteFamily(String noKk) async {
    await _familyCollection.doc(noKk).delete();
  }
}

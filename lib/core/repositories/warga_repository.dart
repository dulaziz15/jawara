import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/warga_models.dart';

class CitizenRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('warga');

  // READ: Stream semua data warga
  Stream<List<WargaModel>> getAllCitizens() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return WargaModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // UPDATE: Update data warga
  Future<void> updateCitizen(WargaModel citizen) async {
    // Menggunakan docId untuk update dokumen yang tepat
    await _collection.doc(citizen.docId).update(citizen.toMap());
  }

  // DELETE: Hapus data warga
  Future<void> deleteCitizen(String docId) async {
    await _collection.doc(docId).delete();
  }
  
  // CREATE: Tambah warga baru (Opsional, jika nanti butuh)
  Future<void> addCitizen(WargaModel citizen) async {
    await _collection.add(citizen.toMap());
  }
}
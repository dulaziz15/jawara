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

  // Ambil warga berdasarkan field keluarga (synchronous query)
  Future<List<WargaModel>> getCitizensByKeluarga(String keluarga) async {
    final q = await _collection.where('keluarga', isEqualTo: keluarga).get();
    return q.docs.map((doc) => WargaModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // Set statusDomisili untuk semua warga pada keluarga tertentu
  Future<void> setStatusDomisiliByKeluarga(String keluarga, String status) async {
    final docs = await _collection.where('keluarga', isEqualTo: keluarga).get();
    for (var doc in docs.docs) {
      await _collection.doc(doc.id).update({'statusDomisili': status});
    }
  }

  // Set statusDomisili untuk satu warga berdasarkan docId
  Future<void> setStatusDomisili(String docId, String status) async {
    await _collection.doc(docId).update({'statusDomisili': status});
  }
}

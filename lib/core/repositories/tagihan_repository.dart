// Lokasi: lib/core/repositories/tagihan_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/tagihan_model.dart';
import 'package:jawara/core/models/iuran_model.dart';

class TagihanRepository {
  final CollectionReference _tagihanCollection = 
      FirebaseFirestore.instance.collection('tagihan');
  final CollectionReference _iuranMasterCollection = 
      FirebaseFirestore.instance.collection('iuran_master');

  // R: Ambil semua Tagihan (Real-time stream)
  Stream<List<TagihanModel>> getAllTagihan() {
    return _tagihanCollection
        .orderBy('periode', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>; 
        // Penting: Menggabungkan doc.id Firestore ke data
        return TagihanModel.fromMap({...data, 'id': doc.id}); 
      }).toList();
    });
  }

  // R: Ambil daftar Master Iuran
  Stream<List<IuranModel>> getIuranMaster() {
    return _iuranMasterCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return IuranModel.fromMap({...data, 'id': doc.id}); 
      }).toList();
    });
  }

  // C: Tambah Tagihan Baru
  Future<void> addTagihan(TagihanModel tagihan) async {
      final data = tagihan.toMap();
      // data.remove('id'); // ID diset otomatis oleh Firestore
      await _tagihanCollection.add(data);
  }
  
  // U: Update Tagihan
  Future<void> updateTagihan(TagihanModel tagihan) async {
      await _tagihanCollection.doc(tagihan.id.toString()).update(tagihan.toMap());
  }
}
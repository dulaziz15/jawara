import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara/core/models/pengguna_models.dart';
import 'package:jawara/core/models/family_model.dart'; 

class UserRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _userCollection = 
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _familyCollection = 
      FirebaseFirestore.instance.collection('families');

  // ==========================================================
  // USER (Data Profil & Otentikasi)
  // ==========================================================
  // R: Ambil detail pengguna yang sedang login berdasarkan UID Auth
  Future<UserModel?> getLoggedInUserDetail() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final docSnapshot = await _userCollection.doc(uid).get(); 
    if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        // Catatan: Anda mungkin perlu mendapatkan UID dari docSnapshot.id jika diperlukan
        return UserModel.fromMap(data); 
    }
    return null;
  }
  
  // R: Stream semua Users (untuk halaman Admin)
  Stream<List<UserModel>> getAllUsers() {
    return _userCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }).toList();
    });
  }
  
  // U: Update data profil User
  Future<void> updateUser(UserModel user, String uid) async => await _userCollection.doc(uid).update(user.toMap());
  
  // D: Delete User Profile (Setelah user dihapus dari Firebase Auth)
  Future<void> deleteUserProfile(String uid) async => await _userCollection.doc(uid).delete();


  // ==========================================================
  // FAMILY (Data Keluarga Master - CRUD Penuh)
  // ==========================================================
  // R: Stream semua Family
  Stream<List<Family>> getAllFamilies() {
      return _familyCollection.snapshots().map((snapshot) {
          return snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Family(nik: data['nik'] as String, name: data['name'] as String); 
          }).toList();
      });
  }
  
  // R: Ambil data Family berdasarkan NIK (Future)
  Future<Family?> getFamilyByNik(String nik) async {
    final docSnapshot = await _familyCollection.doc(nik).get();
    if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return Family(nik: data['nik'] as String, name: data['name'] as String); 
    }
    return null;
  }
  
  // C: Tambah Family (NIK digunakan sebagai ID Dokumen)
  Future<void> addFamily(Family family) async => await _familyCollection.doc(family.nik).set(family.toMap());
  
  // U: Update Family
  Future<void> updateFamily(Family family) async => await _familyCollection.doc(family.nik).update(family.toMap());
  
  // D: Delete Family
  Future<void> deleteFamily(String nik) async => await _familyCollection.doc(nik).delete();
}
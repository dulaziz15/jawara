import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara/core/models/pengguna_models.dart';

class PenggunaRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection('users');

  // ==========================================================
  // USER (Data Profil & Otentikasi)
  // ==========================================================

// ==========================================================
  // C: Create User Profile (Simpan pakai NIK sebagai ID)
  // ==========================================================
  Future<void> createUserProfile(UserModel user) async {
    // Sesuai permintaan: Document ID menggunakan NIK
    await _userCollection.doc(user.nik).set(user.toMap());
  }

  // ==========================================================
  // R: Ambil detail pengguna yang sedang login
  // ==========================================================
  Future<UserModel?> getLoggedInUserDetail() async {
    final userAuth = FirebaseAuth.instance.currentUser;
    
    // Jika belum login, return null
    if (userAuth == null || userAuth.email == null) return null;
    
    try {
      // PERBAIKAN PENTING:
      // Karena Doc ID adalah NIK (kita tidak tahu NIK saat login),
      // kita cari user berdasarkan EMAIL yang sama dengan akun login.
      final querySnapshot = await _userCollection
          .where('email', isEqualTo: userAuth.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;
        
        // Pastikan docId diisi dari ID dokumen (yaitu NIK)
        data['docId'] = doc.id; 
        
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      // Handle error jika perlu
      return null;
    }
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
  Future<void> updateUser(UserModel user, String uid) async =>
      await _userCollection.doc(uid).update(user.toMap());

  // D: Delete User Profile (Setelah user dihapus dari Firebase Auth)
  Future<void> deleteUserProfile(String uid) async =>
      await _userCollection.doc(uid).delete();

  // R: Ambil User berdasarkan NIK (Nomor Induk Kependudukan)
  Future<UserModel?> getUserByNik(String targetNik) async {
    try {
      // Kita pakai .where() karena NIK adalah field di dalam dokumen, bukan ID dokumen
      final querySnapshot = await _userCollection
          .where('nik', isEqualTo: targetNik)
          .limit(1) // Optimasi: Cukup ambil 1 saja
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        return UserModel.fromMap({'docId': doc.id, ...data});
      }
      return null;
    } catch (e) {
      // print("[REPO] Error Query NIK: $e");
      return null;
    }
  }
}

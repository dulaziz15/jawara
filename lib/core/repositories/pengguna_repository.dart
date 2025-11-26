import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara/core/models/pengguna_models.dart';

class UserRepository {
  // Langsung gunakan FirebaseFirestore.instance
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection('users');

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
  Future<void> updateUser(UserModel user, String uid) async =>
      await _userCollection.doc(uid).update(user.toMap());

  // D: Delete User Profile (Setelah user dihapus dari Firebase Auth)
  Future<void> deleteUserProfile(String uid) async =>
      await _userCollection.doc(uid).delete();

}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara/core/models/auth_models.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi Register Sederhana (Hanya Email & Password)
  Future<AuthModel> register({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Buat User di Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Return data user yang berhasil dibuat
      return AuthModel.fromFirebaseUser(cred.user);

    } on FirebaseAuthException catch (e) {
      // Error handling bawaan Firebase
      String message = "Terjadi kesalahan.";
      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email salah.';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception("Gagal mendaftar: $e");
    }
  }
}
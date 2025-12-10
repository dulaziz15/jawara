import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara/core/models/pengguna_models.dart';
import 'pengguna_repository.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PenggunaRepository _penggunaRepo = PenggunaRepository();

  Future<void> register({
    required String email,
    required String password,
    required String nama,
    required String nik,
    required String noHp,
    required String jenisKelamin,
    // Field alamat tidak masuk ke Model, tapi kalau mau disimpan di logic lain bisa ditambah
  }) async {
    try {
      // 1. Buat Akun di Firebase Auth
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Note: Kita tidak butuh UID untuk nama dokumen, karena pakai NIK.

      // 2. Buat Model User
      UserModel newUser = UserModel(
        docId: nik,          // <--- Sesuai permintaan: docId adalah NIK
        nama: nama,
        nik: nik,
        email: email,
        noHp: noHp,
        jenisKelamin: jenisKelamin,
        
        // --- DATA DEFAULT ---
        idKeluarga: '-',
        statusDomisili: 'Aktif',
        statusHidup: 'Hidup',
        buktiIdentitas: '-',
        role: 'warga',
      );

      // 3. Simpan ke Firestore (Akan tersimpan di /users/[NIK])
      await _penggunaRepo.createUserProfile(newUser);

    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan.";
      if (e.code == 'weak-password') message = 'Password terlalu lemah.';
      else if (e.code == 'email-already-in-use') message = 'Email sudah terdaftar.';
      throw Exception(message);
    } catch (e) {
      throw Exception("Gagal mendaftar: $e");
    }
  }
}
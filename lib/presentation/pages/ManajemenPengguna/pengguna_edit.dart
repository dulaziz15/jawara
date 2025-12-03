import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/pengguna_models.dart';
import 'package:jawara/core/repositories/pengguna_repository.dart'; // Pastikan import ini

@RoutePage()
class PenggunaEditPage extends StatefulWidget {
  final String userId;

  const PenggunaEditPage({super.key, required this.userId});

  @override
  State<PenggunaEditPage> createState() => _PenggunaEditPageState();
}

class _PenggunaEditPageState extends State<PenggunaEditPage> {
  // 1. Repository & State
  final PenggunaRepository _repository = PenggunaRepository();
  bool _isLoading = true; // Loading saat ambil data awal
  bool _isSaving = false; // Loading saat simpan data

  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController hpController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // Model untuk menampung data user saat ini
  UserModel? user;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller kosong dulu
    namaController = TextEditingController();
    emailController = TextEditingController();
    hpController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    // 2. Ambil data dari Firebase
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // widget.userId adalah NIK
    final fetchedUser = await _repository.getUserByNik(widget.userId);
    
    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser;
        // Isi controller dengan data dari Firebase
        namaController.text = user!.nama;
        emailController.text = user!.email;
        hpController.text = user!.noHp;
        _isLoading = false;
      });
    } else {
      // Handle jika user tidak ditemukan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User tidak ditemukan")),
        );
        context.router.pop();
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    hpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // 3. Fungsi Simpan ke Firebase
  Future<void> _simpanPerubahan() async {
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      // Buat object baru dengan data yang diedit
      // Kita pertahankan data lama (role, nik, dll) dan update yang diedit saja
      final updatedUser = UserModel(
        docId: user!.docId,
        nama: namaController.text,
        email: emailController.text,
        noHp: hpController.text,
        // Field di bawah ini tetap menggunakan data lama (tidak diedit di form ini)
        role: user!.role,
        nik: user!.nik,
        idKeluarga: user!.idKeluarga,
        jenisKelamin: user!.jenisKelamin,
        statusDomisili: user!.statusDomisili,
        statusHidup: user!.statusHidup,
        buktiIdentitas: user!.buktiIdentitas,
      );

      // Panggil Repository untuk update
      await _repository.updateUser(updatedUser, user!.nik);

      // Catatan soal Password:
      // Update password harus dilakukan via FirebaseAuth (currentUser.updatePassword)
      // Tidak disarankan menyimpan password text di Firestore demi keamanan.
      // Kode ini hanya mengupdate profil biodata.

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Data berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
        context.router.pop(); // Kembali ke halaman detail
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal memperbarui: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan Loading jika data belum siap
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(backgroundColor: Colors.grey.shade100),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul dalam Card
                const Text(
                  'Edit Akun Pengguna',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Nama Lengkap'),
                const SizedBox(height: 6),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(hintText: 'Nama Lengkap'),
                ),

                const SizedBox(height: 16),
                const Text('Email'),
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),

                const SizedBox(height: 16),
                const Text('Nomor HP'),
                const SizedBox(height: 6),
                TextField(
                  controller: hpController,
                  decoration: const InputDecoration(hintText: 'Nomor HP'),
                ),

                const SizedBox(height: 16),
                const Text('Password Baru (kosongkan jika tidak diganti)'),
                const SizedBox(height: 6),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password Baru'),
                ),

                const SizedBox(height: 16),
                const Text('Konfirmasi Password Baru'),
                const SizedBox(height: 6),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Konfirmasi Password Baru',
                  ),
                ),

                const SizedBox(height: 16),
                const Text('Role (tidak dapat diubah)'),
                const SizedBox(height: 6),
                DropdownButtonFormField(
                  value: user?.role, // Ambil dari data user yang sudah di-load
                  items: user?.role != null
                      ? [
                          DropdownMenuItem(
                              value: user!.role, child: Text(user!.role)),
                        ]
                      : [],
                  onChanged: null, // Disable change
                  decoration: const InputDecoration(),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _simpanPerubahan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Perbarui',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
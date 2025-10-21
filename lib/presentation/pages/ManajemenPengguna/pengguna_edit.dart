import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/pengguna_models.dart';

@RoutePage()
class PenggunaEditPage extends StatefulWidget {
  final int userId;

  const PenggunaEditPage({
    super.key,
    required this.userId,
  });

  @override
  State<PenggunaEditPage> createState() => _PenggunaEditPageState();
}

class _PenggunaEditPageState extends State<PenggunaEditPage> {
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController hpController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  late UserModel user;

  @override
  void initState() {
    super.initState();

    // Ambil data user berdasarkan ID
    user = daftarPengguna.firstWhere(
      (u) => u.id == widget.userId,
      orElse: () => UserModel(
        id: widget.userId,
        nama: '',
        email: '',
        status: 'Diproses',
        role: 'Warga',
        nik: '',
        noHp: '',
        jenisKelamin: '',
      ),
    );

    // Inisialisasi controller
    namaController = TextEditingController(text: user.nama);
    emailController = TextEditingController(text: user.email);
    hpController = TextEditingController(text: user.noHp);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
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

  void _simpanPerubahan() {
    // Simpan data atau lakukan validasi di sini
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  decoration: const InputDecoration(hintText: 'Konfirmasi Password Baru'),
                ),

                const SizedBox(height: 16),
                const Text('Role (tidak dapat diubah)'),
                const SizedBox(height: 6),
                DropdownButtonFormField(
                  value: user.role,
                  items: [
                    DropdownMenuItem(value: user.role, child: Text(user.role)),
                  ],
                  onChanged: null,
                  decoration: const InputDecoration(),
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _simpanPerubahan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Perbarui', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth
import 'package:jawara/core/models/pengguna_models.dart';
import 'package:jawara/core/repositories/pengguna_repository.dart';

@RoutePage()
class PenggunaTambahPage extends StatefulWidget {
  const PenggunaTambahPage({super.key});

  @override
  State<PenggunaTambahPage> createState() => _PenggunaTambahPageState();
}

class _PenggunaTambahPageState extends State<PenggunaTambahPage> {
  final PenggunaRepository _repository = PenggunaRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nikController = TextEditingController(); // NIK Wajib
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String selectedRole = '';
  bool _isLoading = false;

  final List<String> roles = [
    'Admin',
    'Ketua RW',
    'Ketua RT',
    'Sekretaris',
    'Bendahara',
    'Warga',
  ];

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nikController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi Validasi & Simpan
  Future<void> _saveUser() async {
    // 1. Validasi Input Dasar
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        nikController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        selectedRole.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field (termasuk NIK & Role) harus diisi')),
      );
      return;
    }

    // 2. Validasi Password Match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan Konfirmasi tidak cocok')),
      );
      return;
    }

    // 3. Validasi Panjang Password (Syarat Firebase min 6 karakter)
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 4. Buat User di Firebase Authentication (Email & Pass)
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Ambil UID yang baru dibuat
      String newUid = userCredential.user!.uid;

      // 5. Siapkan Data Model untuk Firestore
      // Kita isi default value untuk field yang tidak ada di form input
      UserModel newUser = UserModel(
        docId: newUid, // ID Dokumen = UID Auth
        nama: fullNameController.text,
        email: emailController.text.trim(),
        noHp: phoneController.text,
        role: selectedRole,
        nik: nikController.text,
        idKeluarga: '',         // Default kosong
        jenisKelamin: '-',      // Default strip
        statusDomisili: 'Aktif',// Default Aktif
        statusHidup: 'Hidup',   // Default Hidup
        buktiIdentitas: '',     // Default kosong (bisa update nanti)
      );

      // 6. Simpan ke Firestore
      await _repository.createUserProfile(newUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Akun ${newUser.nama} berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan';
      if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar. Gunakan email lain.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email salah.';
      } else if (e.code == 'weak-password') {
        message = 'Password terlalu lemah.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    nikController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() {
      selectedRole = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      // Tombol Back di AppBar (Opsional jika ingin navigasi manual)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tambah Akun Pengguna',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  fullNameController,
                  'Nama Lengkap',
                  'Masukkan nama lengkap',
                ),
                // Field NIK Wajib ditambahkan karena Model memerlukannya
                _buildTextField(
                  nikController,
                  'NIK',
                  'Masukkan NIK (16 digit)',
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  emailController,
                  'Email',
                  'Masukkan email aktif',
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  phoneController,
                  'Nomor HP',
                  'Masukkan nomor HP (cth: 08xxxxxxxxxx)',
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  passwordController,
                  'Password',
                  'Masukkan password (min 6 karakter)',
                  obscure: true,
                ),
                _buildTextField(
                  confirmPasswordController,
                  'Konfirmasi Password',
                  'Masukkan ulang password',
                  obscure: true,
                ),

                const SizedBox(height: 10),
                const Text('Role'),
                const SizedBox(height: 5),

                // ===== DROPDOWN ROLE =====
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedRole.isEmpty ? null : selectedRole,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFFB39DDB), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFF7E57C2), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      hint: const Text('Pilih Role'),
                      items: roles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue ?? '';
                        });
                      },
                    ),
                    if (selectedRole.isNotEmpty)
                      Positioned(
                        right: 30, // Geser sedikit agar tidak menimpa panah dropdown
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRole = '';
                            });
                          },
                          child: const Icon(Icons.close,
                              size: 20, color: Colors.grey),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading 
                          ? const SizedBox(
                              width: 20, 
                              height: 20, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _isLoading ? null : _resetForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6C63FF)),
          ),
        ),
      ),
    );
  }
}
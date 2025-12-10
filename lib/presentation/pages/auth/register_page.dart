import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/repositories/auth_repository.dart';
import 'package:jawara/core/models/auth_models.dart';
import 'package:jawara/presentation/pages/auth/component/image_picker.dart'; // Pastikan path ini benar/uncomment jika ada

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // --- Controllers ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // --- State Variables ---
  bool _isLoading = false;
  final AuthRepository _authRepository = AuthRepository(); // Panggil Repository

  // --- Fungsi Register Cepat ---
  void _handleRegister() async {
    // 1. Validasi Input Dasar
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password wajib diisi!")),
      );
      return;
    }

    if (_passwordController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password konfirmasi tidak cocok")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Panggil Repository (Hanya kirim Email & Pass)
      await _authRepository.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registrasi Berhasil!"),
            backgroundColor: Colors.green,
          ),
        );
        // Redirect ke Login
        context.router.replaceNamed('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF6C63FF),
                    child: Icon(Icons.menu_book_rounded, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Jawara Pintar",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                width: 550,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Daftar Akun",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Buat akun baru untuk memulai",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // --- FORM FIELDS ---
                    // Field lain tetap ada di UI agar tidak merusak tampilan,
                    // tapi controller-nya tidak dipakai di logic register.
                    
                    const Text("Nama Lengkap"),
                    const SizedBox(height: 5),
                    _buildTextField(_nameController, "Masukan Nama Lengkap"),
                    
                    const SizedBox(height: 15),
                    const Text("NIK"),
                    const SizedBox(height: 5),
                    _buildTextField(_nikController, "Masukan NIK sesuai KTP"),

                    const SizedBox(height: 15),
                    const Text("Email"),
                    const SizedBox(height: 5),
                    _buildTextField(_emailController, "Masukan Email aktif"),

                    const SizedBox(height: 15),
                    const Text("No Telepon"),
                    const SizedBox(height: 5),
                    _buildTextField(_phoneController, "08XXXXXXXX"),

                    const SizedBox(height: 15),
                    const Text("Password"),
                    const SizedBox(height: 5),
                    _buildTextField(_passwordController, "Masukan Password", isPassword: true),

                    const SizedBox(height: 15),
                    const Text("Konfirmasi Password"),
                    const SizedBox(height: 5),
                    _buildTextField(_confirmPassController, "Masukan Ulang Password", isPassword: true),

                    // ... Sisa UI (Dropdown dll) biarkan statis saja untuk mempercepat ...
                     const SizedBox(height: 15),
                    const Text("Jenis Kelamin"),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: _inputDecoration(""),
                      hint: const Text("-- Pilih Jenis Kelamin --"),
                      items: const [
                        DropdownMenuItem(value: "Laki-laki", child: Text("Laki-Laki")),
                        DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
                      ],
                      onChanged: (val) {},
                    ),
                    // ... (lanjutan field lain sesuai kode awalmu) ...
                    
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                "Daftar",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Sudah punya akun? ",
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Masuk",
                              style: const TextStyle(
                                color: Color(0xFF6C63FF),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.router.replaceNamed('/login');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget
  Widget _buildTextField(TextEditingController controller, String hint, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 216, 216, 216),
          width: 0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: const Color(0xFF6C63FF),
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    );
  }
}
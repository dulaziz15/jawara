import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
// Import Auth Repository
import '../../../core/repositories/auth_repository.dart';
import 'component/image_picker.dart'; // Pastikan path ini benar jika file ada

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
  String? _selectedGender;
  String? _selectedHouse;
  String? _selectedOwnership;
  
  bool _isLoading = false;
  final AuthRepository _authRepository = AuthRepository();

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // --- Fungsi Handle Register ---
  void _handleRegister() async {
    // 1. Validasi Input Wajib
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nikController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon lengkapi semua data wajib")),
      );
      return;
    }

    // 2. Validasi Password
    if (_passwordController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password konfirmasi tidak cocok")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 3. Panggil Repository
      await _authRepository.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        nama: _nameController.text.trim(),
        nik: _nikController.text.trim(),
        noHp: _phoneController.text.trim(),
        jenisKelamin: _selectedGender ?? "Laki-laki",
        // Alamat & Rumah diabaikan (tidak dikirim) sesuai permintaan
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
      if (mounted) setState(() => _isLoading = false);
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
              // --- Header ---
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

              // --- Card Form ---
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
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(child: Text("Buat akun baru untuk memulai", style: TextStyle(color: Colors.grey))),
                    const SizedBox(height: 20),

                    // --- Form Inputs ---
                    _buildLabel("Nama Lengkap"),
                    _buildTextField(_nameController, "Masukan Nama Lengkap"),

                    _buildLabel("NIK"),
                    _buildTextField(_nikController, "Masukan NIK sesuai KTP", type: TextInputType.number),

                    _buildLabel("Email"),
                    _buildTextField(_emailController, "Masukan Email aktif", type: TextInputType.emailAddress),

                    _buildLabel("No Telepon"),
                    _buildTextField(_phoneController, "08XXXXXXXX", type: TextInputType.phone),

                    _buildLabel("Password"),
                    _buildTextField(_passwordController, "Masukan Password", isObscure: true),

                    _buildLabel("Konfirmasi Password"),
                    _buildTextField(_confirmPassController, "Masukan Ulang Password", isObscure: true),

                    _buildLabel("Jenis Kelamin"),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedGender,
                      decoration: _inputDeco(),
                      hint: const Text("-- Pilih Jenis Kelamin --"),
                      items: const [
                        DropdownMenuItem(value: "Laki-laki", child: Text("Laki-Laki")),
                        DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
                      ],
                      onChanged: (val) => setState(() => _selectedGender = val),
                    ),

                    const SizedBox(height: 15),
                    _buildLabel("Pilih Rumah Yang Sudah Ada"),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedHouse,
                      decoration: _inputDeco(),
                      hint: const Text("-- Pilih Rumah --"),
                      items: const [
                        DropdownMenuItem(value: "No 100A", child: Text("Jl. yang sama kamu")),
                        DropdownMenuItem(value: "No 18", child: Text("Jl. besok bisa?")),
                        DropdownMenuItem(value: "No 45B", child: Text("Jl. jalan yang dilewatin sama kamu")),
                        DropdownMenuItem(value: "No 1", child: Text("Jl. mekar sari barat")),
                      ],
                      onChanged: (val) => setState(() => _selectedHouse = val),
                    ),
                    const SizedBox(height: 2),
                    const Text("Kalau tidak ada di daftar, silakan isi alamat rumah di bawah ini", style: TextStyle(fontSize: 12, color: Colors.grey)),

                    const SizedBox(height: 15),
                    _buildLabel("Alamat Rumah (Jika Tidak ada di List)"),
                    _buildTextField(_addressController, "Masukan Alamat Rumah"),

                    _buildLabel("Status Kepemilikan rumah"),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedOwnership,
                      decoration: _inputDeco(),
                      hint: const Text("-- Pilih Status Kepemilikan --"),
                      items: const [
                        DropdownMenuItem(value: "Milik Sendiri", child: Text("Milik Sendiri")),
                        DropdownMenuItem(value: "Sewa", child: Text("Sewa")),
                        DropdownMenuItem(value: "Kontrak", child: Text("Kontrak")),
                      ],
                      onChanged: (val) => setState(() => _selectedOwnership = val),
                    ),

                    const SizedBox(height: 15),
                    // ImagePickerPreview(), // Uncomment jika ada
                    const SizedBox(height: 20),

                    // --- Tombol Daftar ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("Daftar", style: TextStyle(fontSize: 16, color: Colors.white)),
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
                              style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()..onTap = () => context.router.replaceNamed('/login'),
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

  // --- Helper Widgets ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 15),
      child: Text(text),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isObscure = false, TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: type,
      decoration: _inputDeco(hint: hint),
    );
  }

  InputDecoration _inputDeco({String? hint}) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color.fromARGB(255, 216, 216, 216), width: 0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    );
  }
}
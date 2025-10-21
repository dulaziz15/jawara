import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
// ==================== MODEL ====================
class UserModel {
  String fullName;
  String email;
  String phoneNumber;
  String password;
  String confirmPassword;
  String role;

  UserModel({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.password = '',
    this.confirmPassword = '',
    this.role = '',
  });
}

// ==================== CONTROLLER ====================
@RoutePage()
class UserController {
  final UserModel user = UserModel();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String selectedRole = '';

  bool validateInputs(BuildContext context) {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        selectedRole.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok')),
      );
      return false;
    }

    return true;
  }

  void saveUser(BuildContext context) {
    if (validateInputs(context)) {
      user.fullName = fullNameController.text;
      user.email = emailController.text;
      user.phoneNumber = phoneController.text;
      user.password = passwordController.text;
      user.role = selectedRole;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Akun ${user.fullName} berhasil disimpan!')),
      );

      resetForm();
    }
  }

  void resetForm() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    selectedRole = '';
  }
}

// ==================== VIEW ====================
class PenggunaTambahPage extends StatefulWidget {
  const PenggunaTambahPage({super.key});

  @override
  State<PenggunaTambahPage> createState() => _PenggunaTambahPageState();
}

class _PenggunaTambahPageState extends State<PenggunaTambahPage> {
  final UserController controller = UserController();

  final List<String> roles = [
    'Admin',
    'Ketua RW',
    'Ketua RT',
    'Sekretaris',
    'Bendahara',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
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
                  controller.fullNameController,
                  'Nama Lengkap',
                  'Masukkan nama lengkap',
                ),
                _buildTextField(
                  controller.emailController,
                  'Email',
                  'Masukkan email aktif',
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  controller.phoneController,
                  'Nomor HP',
                  'Masukkan nomor HP (cth: 08xxxxxxxxxx)',
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  controller.passwordController,
                  'Password',
                  'Masukkan password',
                  obscure: true,
                ),
                _buildTextField(
                  controller.confirmPasswordController,
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
                      value: controller.selectedRole.isEmpty
                          ? null
                          : controller.selectedRole,
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
                          controller.selectedRole = newValue ?? '';
                        });
                      },
                    ),

                    // Tombol "X" di kanan dropdown
                    if (controller.selectedRole.isNotEmpty)
                      Positioned(
                        right: 12,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.selectedRole = '';
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
                      onPressed: () => controller.saveUser(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C63FF),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          controller.resetForm();
                        });
                      },
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
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6C63FF)),
          ),
        ),
      ),
    );
  }
}

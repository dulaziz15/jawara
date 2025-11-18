import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/presentation/pages/auth/component/welcome.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. TAMBAHKAN CONTROLLER DI SINI
    // (Catatan: di StatelessWidget, ini akan di-reset tiap build, 
    // tapi untuk if/else sederhana ini tidak masalah)
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Welcome(),
              const SizedBox(height: 30),
              Container(
                width: 350,
                padding: const EdgeInsets.all(30),
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
                        "Masuk ke Akun Anda",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Email"),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _emailController, // <-- 2. HUBUNGKAN CONTROLLER
                      decoration: InputDecoration(
                        hintText: "Masukan Email",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 216, 216, 216),
                                width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide:
                                BorderSide(color: Color(0xFF6C63FF), width: 0)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text("Password"),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _passwordController, // <-- 2. HUBUNGKAN CONTROLLER
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Masukan Password",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 216, 216, 216),
                                width: 0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide:
                                BorderSide(color: Color(0xFF6C63FF), width: 0)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        // 3. UBAH BAGIAN ONPRESSED INI
                        onPressed: () {
                          // Ambil nilai dari textfield
                          String email = _emailController.text;
                          String password = _passwordController.text;

                          // Lakukan pengecekan if/else (HARDCODED)
                          if (email == 'admin@gmail.com' && password == 'rahasia123') {
                            // Jika benar, navigasi
                            context.router.replaceNamed('/dashboard/main');
                          } else {
                            // Jika salah, tampilkan pesan error
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email atau Password salah!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text("Login",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Belum punya akun? ",
                          style: const TextStyle(color: Colors.black54),
                          children: [
                            TextSpan(
                              text: "Daftar",
                              style: const TextStyle(
                                color: Color(0xFF6C63FF),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.router.replaceNamed('/register');
                                },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
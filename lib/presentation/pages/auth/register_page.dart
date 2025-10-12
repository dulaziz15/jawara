import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Register Page", style: TextStyle(fontSize: 26)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.router.replaceNamed('/login'),
              child: const Text("Back to Login"),
            ),
          ],
        ),
      ),
    );
  }
}

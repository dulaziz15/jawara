import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  const LoginTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      ),
    );
  }
}

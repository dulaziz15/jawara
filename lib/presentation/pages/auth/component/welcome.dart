import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400, // biar lebar penuh
      padding: const EdgeInsets.symmetric(vertical: 0), // jarak atas bawah
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF6C63FF),
            child: Icon(Icons.menu_book_rounded, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "Jawara",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C63FF),
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Selamat Datang \nLogin untuk Sistem Jawara Pintar",
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

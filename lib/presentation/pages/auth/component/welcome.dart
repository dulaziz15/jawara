import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350, // biar lebar penuh
      padding: const EdgeInsets.symmetric(vertical: 0), // jarak atas bawah
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF6C63FF),
                child: Icon(Icons.menu_book_rounded, color: Colors.white),
              ),
              SizedBox(width: 10),
              Text(
                "Jawara Pintar",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
          Text(
            "Selamat Datang",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Login untuk mengakses sistem Jawara Pintar.",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

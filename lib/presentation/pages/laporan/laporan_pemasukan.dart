import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class LaporanPemasukanPage extends StatelessWidget {
  const LaporanPemasukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Laporan Pemasukan", style: TextStyle(fontSize: 22)));
  }
}

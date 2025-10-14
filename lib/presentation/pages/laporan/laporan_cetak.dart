import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class LaporanCetakPage extends StatelessWidget {
  const LaporanCetakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Laporan Cetak", style: TextStyle(fontSize: 22)));
  }
}

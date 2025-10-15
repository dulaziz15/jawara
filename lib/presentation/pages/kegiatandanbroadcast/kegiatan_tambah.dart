import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class KegiatanTambahPage extends StatelessWidget {
  const KegiatanTambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Kegiatan Tambah", style: TextStyle(fontSize: 22)));
  }
}

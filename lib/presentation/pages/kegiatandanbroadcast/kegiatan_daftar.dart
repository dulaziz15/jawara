import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class KegiatanDaftarPage extends StatelessWidget {
  const KegiatanDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Kegiatan daftar", style: TextStyle(fontSize: 22)));
  }
}

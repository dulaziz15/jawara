import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RumahTambahPage extends StatelessWidget {
  const RumahTambahPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Tambah Rumah Page", style: TextStyle(fontSize: 22)));
  }
}
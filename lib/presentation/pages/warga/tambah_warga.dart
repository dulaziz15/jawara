import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class WargaTambahPage extends StatelessWidget {
  const WargaTambahPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Tambah Warga Page", style: TextStyle(fontSize: 22)));
  }
}
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RumahDaftarPage extends StatelessWidget {
  const RumahDaftarPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Daftar Rumah Page", style: TextStyle(fontSize: 22)));
  }
}
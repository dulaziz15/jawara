import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class KeluargaPage extends StatelessWidget {
  const KeluargaPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(title: const Text("Data Warga & Rumah")),
      body: const Center(
        child: Text("Keluarga Page", style: TextStyle(fontSize: 22))) // Nested route
    );
  }
}
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class ManajemenPenggunaPage extends StatelessWidget {
  const ManajemenPenggunaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(title: const Text("Manajemen Pengguna")),
      body: const AutoRouter(), // Nested route
    );
  }
}
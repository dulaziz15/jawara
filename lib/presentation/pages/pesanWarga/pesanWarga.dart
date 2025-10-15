import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class PesanWargaPage extends StatelessWidget {
  const PesanWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(title: const Text("Pesan Warga")),
      body: const AutoRouter(), // Nested route
    );
  }
}
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class PengeluaranPage extends StatelessWidget {
  const PengeluaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text(
          'Data Pengeluaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4F6DF5),
        centerTitle: true,
        elevation: 0,
      ),
      body: const AutoRouter(), // Nested route
    );
  }
}

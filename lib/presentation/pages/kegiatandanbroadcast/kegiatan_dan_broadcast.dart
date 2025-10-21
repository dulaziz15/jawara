import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class KegiatanDanBroadcastPage extends StatelessWidget {
  const KegiatanDanBroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text(
          'Kegiatan dan Broadcast',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        centerTitle: false,
        elevation: 0,
      ),
      body: const AutoRouter(), // Nested route
    );
  }
}

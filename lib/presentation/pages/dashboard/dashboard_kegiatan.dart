import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class DashboardKegiatanPage extends StatelessWidget {
  const DashboardKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Dashboard Kegiatan", style: TextStyle(fontSize: 22)));
  }
}

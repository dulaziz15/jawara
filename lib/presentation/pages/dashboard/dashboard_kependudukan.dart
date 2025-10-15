import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class DashboardKependudukanPage extends StatelessWidget {
  const DashboardKependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Dashboard Kependudukan", style: TextStyle(fontSize: 22)));
  }
}

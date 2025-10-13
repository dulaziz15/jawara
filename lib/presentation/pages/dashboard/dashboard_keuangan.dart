import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class DashboardKeuanganPage extends StatelessWidget {
  const DashboardKeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Dashboard Keuangan", style: TextStyle(fontSize: 22)));
  }
}

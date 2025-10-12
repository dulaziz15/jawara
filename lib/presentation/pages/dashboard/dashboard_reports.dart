import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class DashboardReportsPage extends StatelessWidget {
  const DashboardReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Dashboard Reports", style: TextStyle(fontSize: 22)));
  }
}

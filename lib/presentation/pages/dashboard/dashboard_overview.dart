import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class DashboardOverviewPage extends StatelessWidget {
  const DashboardOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Dashboard Overview", style: TextStyle(fontSize: 22)));
  }
}

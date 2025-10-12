import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ReportFinancePage extends StatelessWidget {
  const ReportFinancePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Report Finance Page", style: TextStyle(fontSize: 22)));
  }
}
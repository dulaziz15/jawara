import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class BroadcastDaftarPage extends StatelessWidget {
  const BroadcastDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Broadcast daftar", style: TextStyle(fontSize: 22)));
  }
}

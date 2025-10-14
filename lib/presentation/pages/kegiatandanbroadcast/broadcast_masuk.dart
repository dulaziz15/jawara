import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class BroadcastMasukPage extends StatelessWidget {
  const BroadcastMasukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Broadcast masuk", style: TextStyle(fontSize: 22)));
  }
}

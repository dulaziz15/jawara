import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

@RoutePage()
class ChannelPage extends StatelessWidget {
  const ChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(title: const Text("Channel Transfer")),
      body: const AutoRouter(), // Nested route
    );
  }
}
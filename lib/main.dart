import 'package:flutter/material.dart';
import 'package:jawara/core/routes/app_router.dart';

final _appRouter = AppRouter();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Clean Nav App',
      routerConfig: _appRouter.config(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jawara/core/routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
final _appRouter = AppRouter();

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Jawara Pintar',
      routerConfig: _appRouter.config(),
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
    );
  }
}

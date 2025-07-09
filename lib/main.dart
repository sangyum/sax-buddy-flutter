import 'package:flutter/material.dart';
import 'features/landing/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaxAI Coach',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E5266)),
        useMaterial3: true,
      ),
      home: const LandingScreen(),
    );
  }
}

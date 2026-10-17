import 'package:flutter/material.dart';
import 'SplashScreenUi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi Fare Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFFC107),
        scaffoldBackgroundColor: const Color(0xFFFCF7FF),
      ),
      home: const SplashScreenUi(),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'TaxiFareUi.dart';

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TaxiFareUi()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ถ้ามีรูปแท็กซี่ ให้ใส่ใน assets/images/taxi.png แล้วเปลี่ยนเป็น Image.asset
            Image.asset('assets/images/taxi.png', width: 140, height: 140),
            const SizedBox(height: 20),
            const Text(
              'Taxi Fare Calculator',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4DA3E8),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'คำนวณค่าโดยสารแท็กซี่',
              style: TextStyle(fontSize: 13, color: Color(0xFF4DA3E8)),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Color(0xFFFFC107)),
          ],
        ),
      ),
    );
  }
}

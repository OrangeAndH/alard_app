import 'package:alard_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'forgot_password.dart';

void main() {
  runApp(const AlardApp());
}

class AlardApp extends StatelessWidget {
  const AlardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
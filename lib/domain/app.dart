import 'package:flutter/material.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/theme/app_theme.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barbershop App',
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}
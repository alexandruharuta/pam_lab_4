import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF3A1078);
  static const secondaryColor = Color(0xFFFFA500);

  static final ThemeData light = ThemeData(
    primarySwatch: Colors.deepPurple,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
  );
}
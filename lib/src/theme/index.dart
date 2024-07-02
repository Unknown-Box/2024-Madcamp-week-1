import 'package:flutter/material.dart';

final theme = ThemeData(
  // colorScheme: const ColorScheme(
  //   brightness: Brightness.light,
  //   primary: Colors.white,
  //   onPrimary: Colors.black,
  //   secondary: Color(0xFF9B9B9B),
  //   onSecondary: Colors.black,
  //   primaryContainer: Colors.black,
  //   secondaryContainer: Colors.white,
  //   error: Colors.red,
  //   onError: Colors.white,
  //   surface: Color(0xFFC6C6C6),
  //   onSurface: Color(0xFF191C1B),
  // ),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC6C6C6)),
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      fontSize: 24,
      fontFamily: 'Avenir',
      fontWeight: FontWeight.w800,
    ),
    bodyMedium: TextStyle(
      height: 1.42,
      fontSize: 14,
      fontFamily: 'Avenir',
      fontWeight: FontWeight.w400,
    ),
    labelMedium: TextStyle(
      height: 1.67,
      fontSize: 12,
      fontFamily: 'Avenir',
      fontWeight: FontWeight.w800,
    ),
  ),
);
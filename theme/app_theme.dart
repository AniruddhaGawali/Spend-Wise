import 'package:flutter/material.dart';

class AppTheme {
  //lightTheme is used to create a light theme
  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    ColorScheme scheme = lightColorScheme ??
        ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4));
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
    );
  }

  //darkTheme is used to create a dark theme
  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    ColorScheme scheme = darkColorScheme ??
        ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4), brightness: Brightness.dark);
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
    );
  }
}

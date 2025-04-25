import 'package:flutter/material.dart';

/// Defines the global app theme (dark mode with custom settings).
class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.tealAccent,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

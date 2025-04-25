import 'package:flutter/material.dart';

/// Application-wide constants (e.g., the note color palette).
class AppConstants {
  /// Predefined note colors (as ARGB integer values) for notes.
  static const List<int> noteColorValues = [
    0xFFE57373, // Red (light)
    0xFFFFB74D, // Orange
    0xFFFFF176, // Yellow
    0xFF81C784, // Green
    0xFF64B5F6, // Blue
  ];

  /// Predefined note colors as Color objects (for UI usage).
  static final List<Color> noteColors =
      noteColorValues.map((value) => Color(value)).toList();
}

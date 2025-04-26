import 'package:flutter/material.dart';

/// Application-wide constants (e.g., the note color palette).
class AppConstants {
  /// Predefined note colors (as ARGB integer values) for notes.
  static const List<int> noteColorValues = [
    0xFFA61C3C, // Red ()
    0xFFF3EFE0, // Orange
    0xFF372554, // Dark Purple
    0xFF324A5F, // Blue dark
    0xFF484a47, // Marron
  ];

  /// Predefined note colors as Color objects (for UI usage).
  static final List<Color> noteColors =
      noteColorValues.map((value) => Color(value)).toList();
}

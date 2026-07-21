import 'package:flutter/material.dart';

class AppTheme {
  // Primary Palette (Rider App Red Accent)
  static const Color primaryRed = Color(0xFFE53935);
  static const Color accentRed = Color(0xFFFF3D00);
  static const Color darkRedBg = Color(0xFF3E1B1B);
  static const Color redGradientStart = Color(0xFFFF5252);
  static const Color redGradientEnd = Color(0xFFC62828);

  // Dark Background Colors
  static const Color screenBackground = Color(0xFF0F0E0E);
  static const Color cardBackground = Color(0xFF1E1C1C);
  static const Color inputBackground = Color(0xFF282525);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA5A1A1);
  static const Color textMuted = Color(0xFF706B6B);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: screenBackground,
      iconTheme: const IconThemeData(weight: 200),
      colorScheme: const ColorScheme.dark(
        primary: primaryRed,
        secondary: accentRed,
        surface: cardBackground,
        error: Colors.redAccent,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Inter', 
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -1.0,
        ),
        headlineMedium: TextStyle(fontFamily: 'Inter', 
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: TextStyle(fontFamily: 'Inter', 
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(fontFamily: 'Inter', 
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      useMaterial3: true,
    );
  }
}

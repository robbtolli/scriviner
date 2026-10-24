import 'package:flutter/material.dart';

/// App-wide theme configurations with rich tabletop fantasy aesthetic and clean typography.
class AppTheme {
  const AppTheme._();

  // Fantasy-inspired Palette Tokens
  static const Color primaryGold = Color(0xFFC89B3C);
  static const Color darkCrimson = Color(0xFF8B261E);
  static const Color deepNavy = Color(0xFF141A29);
  static const Color parchmentLight = Color(0xFFF7F3E9);
  static const Color parchmentDark = Color(0xFF1C1815);
  static const Color surfaceDark = Color(0xFF26211C);
  static const Color cardDark = Color(0xFF332C26);
  static const Color accentEmerald = Color(0xFF2D8A4E);

  /// Dark fantasy theme (Default for table play)
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: primaryGold,
      onPrimary: Colors.black,
      secondary: darkCrimson,
      onSecondary: Colors.white,
      surface: surfaceDark,
      onSurface: const Color(0xFFF2EBD9),
      error: const Color(0xFFCF6679),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: parchmentDark,
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF4A4037), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: parchmentDark,
        foregroundColor: primaryGold,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGold,
          side: const BorderSide(color: primaryGold, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2E2721),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4A4037)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4A4037)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGold, width: 1.5),
        ),
      ),
    );
  }
}

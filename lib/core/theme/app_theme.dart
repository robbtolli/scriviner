import 'package:flutter/material.dart';

/// Supported visual theme presets for Scrivener.
enum AppThemeMode {
  ancientTome,
  scholarsDesk,
  midnightArcana,
  dungeonOled,
}

extension AppThemeModeX on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.ancientTome:
        return 'Ancient Tome';
      case AppThemeMode.scholarsDesk:
        return "Scholar's Desk";
      case AppThemeMode.midnightArcana:
        return 'Midnight Arcana';
      case AppThemeMode.dungeonOled:
        return 'High-Contrast Dungeon';
    }
  }

  String get description {
    switch (this) {
      case AppThemeMode.ancientTome:
        return 'Dark parchment fantasy with antique gold & crimson accents';
      case AppThemeMode.scholarsDesk:
        return 'Warm parchment paper and dark ink for daylight sessions';
      case AppThemeMode.midnightArcana:
        return 'Deep cosmos navy, indigo crystal, and arcane cyan glow';
      case AppThemeMode.dungeonOled:
        return 'True OLED black with maximum contrast gold and white';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.ancientTome:
        return Icons.auto_stories;
      case AppThemeMode.scholarsDesk:
        return Icons.menu_book;
      case AppThemeMode.midnightArcana:
        return Icons.auto_awesome;
      case AppThemeMode.dungeonOled:
        return Icons.contrast;
    }
  }
}

/// App-wide theme configurations with rich tabletop fantasy aesthetic and clean typography.
class AppTheme {
  const AppTheme._();

  // Fantasy-inspired Palette Tokens (Ancient Tome)
  static const Color primaryGold = Color(0xFFC89B3C);
  static const Color darkCrimson = Color(0xFF8B261E);
  static const Color deepNavy = Color(0xFF141A29);
  static const Color parchmentLight = Color(0xFFF7F3E9);
  static const Color parchmentDark = Color(0xFF1C1815);
  static const Color surfaceDark = Color(0xFF26211C);
  static const Color cardDark = Color(0xFF332C26);
  static const Color accentEmerald = Color(0xFF2D8A4E);

  /// Resolves the corresponding [ThemeData] for a given [AppThemeMode].
  static ThemeData getThemeData(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.ancientTome:
        return ancientTomeTheme;
      case AppThemeMode.scholarsDesk:
        return scholarsDeskTheme;
      case AppThemeMode.midnightArcana:
        return midnightArcanaTheme;
      case AppThemeMode.dungeonOled:
        return dungeonOledTheme;
    }
  }

  /// Dark fantasy theme (Default for table play) - Ancient Tome
  static ThemeData get darkTheme => ancientTomeTheme;

  /// Preset 1: Ancient Tome (Dark Parchment)
  static ThemeData get ancientTomeTheme {
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

  /// Preset 2: Scholar's Desk (Light Parchment Paper & Antique Ink)
  static ThemeData get scholarsDeskTheme {
    const paperLight = Color(0xFFF7F3E8);
    const cardLight = Color(0xFFFFFFFF);
    const inkDark = Color(0xFF2A2118);
    const sepiaBorder = Color(0xFFDDD2C0);
    const warmBronze = Color(0xFF996515);
    const sealRed = Color(0xFF8B261E);

    final colorScheme = ColorScheme.light(
      primary: warmBronze,
      onPrimary: Colors.white,
      secondary: sealRed,
      onSecondary: Colors.white,
      surface: cardLight,
      onSurface: inkDark,
      error: const Color(0xFFB00020),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: paperLight,
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: sepiaBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFEFE8D8),
        foregroundColor: inkDark,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: warmBronze,
          foregroundColor: Colors.white,
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
          foregroundColor: warmBronze,
          side: const BorderSide(color: warmBronze, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: sepiaBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: sepiaBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: warmBronze, width: 1.5),
        ),
      ),
    );
  }

  /// Preset 3: Midnight Arcana (Deep Navy & Cyan Glow)
  static ThemeData get midnightArcanaTheme {
    const spaceNavy = Color(0xFF0D1224);
    const surfaceNavy = Color(0xFF141D38);
    const cardNavy = Color(0xFF1C274C);
    const arcaneCyan = Color(0xFF00E5FF);
    const mysticViolet = Color(0xFFB388FF);
    const navyBorder = Color(0xFF2E3E6E);
    const textColor = Color(0xFFE2E8F8);

    final colorScheme = ColorScheme.dark(
      primary: arcaneCyan,
      onPrimary: Colors.black,
      secondary: mysticViolet,
      onSecondary: Colors.black,
      surface: surfaceNavy,
      onSurface: textColor,
      error: const Color(0xFFFF5252),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: spaceNavy,
      cardTheme: CardThemeData(
        color: cardNavy,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: navyBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: spaceNavy,
        foregroundColor: arcaneCyan,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: arcaneCyan,
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
          foregroundColor: arcaneCyan,
          side: const BorderSide(color: arcaneCyan, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF161F3B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: navyBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: navyBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: arcaneCyan, width: 1.5),
        ),
      ),
    );
  }

  /// Preset 4: High-Contrast Dungeon (OLED Black, Max Contrast Gold)
  static ThemeData get dungeonOledTheme {
    const oledBlack = Color(0xFF000000);
    const surfaceOled = Color(0xFF121212);
    const cardOled = Color(0xFF1E1E1E);
    const dungeonGold = Color(0xFFFFD700);
    const dangerRed = Color(0xFFFF4444);
    const borderGold = Color(0xFF554400);

    final colorScheme = ColorScheme.dark(
      primary: dungeonGold,
      onPrimary: Colors.black,
      secondary: dangerRed,
      onSecondary: Colors.white,
      surface: surfaceOled,
      onSurface: Colors.white,
      error: dangerRed,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: oledBlack,
      cardTheme: CardThemeData(
        color: cardOled,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderGold, width: 1.5),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: oledBlack,
        foregroundColor: dungeonGold,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: dungeonGold,
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
          foregroundColor: dungeonGold,
          side: const BorderSide(color: dungeonGold, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF181818),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGold),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dungeonGold, width: 2),
        ),
      ),
    );
  }
}

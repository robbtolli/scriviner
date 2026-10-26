import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/scrivener_theme_tokens.dart';

/// Supported visual theme presets for Scrivener.
enum AppThemeMode {
  ancientTome,
  scholarsDesk,
  midnightArcana,
  dungeonOled,
  emeraldEnclave,
  infernalBrimstone,
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
      case AppThemeMode.emeraldEnclave:
        return 'Emerald Enclave';
      case AppThemeMode.infernalBrimstone:
        return 'Infernal Brimstone';
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
      case AppThemeMode.emeraldEnclave:
        return 'Deep moss green, rich bark brown, and vibrant radiant jade';
      case AppThemeMode.infernalBrimstone:
        return 'Obsidian ash, smoky charcoal, and molten hellfire orange';
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
      case AppThemeMode.emeraldEnclave:
        return Icons.forest_outlined;
      case AppThemeMode.infernalBrimstone:
        return Icons.local_fire_department;
    }
  }
}

/// App-wide theme configurations with rich tabletop fantasy aesthetic and clean typography.
class AppTheme {
  const AppTheme._();

  // Legacy fantasy-inspired tokens preserved for compatibility
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
      case AppThemeMode.emeraldEnclave:
        return emeraldEnclaveTheme;
      case AppThemeMode.infernalBrimstone:
        return infernalBrimstoneTheme;
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

    const tokens = ScrivenerThemeTokens(
      cardGradient: LinearGradient(
        colors: [Color(0xFF382D20), Color(0xFF261F17)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      cardBorder: BorderSide(color: Color(0xFFC89B3C), width: 1.5),
      cardRadius: 12.0,
      cardPadding: EdgeInsets.all(16),
      cardElevation: 2.0,
      navigationStyle: CharacterNavigationStyle.horizontalTabs,
      tabContentStyle: CharacterTabContentStyle.iconsAndText,
      iconography: ScrivenerIconography.fantasy,
      fontFamily: 'Cinzel',
      accentColor: primaryGold,
      badgeColor: primaryGold,
      badgeTextColor: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: parchmentDark,
      textTheme: GoogleFonts.cinzelTextTheme(ThemeData.dark().textTheme).apply(
        fontFamilyFallback: const ['serif'],
        bodyColor: const Color(0xFFF2EBD9),
        displayColor: primaryGold,
      ),
      extensions: const [tokens],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

    const tokens = ScrivenerThemeTokens(
      cardGradient: LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFF4EFE6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      cardBorder: BorderSide(color: sepiaBorder, width: 1.0),
      cardRadius: 8.0,
      cardPadding: EdgeInsets.all(16),
      cardElevation: 1.5,
      navigationStyle: CharacterNavigationStyle.horizontalTabs,
      tabContentStyle: CharacterTabContentStyle.textOnly,
      iconography: ScrivenerIconography.classic,
      fontFamily: 'EBGaramond',
      accentColor: warmBronze,
      badgeColor: warmBronze,
      badgeTextColor: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: paperLight,
      textTheme: GoogleFonts.ebGaramondTextTheme(ThemeData.light().textTheme)
          .apply(
            fontFamilyFallback: const ['serif'],
            bodyColor: inkDark,
            displayColor: inkDark,
          ),
      extensions: const [tokens],
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    const spaceNavy = Color(0xFF0C101D);
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

    const tokens = ScrivenerThemeTokens(
      cardGradient: LinearGradient(
        colors: [Color(0xFF1E2850), Color(0xFF11172E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      cardBorder: BorderSide(color: Color(0xFF00E5FF), width: 1.5),
      cardRadius: 14.0,
      cardPadding: EdgeInsets.all(16),
      cardElevation: 3.0,
      navigationStyle: CharacterNavigationStyle.horizontalTabs,
      tabContentStyle: CharacterTabContentStyle.iconsAndText,
      iconography: ScrivenerIconography.arcana,
      fontFamily: 'Rajdhani',
      accentColor: arcaneCyan,
      badgeColor: arcaneCyan,
      badgeTextColor: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: spaceNavy,
      textTheme: GoogleFonts.rajdhaniTextTheme(ThemeData.dark().textTheme)
          .apply(
            fontFamilyFallback: const ['sans-serif'],
            bodyColor: textColor,
            displayColor: arcaneCyan,
          ),
      extensions: const [tokens],
      cardTheme: CardThemeData(
        color: cardNavy,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    const borderGold = Color(0xFFFFD700);

    final colorScheme = ColorScheme.dark(
      primary: dungeonGold,
      onPrimary: Colors.black,
      secondary: dangerRed,
      onSecondary: Colors.white,
      surface: surfaceOled,
      onSurface: Colors.white,
      error: dangerRed,
    );

    const tokens = ScrivenerThemeTokens(
      cardGradient: LinearGradient(
        colors: [Color(0xFF1E1E1E), Color(0xFF0A0A0A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      cardBorder: BorderSide(color: borderGold, width: 2.0),
      cardRadius: 4.0,
      cardPadding: EdgeInsets.all(16),
      cardElevation: 0.0,
      navigationStyle: CharacterNavigationStyle.headerDropdown,
      tabContentStyle: CharacterTabContentStyle.iconsAndText,
      iconography: ScrivenerIconography.dungeon,
      fontFamily: 'Chivo',
      accentColor: dungeonGold,
      badgeColor: dungeonGold,
      badgeTextColor: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: oledBlack,
      textTheme: GoogleFonts.chivoTextTheme(ThemeData.dark().textTheme).apply(
        fontFamilyFallback: const ['sans-serif'],
        bodyColor: Colors.white,
        displayColor: dungeonGold,
      ),
      extensions: const [tokens],
      cardTheme: CardThemeData(
        color: cardOled,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: borderGold, width: 2),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: dungeonGold,
          side: const BorderSide(color: dungeonGold, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF181818),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: borderGold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: borderGold),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: dungeonGold, width: 2),
        ),
      ),
    );
  }

  /// Preset 5: Emerald Enclave (Deep Forest & Radiant Jade)
  static ThemeData get emeraldEnclaveTheme {
    const forestBg = Color(0xFF0C1A13);
    const surfaceMoss = Color(0xFF13281E);
    const cardMoss = Color(0xFF1B3629);
    const jadeGlow = Color(0xFF00E676);
    const barkBrown = Color(0xFF8D6E63);
    const mossBorder = Color(0xFF28523E);
    const textColor = Color(0xFFE8F5E9);

    final colorScheme = ColorScheme.dark(
      primary: jadeGlow,
      onPrimary: Colors.black,
      secondary: barkBrown,
      onSecondary: Colors.white,
      surface: surfaceMoss,
      onSurface: textColor,
      error: const Color(0xFFFF5252),
    );

    const tokens = ScrivenerThemeTokens(
      cardGradient: LinearGradient(
        colors: [Color(0xFF1D3B2C), Color(0xFF0F2218)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      cardBorder: BorderSide(color: jadeGlow, width: 1.5),
      cardRadius: 12.0,
      cardPadding: EdgeInsets.all(16),
      cardElevation: 2.5,
      navigationStyle: CharacterNavigationStyle.horizontalTabs,
      tabContentStyle: CharacterTabContentStyle.iconsAndText,
      iconography: ScrivenerIconography.nature,
      fontFamily: 'CormorantGaramond',
      accentColor: jadeGlow,
      badgeColor: jadeGlow,
      badgeTextColor: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: forestBg,
      textTheme:
          GoogleFonts.cormorantGaramondTextTheme(
            ThemeData.dark().textTheme,
          ).apply(
            fontFamilyFallback: const ['serif'],
            bodyColor: textColor,
            displayColor: jadeGlow,
          ),
      extensions: const [tokens],
      cardTheme: CardThemeData(
        color: cardMoss,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: mossBorder, width: 1.2),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: forestBg,
        foregroundColor: jadeGlow,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: jadeGlow,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: jadeGlow,
          side: const BorderSide(color: jadeGlow, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF11231A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mossBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mossBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: jadeGlow, width: 1.5),
        ),
      ),
    );
  }

  /// Preset 6: Infernal Brimstone (Obsidian Ash & Molten Hellfire)
  static ThemeData get infernalBrimstoneTheme {
    const ashBg = Color(0xFF120C0E);
    const surfaceAsh = Color(0xFF1C1316);
    const cardAsh = Color(0xFF281B20);
    const hellfireOrange = Color(0xFFFF4500);
    const lavaGold = Color(0xFFFFD600);
    const brimstoneBorder = Color(0xFF4D242C);
    const textColor = Color(0xFFFFEBE8);

    final colorScheme = ColorScheme.dark(
      primary: hellfireOrange,
      onPrimary: Colors.black,
      secondary: lavaGold,
      onSecondary: Colors.black,
      surface: surfaceAsh,
      onSurface: textColor,
      error: const Color(0xFFFF1744),
    );

    const tokens = ScrivenerThemeTokens(
      cardGradient: LinearGradient(
        colors: [Color(0xFF331E24), Color(0xFF160B0E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      cardBorder: BorderSide(color: hellfireOrange, width: 1.5),
      cardRadius: 6.0,
      cardPadding: EdgeInsets.all(16),
      cardElevation: 3.0,
      navigationStyle: CharacterNavigationStyle.headerDropdown,
      tabContentStyle: CharacterTabContentStyle.iconsOnly,
      iconography: ScrivenerIconography.infernal,
      fontFamily: 'PirataOne',
      accentColor: hellfireOrange,
      badgeColor: hellfireOrange,
      badgeTextColor: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ashBg,
      textTheme: GoogleFonts.pirataOneTextTheme(ThemeData.dark().textTheme)
          .apply(
            fontFamilyFallback: const ['serif'],
            bodyColor: textColor,
            displayColor: hellfireOrange,
          ),
      extensions: const [tokens],
      cardTheme: CardThemeData(
        color: cardAsh,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: brimstoneBorder, width: 1.5),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ashBg,
        foregroundColor: hellfireOrange,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: hellfireOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: hellfireOrange,
          side: const BorderSide(color: hellfireOrange, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1317),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: brimstoneBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: brimstoneBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: hellfireOrange, width: 1.5),
        ),
      ),
    );
  }
}

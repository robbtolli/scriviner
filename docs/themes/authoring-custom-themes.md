# Authoring Custom Themes

This guide walks you step-by-step through creating a custom theme for Scrivener, from assembling color palettes and gradients to configuring typography, semantic iconography, and responsive tab navigation.

---

## 1. Overview of Theme Components

To add a new theme to Scrivener, you configure three primary objects:

1. **`ScrivenerThemeTokens`**: The visual tokens defining card gradients, borders, elevation, corner radius, badge colors, and navigation styles.
2. **`ScrivenerIconography`**: The semantic bundle of icons representing stats, skills, combat, spells, gear, rests, and dice.
3. **`ThemeData`**: Flutter's root theme containing `ColorScheme`, `TextTheme` (via `GoogleFonts`), and button styles.

---

## 2. Step-by-Step Tutorial: Creating the "Glacial Frost" Theme

In this example, we will build a sub-zero crystal blue and silver theme called **Glacial Frost**.

### Step 1: Define the Theme Mode Enum
In `lib/core/theme/app_theme.dart`, append your new theme to the `AppThemeMode` enum:

```dart
enum AppThemeMode {
  ancientTome,
  scholarsDesk,
  midnightArcana,
  dungeonOled,
  emeraldEnclave,
  infernalBrimstone,
  glacialFrost, // [NEW]
}
```

Add display metadata in the `AppThemeModeX` extension:
```dart
extension AppThemeModeX on AppThemeMode {
  String get displayName {
    switch (this) {
      ...
      case AppThemeMode.glacialFrost:
        return 'Glacial Frost';
    }
  }

  String get description {
    switch (this) {
      ...
      case AppThemeMode.glacialFrost:
        return 'Sub-zero crystal blue, glacial ice, and frosted silver accents';
    }
  }

  IconData get icon {
    switch (this) {
      ...
      case AppThemeMode.glacialFrost:
        return Icons.ac_unit;
    }
  }
}
```

---

### Step 2: Assemble Custom Iconography
Define a custom `ScrivenerIconography` bundle mapping your theme's flavor to app concepts:

```dart
static const ScrivenerIconography frostIconography = ScrivenerIconography(
  tabStats: Icons.snowing,
  tabSkills: Icons.star_border,
  tabCombat: Icons.shield_outlined,
  tabSpells: Icons.ac_unit,
  tabFeatures: Icons.diamond_outlined,
  tabGear: Icons.backpack_outlined,
  tabBio: Icons.edit_note,
  diceAction: Icons.casino_outlined,
  restAction: Icons.bedtime_outlined,
  themeSelector: Icons.palette_outlined,
  checkAction: Icons.play_arrow_outlined,
  saveAction: Icons.security,
);
```

---

### Step 3: Construct `ScrivenerThemeTokens`
Configure the card geometry, gradients, and navigation layout:

```dart
const frostTokens = ScrivenerThemeTokens(
  cardGradient: LinearGradient(
    colors: [Color(0xFF14243B), Color(0xFF0C1626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  cardBorder: BorderSide(color: Color(0xFF80D8FF), width: 1.5),
  cardRadius: 10.0,
  cardPadding: EdgeInsets.all(16),
  cardElevation: 2.5,
  navigationStyle: CharacterNavigationStyle.horizontalTabs,
  tabContentStyle: CharacterTabContentStyle.iconsAndText,
  iconography: frostIconography,
  fontFamily: 'Cinzel',
  accentColor: Color(0xFF80D8FF), // Frosted Ice Blue
  badgeColor: Color(0xFF80D8FF),
  badgeTextColor: Colors.black,
);
```

---

### Step 4: Assemble the Complete `ThemeData`
Combine colors, typography with system font fallbacks, and widget styles:

```dart
static ThemeData get glacialFrostTheme {
  const frostBg = Color(0xFF080E18);
  const surfaceIce = Color(0xFF101C2E);
  const cardIce = Color(0xFF172842);
  const crystalCyan = Color(0xFF80D8FF);
  const silverFrost = Color(0xFFECEFF1);

  final colorScheme = ColorScheme.dark(
    primary: crystalCyan,
    onPrimary: Colors.black,
    secondary: const Color(0xFF40C4FF),
    onSecondary: Colors.black,
    surface: surfaceIce,
    onSurface: silverFrost,
    error: const Color(0xFFFF5252),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: frostBg,
    textTheme: GoogleFonts.cinzelTextTheme(ThemeData.dark().textTheme).apply(
      fontFamilyFallback: const ['serif'],
      bodyColor: silverFrost,
      displayColor: crystalCyan,
    ),
    extensions: const [frostTokens],
    cardTheme: CardThemeData(
      color: cardIce,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFF2C4468), width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: frostBg,
      foregroundColor: crystalCyan,
      elevation: 0,
      centerTitle: false,
    ),
  );
}
```

---

### Step 5: Register in `AppTheme.getThemeData()`
In `AppTheme.getThemeData(AppThemeMode mode)`:

```dart
static ThemeData getThemeData(AppThemeMode mode) {
  switch (mode) {
    ...
    case AppThemeMode.glacialFrost:
      return glacialFrostTheme;
  }
}
```

---

## 3. Testing Your Theme

1. Run `flutter analyze` to verify that all tokens and extensions compile cleanly without warnings.
2. Run `flutter test` to ensure existing theme tests continue to pass.
3. Open Scrivener and tap the **Palette** icon in the AppBar. Select **Glacial Frost** to verify colors, typography, card gradients, and iconography live in the application.

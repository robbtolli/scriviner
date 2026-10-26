import 'package:flutter/material.dart';

/// Supported navigation layouts for switching between character sheet pages.
enum CharacterNavigationStyle {
  /// Traditional horizontal scrollable tab strip at the top of the sheet.
  horizontalTabs,

  /// Compact dropdown selector in the AppBar sub-header, freeing up vertical space.
  headerDropdown,
}

/// How tab labels and glyphs are rendered on tabs and page selectors.
enum CharacterTabContentStyle {
  /// Displays both the icon and the text title (Default).
  iconsAndText,

  /// Displays only the icon glyph (ultra-compact).
  iconsOnly,

  /// Displays only the text title (clean editorial).
  textOnly,
}

/// Semantic iconography bundle mapping functional app concepts to theme-styled glyphs.
class ScrivenerIconography {
  final IconData tabStats;
  final IconData tabSkills;
  final IconData tabCombat;
  final IconData tabSpells;
  final IconData tabFeatures;
  final IconData tabGear;
  final IconData tabBio;
  final IconData diceAction;
  final IconData restAction;
  final IconData themeSelector;
  final IconData checkAction;
  final IconData saveAction;

  const ScrivenerIconography({
    required this.tabStats,
    required this.tabSkills,
    required this.tabCombat,
    required this.tabSpells,
    required this.tabFeatures,
    required this.tabGear,
    required this.tabBio,
    required this.diceAction,
    required this.restAction,
    required this.themeSelector,
    required this.checkAction,
    required this.saveAction,
  });

  IconData get stats => tabStats;
  IconData get skills => tabSkills;
  IconData get combat => tabCombat;
  IconData get spells => tabSpells;
  IconData get features => tabFeatures;
  IconData get inventory => tabGear;
  IconData get bio => tabBio;

  /// Default fantasy rune iconography.
  static const ScrivenerIconography fantasy = ScrivenerIconography(
    tabStats: Icons.analytics_outlined,
    tabSkills: Icons.star_border_purple500_outlined,
    tabCombat: Icons.shield_outlined,
    tabSpells: Icons.auto_awesome,
    tabFeatures: Icons.military_tech_outlined,
    tabGear: Icons.backpack_outlined,
    tabBio: Icons.history_edu,
    diceAction: Icons.casino_outlined,
    restAction: Icons.hotel_outlined,
    themeSelector: Icons.palette_outlined,
    checkAction: Icons.casino_outlined,
    saveAction: Icons.security,
  );

  /// Classic scholarly iconography.
  static const ScrivenerIconography classic = ScrivenerIconography(
    tabStats: Icons.assessment_outlined,
    tabSkills: Icons.school_outlined,
    tabCombat: Icons.shield,
    tabSpells: Icons.menu_book,
    tabFeatures: Icons.bookmark_border,
    tabGear: Icons.inventory_2_outlined,
    tabBio: Icons.edit_note,
    diceAction: Icons.casino,
    restAction: Icons.bedtime_outlined,
    themeSelector: Icons.brush_outlined,
    checkAction: Icons.play_arrow_outlined,
    saveAction: Icons.verified_user_outlined,
  );

  /// Arcane cosmic astral iconography.
  static const ScrivenerIconography arcana = ScrivenerIconography(
    tabStats: Icons.insights,
    tabSkills: Icons.flare,
    tabCombat: Icons.shield_moon_outlined,
    tabSpells: Icons.diamond_outlined,
    tabFeatures: Icons.bolt,
    tabGear: Icons.token_outlined,
    tabBio: Icons.fingerprint,
    diceAction: Icons.adjust,
    restAction: Icons.nightlight_outlined,
    themeSelector: Icons.color_lens_outlined,
    checkAction: Icons.change_circle_outlined,
    saveAction: Icons.gpp_good_outlined,
  );

  /// Stark tactical dungeon iconography.
  static const ScrivenerIconography dungeon = ScrivenerIconography(
    tabStats: Icons.square_outlined,
    tabSkills: Icons.check_box_outline_blank,
    tabCombat: Icons.warning_amber_rounded,
    tabSpells: Icons.brightness_7,
    tabFeatures: Icons.flag_outlined,
    tabGear: Icons.grid_view,
    tabBio: Icons.article_outlined,
    diceAction: Icons.crop_square,
    restAction: Icons.pause_circle_outline,
    themeSelector: Icons.contrast,
    checkAction: Icons.done,
    saveAction: Icons.health_and_safety_outlined,
  );

  /// Verdant nature iconography.
  static const ScrivenerIconography nature = ScrivenerIconography(
    tabStats: Icons.forest_outlined,
    tabSkills: Icons.eco_outlined,
    tabCombat: Icons.nature_people_outlined,
    tabSpells: Icons.spa_outlined,
    tabFeatures: Icons.energy_savings_leaf_outlined,
    tabGear: Icons.shopping_bag_outlined,
    tabBio: Icons.park_outlined,
    diceAction: Icons.scatter_plot_outlined,
    restAction: Icons.bed_outlined,
    themeSelector: Icons.grass,
    checkAction: Icons.task_alt,
    saveAction: Icons.shield_outlined,
  );

  /// Fiendish volcanic infernal iconography.
  static const ScrivenerIconography infernal = ScrivenerIconography(
    tabStats: Icons.local_fire_department,
    tabSkills: Icons.whatshot,
    tabCombat: Icons.dangerous_outlined,
    tabSpells: Icons.flare_outlined,
    tabFeatures: Icons.crisis_alert,
    tabGear: Icons.inventory_outlined,
    tabBio: Icons.psychology_outlined,
    diceAction: Icons.casino_outlined,
    restAction: Icons.wb_twilight_outlined,
    themeSelector: Icons.fireplace,
    checkAction: Icons.local_fire_department_outlined,
    saveAction: Icons.security_update_warning_outlined,
  );
}

/// Rich multi-dimensional visual and layout tokens attached to [ThemeData.extensions].
class ScrivenerThemeTokens extends ThemeExtension<ScrivenerThemeTokens> {
  final LinearGradient cardGradient;
  final BorderSide cardBorder;
  final double cardRadius;
  final EdgeInsets cardPadding;
  final double cardElevation;
  final CharacterNavigationStyle navigationStyle;
  final CharacterTabContentStyle tabContentStyle;
  final ScrivenerIconography iconography;
  final String? fontFamily;
  final Color accentColor;
  final Color badgeColor;
  final Color badgeTextColor;

  const ScrivenerThemeTokens({
    required this.cardGradient,
    required this.cardBorder,
    required this.cardRadius,
    required this.cardPadding,
    required this.cardElevation,
    required this.navigationStyle,
    required this.tabContentStyle,
    required this.iconography,
    this.fontFamily,
    required this.accentColor,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  static const ScrivenerThemeTokens defaultTokens = ScrivenerThemeTokens(
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
    fontFamily: null,
    accentColor: Color(0xFFC89B3C),
    badgeColor: Color(0xFFC89B3C),
    badgeTextColor: Colors.black,
  );

  /// Default tokens for Ancient Tome.
  static const ScrivenerThemeTokens ancientTomeTokens = defaultTokens;

  @override
  ScrivenerThemeTokens copyWith({
    LinearGradient? cardGradient,
    BorderSide? cardBorder,
    double? cardRadius,
    EdgeInsets? cardPadding,
    double? cardElevation,
    CharacterNavigationStyle? navigationStyle,
    CharacterTabContentStyle? tabContentStyle,
    ScrivenerIconography? iconography,
    String? fontFamily,
    Color? accentColor,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    return ScrivenerThemeTokens(
      cardGradient: cardGradient ?? this.cardGradient,
      cardBorder: cardBorder ?? this.cardBorder,
      cardRadius: cardRadius ?? this.cardRadius,
      cardPadding: cardPadding ?? this.cardPadding,
      cardElevation: cardElevation ?? this.cardElevation,
      navigationStyle: navigationStyle ?? this.navigationStyle,
      tabContentStyle: tabContentStyle ?? this.tabContentStyle,
      iconography: iconography ?? this.iconography,
      fontFamily: fontFamily ?? this.fontFamily,
      accentColor: accentColor ?? this.accentColor,
      badgeColor: badgeColor ?? this.badgeColor,
      badgeTextColor: badgeTextColor ?? this.badgeTextColor,
    );
  }

  @override
  ScrivenerThemeTokens lerp(
    covariant ThemeExtension<ScrivenerThemeTokens>? other,
    double t,
  ) {
    if (other is! ScrivenerThemeTokens) return this;
    return ScrivenerThemeTokens(
      cardGradient:
          LinearGradient.lerp(cardGradient, other.cardGradient, t) ??
          cardGradient,
      cardBorder: BorderSide.lerp(cardBorder, other.cardBorder, t),
      cardRadius: cardRadius + (other.cardRadius - cardRadius) * t,
      cardPadding:
          EdgeInsets.lerp(cardPadding, other.cardPadding, t) ?? cardPadding,
      cardElevation: cardElevation + (other.cardElevation - cardElevation) * t,
      navigationStyle: t < 0.5 ? navigationStyle : other.navigationStyle,
      tabContentStyle: t < 0.5 ? tabContentStyle : other.tabContentStyle,
      iconography: t < 0.5 ? iconography : other.iconography,
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      accentColor: Color.lerp(accentColor, other.accentColor, t) ?? accentColor,
      badgeColor: Color.lerp(badgeColor, other.badgeColor, t) ?? badgeColor,
      badgeTextColor:
          Color.lerp(badgeTextColor, other.badgeTextColor, t) ?? badgeTextColor,
    );
  }
}

/// Convenient extension methods for accessing theme tokens from [BuildContext].
extension BuildContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  ScrivenerThemeTokens get tokens =>
      Theme.of(this).extension<ScrivenerThemeTokens>() ??
      ScrivenerThemeTokens.defaultTokens;
  ScrivenerIconography get icons => tokens.iconography;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/character_sheet/providers/character_sheet_provider.dart';
import 'app_theme.dart';

/// StateNotifier controlling the active application theme.
class ThemeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    return AppThemeMode.scrivener;
  }

  /// Changes the application theme preset.
  void setTheme(AppThemeMode mode) {
    state = mode;
  }
}

/// Global provider for the active theme preset.
final themeProvider = NotifierProvider<ThemeNotifier, AppThemeMode>(
  ThemeNotifier.new,
);

/// StateNotifier controlling the active theme brightness filter / mode.
class ThemeBrightnessNotifier extends Notifier<ThemeBrightnessMode> {
  @override
  ThemeBrightnessMode build() {
    return ThemeBrightnessMode.system;
  }

  /// Cycles between dark (moon), light (sun), and system (split circle).
  void cycleNext() {
    switch (state) {
      case ThemeBrightnessMode.dark:
        state = ThemeBrightnessMode.light;
        break;
      case ThemeBrightnessMode.light:
        state = ThemeBrightnessMode.system;
        break;
      case ThemeBrightnessMode.system:
        state = ThemeBrightnessMode.dark;
        break;
    }
  }

  /// Explicitly sets the brightness mode.
  void setMode(ThemeBrightnessMode mode) {
    state = mode;
  }
}

/// Global provider for the theme brightness mode filter (dark, light, system).
final themeBrightnessProvider =
    NotifierProvider<ThemeBrightnessNotifier, ThemeBrightnessMode>(
      ThemeBrightnessNotifier.new,
    );

/// Provider family resolving the effective theme mode for a given character:
/// returns character's custom theme if set, otherwise falls back to global app theme.
final characterThemeModeProvider = Provider.family<AppThemeMode, String>((
  ref,
  characterId,
) {
  final charSheet = ref.watch(characterSheetProvider(characterId));
  final globalMode = ref.watch(themeProvider);
  return charSheet?.customTheme ?? globalMode;
});

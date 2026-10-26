import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/character_sheet/providers/character_sheet_provider.dart';
import 'app_theme.dart';

/// StateNotifier controlling the active application theme.
class ThemeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    return AppThemeMode.ancientTome;
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

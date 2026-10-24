import 'package:flutter_riverpod/flutter_riverpod.dart';
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
final themeProvider = NotifierProvider<ThemeNotifier, AppThemeMode>(ThemeNotifier.new);

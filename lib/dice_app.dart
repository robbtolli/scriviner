import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/widgets/app_splash_screen.dart';
import 'features/dice/presentation/dice_standalone_screen.dart';

/// Root application widget for the standalone Dice Caster app.
class DiceCasterApp extends ConsumerWidget {
  const DiceCasterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final brightnessMode = ref.watch(themeBrightnessProvider);
    final systemBrightness =
        MediaQuery.maybePlatformBrightnessOf(context) ??
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    return MaterialApp(
      title: 'Dice Caster',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getThemeData(
        themeMode,
        brightnessMode: brightnessMode,
        systemBrightness: systemBrightness,
      ),
      home: const AppSplashScreen(
        title: 'Dice Caster',
        logoAsset: 'assets/icons/dice_caster_icon_transparent.png',
        child: DiceStandaloneScreen(),
      ),
    );
  }
}

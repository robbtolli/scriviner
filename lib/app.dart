import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/home/presentation/home_screen.dart';

class ScrivenerApp extends ConsumerWidget {
  const ScrivenerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final brightnessMode = ref.watch(themeBrightnessProvider);
    final systemBrightness = MediaQuery.maybePlatformBrightnessOf(context) ??
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    return MaterialApp(
      title: 'Scrivener',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getThemeData(
        themeMode,
        brightnessMode: brightnessMode,
        systemBrightness: systemBrightness,
      ),
      home: const HomeScreen(),
    );
  }
}

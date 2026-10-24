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

    return MaterialApp(
      title: 'Scrivener',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getThemeData(themeMode),
      home: const HomeScreen(),
    );
  }
}

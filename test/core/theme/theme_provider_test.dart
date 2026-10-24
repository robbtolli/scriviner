import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/theme/app_theme.dart';
import 'package:scrivener/core/theme/theme_provider.dart';
import 'package:scrivener/core/theme/theme_selector_dialog.dart';

void main() {
  group('Theme Engine Tests', () {
    test('themeProvider defaults to ancientTome and can switch themes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeProvider), AppThemeMode.ancientTome);

      container.read(themeProvider.notifier).setTheme(AppThemeMode.scholarsDesk);
      expect(container.read(themeProvider), AppThemeMode.scholarsDesk);

      container.read(themeProvider.notifier).setTheme(AppThemeMode.midnightArcana);
      expect(container.read(themeProvider), AppThemeMode.midnightArcana);

      container.read(themeProvider.notifier).setTheme(AppThemeMode.dungeonOled);
      expect(container.read(themeProvider), AppThemeMode.dungeonOled);
    });

    test('All AppThemeMode values produce valid ThemeData', () {
      for (final mode in AppThemeMode.values) {
        final theme = AppTheme.getThemeData(mode);
        expect(theme, isNotNull);
        expect(theme.colorScheme.primary, isNotNull);
        expect(theme.scaffoldBackgroundColor, isNotNull);
        expect(mode.displayName.isNotEmpty, isTrue);
        expect(mode.description.isNotEmpty, isTrue);
      }

      // Verify specific palettes
      final scholar = AppTheme.scholarsDeskTheme;
      expect(scholar.brightness, Brightness.light);

      final dungeon = AppTheme.dungeonOledTheme;
      expect(dungeon.scaffoldBackgroundColor, const Color(0xFF000000));

      final arcana = AppTheme.midnightArcanaTheme;
      expect(arcana.colorScheme.primary, const Color(0xFF00E5FF));
    });

    testWidgets('ThemeSelectorDialog displays all themes and selects one', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => ThemeSelectorDialog.show(context),
                  child: const Text('Open Themes'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Themes'));
      await tester.pumpAndSettle();

      expect(find.text('SELECT APP THEME'), findsOneWidget);
      expect(find.text('Ancient Tome'), findsOneWidget);
      expect(find.text("Scholar's Desk"), findsOneWidget);
      expect(find.text('Midnight Arcana'), findsOneWidget);
      expect(find.text('High-Contrast Dungeon'), findsOneWidget);

      // Tap High-Contrast Dungeon
      await tester.tap(find.text('High-Contrast Dungeon'));
      await tester.pumpAndSettle();

      // Tap DONE
      await tester.tap(find.text('DONE'));
      await tester.pumpAndSettle();

      expect(find.text('SELECT APP THEME'), findsNothing);
    });
  });
}

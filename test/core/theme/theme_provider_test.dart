import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/theme/app_theme.dart';
import 'package:scrivener/core/theme/theme_provider.dart';
import 'package:scrivener/core/theme/theme_selector_dialog.dart';

void main() {
  group('Theme Engine Tests', () {
    test('themeProvider defaults to scrivener and can switch themes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeProvider), AppThemeMode.scrivener);

      container
          .read(themeProvider.notifier)
          .setTheme(AppThemeMode.scholarsDesk);
      expect(container.read(themeProvider), AppThemeMode.scholarsDesk);

      container
          .read(themeProvider.notifier)
          .setTheme(AppThemeMode.midnightArcana);
      expect(container.read(themeProvider), AppThemeMode.midnightArcana);

      container.read(themeProvider.notifier).setTheme(AppThemeMode.dungeonOled);
      expect(container.read(themeProvider), AppThemeMode.dungeonOled);

      container
          .read(themeProvider.notifier)
          .setTheme(AppThemeMode.emeraldEnclave);
      expect(container.read(themeProvider), AppThemeMode.emeraldEnclave);

      container
          .read(themeProvider.notifier)
          .setTheme(AppThemeMode.infernalBrimstone);
      expect(container.read(themeProvider), AppThemeMode.infernalBrimstone);

      container.read(themeProvider.notifier).setTheme(AppThemeMode.ancientTome);
      expect(container.read(themeProvider), AppThemeMode.ancientTome);
    });

    test('All AppThemeMode values produce valid ThemeData', () {
      expect(AppThemeMode.values.length, 7);
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

      final enclave = AppTheme.emeraldEnclaveTheme;
      expect(enclave.colorScheme.primary, const Color(0xFF00E676));

      final brimstone = AppTheme.infernalBrimstoneTheme;
      expect(brimstone.colorScheme.primary, const Color(0xFFFF4500));

      final scrivener = AppTheme.scrivenerTheme;
      expect(scrivener.colorScheme.primary, const Color(0xFFF3C954));
      expect(scrivener.colorScheme.secondary, const Color(0xFFA855F7));
      expect(scrivener.brightness, Brightness.dark);

      final scrivenerLight = AppTheme.scrivenerLightTheme;
      expect(scrivenerLight.colorScheme.primary, const Color(0xFF6B21A8));
      expect(scrivenerLight.colorScheme.secondary, const Color(0xFF9333EA));
      expect(scrivenerLight.brightness, Brightness.light);

      final enclaveLight = AppTheme.emeraldEnclaveLightTheme;
      expect(enclaveLight.colorScheme.primary, const Color(0xFF1B5E20));
      expect(enclaveLight.brightness, Brightness.light);
    });

    test('ThemeBrightnessVariant classifications and visibility filters', () {
      expect(
        AppThemeMode.scholarsDesk.supportedBrightness,
        ThemeBrightnessVariant.light,
      );
      expect(
        AppThemeMode.ancientTome.supportedBrightness,
        ThemeBrightnessVariant.dark,
      );
      expect(
        AppThemeMode.midnightArcana.supportedBrightness,
        ThemeBrightnessVariant.dark,
      );
      expect(
        AppThemeMode.dungeonOled.supportedBrightness,
        ThemeBrightnessVariant.dark,
      );
      expect(
        AppThemeMode.infernalBrimstone.supportedBrightness,
        ThemeBrightnessVariant.dark,
      );
      expect(
        AppThemeMode.emeraldEnclave.supportedBrightness,
        ThemeBrightnessVariant.both,
      );
      expect(
        AppThemeMode.scrivener.supportedBrightness,
        ThemeBrightnessVariant.both,
      );

      // Light filter
      expect(
        AppThemeMode.scholarsDesk.isVisibleFor(ThemeBrightnessMode.light),
        isTrue,
      );
      expect(
        AppThemeMode.emeraldEnclave.isVisibleFor(ThemeBrightnessMode.light),
        isTrue,
      );
      expect(
        AppThemeMode.scrivener.isVisibleFor(ThemeBrightnessMode.light),
        isTrue,
      );
      expect(
        AppThemeMode.ancientTome.isVisibleFor(ThemeBrightnessMode.light),
        isFalse,
      );
      expect(
        AppThemeMode.midnightArcana.isVisibleFor(ThemeBrightnessMode.light),
        isFalse,
      );

      // Dark filter
      expect(
        AppThemeMode.scholarsDesk.isVisibleFor(ThemeBrightnessMode.dark),
        isFalse,
      );
      expect(
        AppThemeMode.ancientTome.isVisibleFor(ThemeBrightnessMode.dark),
        isTrue,
      );
      expect(
        AppThemeMode.emeraldEnclave.isVisibleFor(ThemeBrightnessMode.dark),
        isTrue,
      );
      expect(
        AppThemeMode.scrivener.isVisibleFor(ThemeBrightnessMode.dark),
        isTrue,
      );

      // System filter
      for (final mode in AppThemeMode.values) {
        expect(mode.isVisibleFor(ThemeBrightnessMode.system), isTrue);
      }
    });

    test('Dynamic variant resolution for dual-variant themes', () {
      // Scrivener
      final scrivenerLight = AppTheme.getThemeData(
        AppThemeMode.scrivener,
        brightnessMode: ThemeBrightnessMode.light,
      );
      expect(scrivenerLight.brightness, Brightness.light);

      final scrivenerDark = AppTheme.getThemeData(
        AppThemeMode.scrivener,
        brightnessMode: ThemeBrightnessMode.dark,
      );
      expect(scrivenerDark.brightness, Brightness.dark);

      final scrivenerSysLight = AppTheme.getThemeData(
        AppThemeMode.scrivener,
        brightnessMode: ThemeBrightnessMode.system,
        systemBrightness: Brightness.light,
      );
      expect(scrivenerSysLight.brightness, Brightness.light);

      final scrivenerSysDark = AppTheme.getThemeData(
        AppThemeMode.scrivener,
        brightnessMode: ThemeBrightnessMode.system,
        systemBrightness: Brightness.dark,
      );
      expect(scrivenerSysDark.brightness, Brightness.dark);

      // Emerald Enclave
      final enclaveLight = AppTheme.getThemeData(
        AppThemeMode.emeraldEnclave,
        brightnessMode: ThemeBrightnessMode.light,
      );
      expect(enclaveLight.brightness, Brightness.light);

      final enclaveDark = AppTheme.getThemeData(
        AppThemeMode.emeraldEnclave,
        brightnessMode: ThemeBrightnessMode.dark,
      );
      expect(enclaveDark.brightness, Brightness.dark);

      final enclaveSysLight = AppTheme.getThemeData(
        AppThemeMode.emeraldEnclave,
        brightnessMode: ThemeBrightnessMode.system,
        systemBrightness: Brightness.light,
      );
      expect(enclaveSysLight.brightness, Brightness.light);

      final enclaveSysDark = AppTheme.getThemeData(
        AppThemeMode.emeraldEnclave,
        brightnessMode: ThemeBrightnessMode.system,
        systemBrightness: Brightness.dark,
      );
      expect(enclaveSysDark.brightness, Brightness.dark);
    });

    test('themeBrightnessProvider cycles between system, dark, and light', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(themeBrightnessProvider),
        ThemeBrightnessMode.system,
      );

      container.read(themeBrightnessProvider.notifier).cycleNext();
      expect(container.read(themeBrightnessProvider), ThemeBrightnessMode.dark);

      container.read(themeBrightnessProvider.notifier).cycleNext();
      expect(
        container.read(themeBrightnessProvider),
        ThemeBrightnessMode.light,
      );

      container.read(themeBrightnessProvider.notifier).cycleNext();
      expect(
        container.read(themeBrightnessProvider),
        ThemeBrightnessMode.system,
      );
    });

    testWidgets('ThemeSelectorDialog displays all themes and selects one', (
      tester,
    ) async {
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
      expect(find.text('Emerald Enclave'), findsOneWidget);
      expect(find.text('Infernal Brimstone'), findsOneWidget);
      expect(find.text('Scrivener'), findsOneWidget);

      // Tap High-Contrast Dungeon
      await tester.ensureVisible(find.text('High-Contrast Dungeon'));
      await tester.tap(find.text('High-Contrast Dungeon'));
      await tester.pumpAndSettle();

      // Tap DONE
      await tester.tap(find.text('DONE'));
      await tester.pumpAndSettle();

      expect(find.text('SELECT APP THEME'), findsNothing);
    });

    testWidgets(
      'ThemeSelectorDialog brightness toggle filters themes dynamically',
      (tester) async {
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

        // Initial state: system mode (split circle icon) -> all 7 themes shown
        expect(find.byIcon(Icons.brightness_medium), findsOneWidget);
        expect(find.text("Scholar's Desk"), findsOneWidget);
        expect(find.text('Ancient Tome'), findsOneWidget);
        expect(find.text('Scrivener'), findsOneWidget);
        expect(find.text('Emerald Enclave'), findsOneWidget);

        // Tap toggle to switch to Dark mode (Moon icon)
        await tester.tap(find.byIcon(Icons.brightness_medium));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.dark_mode), findsOneWidget);
        // Dark themes are visible
        expect(find.text('Ancient Tome'), findsOneWidget);
        expect(find.text('Emerald Enclave'), findsOneWidget);
        expect(find.text('Scrivener'), findsOneWidget);
        // Scholar's Desk (light-only) is filtered out
        expect(find.text("Scholar's Desk"), findsNothing);

        // Tap toggle to switch to Light mode (Sun icon)
        await tester.tap(find.byIcon(Icons.dark_mode));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.light_mode), findsOneWidget);
        // Light and dual themes are visible
        expect(find.text("Scholar's Desk"), findsOneWidget);
        expect(find.text('Emerald Enclave'), findsOneWidget);
        expect(find.text('Scrivener'), findsOneWidget);
        // Dark-only themes are filtered out
        expect(find.text('Ancient Tome'), findsNothing);
        expect(find.text('Midnight Arcana'), findsNothing);
        expect(find.text('High-Contrast Dungeon'), findsNothing);
        expect(find.text('Infernal Brimstone'), findsNothing);

        // Tap toggle to return to System mode (Split circle)
        await tester.tap(find.byIcon(Icons.light_mode));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.brightness_medium), findsOneWidget);
        expect(find.text('Ancient Tome'), findsOneWidget);
        expect(find.text("Scholar's Desk"), findsOneWidget);
      },
    );
  });
}

import 'dart:convert';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/core/theme/app_theme.dart';
import 'package:scrivener/core/theme/theme_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/character_sheet_screen.dart';
import 'package:scrivener/features/character_sheet/providers/character_sheet_provider.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedCharacter({
    String id = 'char_test',
    String? themeName,
  }) async {
    final now = DateTime.now();
    final props = {
      'class': 'Wizard',
      'race': 'Elf',
      'level': 3,
      'theme': ?themeName,
      'abilities': {
        'str': {'score': 10, 'mod': 0},
        'dex': {'score': 14, 'mod': 2},
        'con': {'score': 12, 'mod': 1},
        'int': {'score': 16, 'mod': 3},
        'wis': {'score': 12, 'mod': 1},
        'cha': {'score': 10, 'mod': 0},
      },
      'hp': {'current': 16, 'max': 16, 'temp': 0},
      'armorClass': 12,
      'speed': 30,
    };

    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: id,
        name: 'Elrond',
        systemId: const Value('dnd5e'),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: jsonEncode(props),
      ),
    );
  }

  group('Character Theme Precedence Engine', () {
    test(
      'Character without customTheme inherits global app theme dynamically',
      () async {
        await seedCharacter(id: 'char_default');

        final container = ProviderContainer(
          overrides: [databaseProvider.overrideWithValue(db)],
        );
        addTearDown(container.dispose);

        // Initialize character sheet
        await container
            .read(characterSheetProvider('char_default').notifier)
            .refresh();
        final sheet = container.read(characterSheetProvider('char_default'));
        expect(sheet?.customTheme, isNull);

        // Check effective theme resolution
        expect(
          container.read(characterThemeModeProvider('char_default')),
          AppThemeMode.ancientTome,
        );

        // Change global app theme -> character theme automatically updates
        container
            .read(themeProvider.notifier)
            .setTheme(AppThemeMode.scholarsDesk);
        expect(
          container.read(characterThemeModeProvider('char_default')),
          AppThemeMode.scholarsDesk,
        );

        container
            .read(themeProvider.notifier)
            .setTheme(AppThemeMode.dungeonOled);
        expect(
          container.read(characterThemeModeProvider('char_default')),
          AppThemeMode.dungeonOled,
        );
      },
    );

    test(
      'Character with customTheme overrides global app theme and persists to SQLite',
      () async {
        await seedCharacter(id: 'char_arcana', themeName: 'midnightArcana');

        final container = ProviderContainer(
          overrides: [databaseProvider.overrideWithValue(db)],
        );
        addTearDown(container.dispose);

        await container
            .read(characterSheetProvider('char_arcana').notifier)
            .refresh();
        final sheet = container.read(characterSheetProvider('char_arcana'));
        expect(sheet?.customTheme, AppThemeMode.midnightArcana);

        // Character theme is Midnight Arcana even though global is Ancient Tome
        expect(container.read(themeProvider), AppThemeMode.ancientTome);
        expect(
          container.read(characterThemeModeProvider('char_arcana')),
          AppThemeMode.midnightArcana,
        );

        // Global changes DO NOT affect character with override
        container
            .read(themeProvider.notifier)
            .setTheme(AppThemeMode.scholarsDesk);
        expect(
          container.read(characterThemeModeProvider('char_arcana')),
          AppThemeMode.midnightArcana,
        );

        // Change character theme to Emerald Enclave
        await container
            .read(characterSheetProvider('char_arcana').notifier)
            .setTheme(AppThemeMode.emeraldEnclave);
        expect(
          container.read(characterThemeModeProvider('char_arcana')),
          AppThemeMode.emeraldEnclave,
        );

        // Verify SQLite rawPropertiesJson was updated
        final charRow = await db.getCharacter('char_arcana');
        final updatedProps =
            jsonDecode(charRow!.rawPropertiesJson) as Map<String, dynamic>;
        expect(updatedProps['theme'], 'emeraldEnclave');

        // Clear theme override -> reverts to global app theme
        await container
            .read(characterSheetProvider('char_arcana').notifier)
            .setTheme(null);
        expect(
          container.read(characterThemeModeProvider('char_arcana')),
          AppThemeMode.scholarsDesk,
        );

        final charRowCleared = await db.getCharacter('char_arcana');
        final clearedProps =
            jsonDecode(charRowCleared!.rawPropertiesJson)
                as Map<String, dynamic>;
        expect(clearedProps.containsKey('theme'), isFalse);
      },
    );

    testWidgets(
      'CharacterSheetScreen renders character custom theme and allows changing it via UI',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await seedCharacter(id: 'char_ui', themeName: 'infernalBrimstone');

        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: const MaterialApp(
              home: CharacterSheetScreen(characterId: 'char_ui'),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify character name and theme tooltip
        expect(find.text('Elrond'), findsOneWidget);
        expect(
          find.byTooltip('Character Theme (Infernal Brimstone)'),
          findsOneWidget,
        );

        // Tap Theme button
        await tester.tap(
          find.byTooltip('Character Theme (Infernal Brimstone)'),
        );
        await tester.pumpAndSettle();

        // Verify Theme Selector Dialog opened with character-specific options
        expect(find.text('THEME: ELROND'), findsOneWidget);
        expect(find.textContaining('App Default'), findsOneWidget);
        expect(find.text('Emerald Enclave'), findsOneWidget);

        // Scroll to Emerald Enclave and select it
        await tester.ensureVisible(find.text('Emerald Enclave'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Emerald Enclave'));
        await tester.pumpAndSettle();

        // Character sheet now displays Emerald Enclave
        expect(
          find.byTooltip('Character Theme (Emerald Enclave)'),
          findsOneWidget,
        );
      },
    );
  });
}

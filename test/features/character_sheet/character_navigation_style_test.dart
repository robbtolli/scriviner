import 'dart:convert';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/character_sheet_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedCharacter({required String id, required String themeName}) async {
    final now = DateTime.now();
    final props = {
      'class': 'Fighter',
      'race': 'Dwarf',
      'level': 1,
      'theme': themeName,
      'abilities': {
        'str': {'score': 16, 'mod': 3},
        'dex': {'score': 12, 'mod': 1},
        'con': {'score': 14, 'mod': 2},
        'int': {'score': 10, 'mod': 0},
        'wis': {'score': 12, 'mod': 1},
        'cha': {'score': 8, 'mod': -1},
      },
      'hp': {'current': 12, 'max': 12, 'temp': 0},
      'armorClass': 16,
      'speed': 25,
    };

    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: id,
        name: 'Bruenor',
        systemId: const Value('dnd5e'),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: jsonEncode(props),
      ),
    );
  }

  group('Character Sheet Navigation Layout Tests', () {
    testWidgets('Horizontal Tabs Mode (Ancient Tome) renders TabBar with icons and text', (tester) async {
      await seedCharacter(id: 'char_tome', themeName: 'ancientTome');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: CharacterSheetScreen(characterId: 'char_tome'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // TabBar is present
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(DropdownButton<int>), findsNothing);

      // Tab titles are visible
      expect(find.text('Stats'), findsWidgets);
      expect(find.text('Skills'), findsWidgets);
      expect(find.text('Combat'), findsWidgets);
    });

    testWidgets('Horizontal Tabs Text-Only Mode (Scholar\'s Desk) renders tabs without icons', (tester) async {
      await seedCharacter(id: 'char_scholar', themeName: 'scholarsDesk');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: CharacterSheetScreen(characterId: 'char_scholar'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // TabBar is present
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(DropdownButton<int>), findsNothing);

      // Verify Tab items do not contain an icon widget
      final tabWidgets = tester.widgetList<Tab>(find.byType(Tab));
      for (final tab in tabWidgets) {
        expect(tab.icon, isNull, reason: 'Scholar desk should have text-only tabs');
        expect(tab.text, isNotNull);
      }
    });

    testWidgets('Header Dropdown Mode (Infernal Brimstone) renders dropdown subheader and navigates pages', (tester) async {
      await seedCharacter(id: 'char_brimstone', themeName: 'infernalBrimstone');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: CharacterSheetScreen(characterId: 'char_brimstone'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // TabBar is NOT present in headerDropdown mode
      expect(find.byType(TabBar), findsNothing);

      // DropdownButton is present
      expect(find.byType(DropdownButton<int>), findsOneWidget);
      expect(find.text('Page 1 of 7'), findsOneWidget);

      // Tap dropdown to select a different page (e.g. Combat / page 2)
      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pumpAndSettle();

      // Tap 'Skills' in the dropdown menu
      await tester.tap(find.text('Skills').last);
      await tester.pumpAndSettle();

      // Active page is now updated to Page 2
      expect(find.text('Page 2 of 7'), findsOneWidget);
    });
  });
}

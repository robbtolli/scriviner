import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/export_import/presentation/export_character_dialog.dart';
import 'package:scrivener/features/export_import/presentation/import_character_dialog.dart';
import 'package:scrivener/features/export_import/services/character_export_service.dart';

void main() {
  late AppDatabase db;
  late CharacterExportService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = CharacterExportService();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedTestCharacter() async {
    final now = DateTime.now();
    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: 'char-thorin',
        name: 'Thorin Oakenshield',
        systemId: const Value('dnd5e'),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: jsonEncode({
          'class': 'Fighter',
          'race': 'Dwarf',
          'level': 5,
          'hp': {'current': 45, 'max': 45},
          'abilities': {'strength': 18, 'constitution': 16},
        }),
        notes: const Value('King under the mountain'),
      ),
    );

    await db.addCondition(
      ConditionsTableCompanion.insert(
        id: 'cond-1',
        characterId: 'char-thorin',
        conditionId: 'blessed',
        durationRounds: const Value(10),
        customNotes: const Value('Cast by cleric'),
      ),
    );

    await db.upsertInventoryItem(
      InventoryTableCompanion.insert(
        id: 'inv-1',
        characterId: 'char-thorin',
        name: 'Orcrist the Goblin-cleaver',
        quantity: const Value(1),
        weight: const Value(3.0),
        isEquipped: const Value(true),
        containerName: const Value('Equipped'),
        itemDataJson: const Value('{"damage": "1d8+3"}'),
      ),
    );
  }

  group('CharacterExportService Tests', () {
    test('exports full character to JSON with conditions and inventory', () async {
      await seedTestCharacter();

      final jsonString = await service.exportCharacterToJson(db, 'char-thorin');
      expect(jsonString.isNotEmpty, isTrue);

      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      expect(decoded['format'], 'scrivener-character-backup');
      expect(decoded['schemaVersion'], 1);

      final char = decoded['character'];
      expect(char['id'], 'char-thorin');
      expect(char['name'], 'Thorin Oakenshield');
      expect(char['rawProperties']['class'], 'Fighter');

      final conditions = decoded['conditions'] as List;
      expect(conditions.length, 1);
      expect(conditions.first['conditionId'], 'blessed');

      final inventory = decoded['inventory'] as List;
      expect(inventory.length, 1);
      expect(inventory.first['name'], 'Orcrist the Goblin-cleaver');
      expect(inventory.first['isEquipped'], isTrue);
    });

    test('imports character from JSON and deduplicates IDs', () async {
      await seedTestCharacter();
      final jsonString = await service.exportCharacterToJson(db, 'char-thorin');

      final newCharId = await service.importCharacterFromJson(db, jsonString, generateNewId: true);
      expect(newCharId, isNot('char-thorin'));

      final importedChar = await db.getCharacter(newCharId);
      expect(importedChar, isNotNull);
      expect(importedChar!.name, 'Thorin Oakenshield');

      final importedConditions = await db.getConditionsForCharacter(newCharId);
      expect(importedConditions.length, 1);
      expect(importedConditions.first.characterId, newCharId);
      expect(importedConditions.first.conditionId, 'blessed');

      final importedInventory = await db.getInventoryForCharacter(newCharId);
      expect(importedInventory.length, 1);
      expect(importedInventory.first.characterId, newCharId);
      expect(importedInventory.first.name, 'Orcrist the Goblin-cleaver');
    });

    test('throws FormatException on malformed JSON payload', () async {
      expect(
        () => service.importCharacterFromJson(db, 'not valid json'),
        throwsA(isA<FormatException>()),
      );

      expect(
        () => service.importCharacterFromJson(db, '{"format": "invalid"}'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('Export/Import Dialogs Widget Tests', () {
    testWidgets('ExportCharacterDialog renders payload and copies to clipboard', (tester) async {
      await seedTestCharacter();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ExportCharacterDialog(
                characterId: 'char-thorin',
                characterName: 'Thorin Oakenshield',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('EXPORT: THORIN OAKENSHIELD'), findsOneWidget);
      expect(find.textContaining('scrivener-character-backup'), findsOneWidget);
      expect(find.text('COPY TO CLIPBOARD'), findsOneWidget);

      await tester.tap(find.text('COPY TO CLIPBOARD'));
      await tester.pumpAndSettle();

      expect(find.textContaining('copied to clipboard!'), findsOneWidget);
    });

    testWidgets('ImportCharacterDialog imports valid JSON and triggers callback', (tester) async {
      String? importedId;

      const validPayload = '''
      {
        "format": "scrivener-character-backup",
        "schemaVersion": 1,
        "character": {
          "name": "Bilbo Baggins",
          "systemId": "dnd5e",
          "rawProperties": {
            "class": "Rogue",
            "race": "Halfling",
            "level": 3
          }
        },
        "conditions": [],
        "inventory": []
      }
      ''';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ImportCharacterDialog(
                onCharacterImported: (id) => importedId = id,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('IMPORT HERO (JSON)'), findsOneWidget);

      // Enter valid JSON
      await tester.enterText(find.byType(TextField), validPayload);
      await tester.pumpAndSettle();

      // Tap IMPORT HERO
      await tester.tap(find.text('IMPORT HERO'));
      await tester.pumpAndSettle();

      expect(importedId, isNotNull);
      final character = await db.getCharacter(importedId!);
      expect(character, isNotNull);
      expect(character!.name, 'Bilbo Baggins');
    });
  });
}

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // In-memory database for fast, isolated unit testing
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('AppDatabase - Characters & Recent Queries', () {
    test('inserts and queries recent characters in descending order of lastPlayedAt', () async {
      final now = DateTime.now();

      await db.upsertCharacter(CharactersTableCompanion.insert(
        id: 'char-1',
        name: 'Gandalf',
        createdAt: now.subtract(const Duration(days: 10)),
        lastPlayedAt: now.subtract(const Duration(hours: 3)),
        rawPropertiesJson: '{"level": 20}',
      ));

      await db.upsertCharacter(CharactersTableCompanion.insert(
        id: 'char-2',
        name: 'Aragorn',
        createdAt: now.subtract(const Duration(days: 5)),
        lastPlayedAt: now.subtract(const Duration(hours: 1)), // More recent!
        rawPropertiesJson: '{"level": 12}',
      ));

      await db.upsertCharacter(CharactersTableCompanion.insert(
        id: 'char-3',
        name: 'Frodo',
        createdAt: now.subtract(const Duration(days: 1)),
        lastPlayedAt: now.subtract(const Duration(hours: 5)), // Least recent
        rawPropertiesJson: '{"level": 3}',
      ));

      final recents = await db.getRecentCharacters(limit: 10);
      expect(recents.length, equals(3));
      expect(recents[0].id, equals('char-2')); // Aragorn (1 hr ago)
      expect(recents[1].id, equals('char-1')); // Gandalf (3 hrs ago)
      expect(recents[2].id, equals('char-3')); // Frodo (5 hrs ago)
    });

    test('touchCharacterLastPlayed updates order', () async {
      final now = DateTime.now();

      await db.upsertCharacter(CharactersTableCompanion.insert(
        id: 'char-1',
        name: 'Thorin',
        createdAt: now,
        lastPlayedAt: now.subtract(const Duration(hours: 2)),
        rawPropertiesJson: '{}',
      ));

      await db.upsertCharacter(CharactersTableCompanion.insert(
        id: 'char-2',
        name: 'Bilbo',
        createdAt: now,
        lastPlayedAt: now.subtract(const Duration(hours: 1)),
        rawPropertiesJson: '{}',
      ));

      // Initially Bilbo is first
      var recents = await db.getRecentCharacters(limit: 10);
      expect(recents.first.id, equals('char-2'));

      // Touch Thorin
      await db.touchCharacterLastPlayed('char-1');

      // Now Thorin should be first
      recents = await db.getRecentCharacters(limit: 10);
      expect(recents.first.id, equals('char-1'));
    });

    test('deleting character cascades to conditions and inventory', () async {
      final now = DateTime.now();
      const charId = 'hero-123';

      await db.upsertCharacter(CharactersTableCompanion.insert(
        id: charId,
        name: 'Legolas',
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: '{}',
      ));

      await db.addCondition(ConditionsTableCompanion.insert(
        id: 'cond-1',
        characterId: charId,
        conditionId: 'poisoned',
      ));

      await db.upsertInventoryItem(InventoryTableCompanion.insert(
        id: 'item-1',
        characterId: charId,
        name: 'Elven Bow',
      ));

      // Verify they exist
      final conditionsBefore = await db.watchConditionsForCharacter(charId).first;
      final inventoryBefore = await db.watchInventoryForCharacter(charId).first;
      expect(conditionsBefore.length, equals(1));
      expect(inventoryBefore.length, equals(1));

      // Delete character
      await db.deleteCharacter(charId);

      // Verify character and cascaded relations are gone
      final charAfter = await db.getCharacter(charId);
      final conditionsAfter = await db.watchConditionsForCharacter(charId).first;
      final inventoryAfter = await db.watchInventoryForCharacter(charId).first;

      expect(charAfter, isNull);
      expect(conditionsAfter, isEmpty);
      expect(inventoryAfter, isEmpty);
    });

    test('compendium search finds entries by system, category, and keyword', () async {
      await db.insertCompendiumEntries([
        CompendiumTableCompanion.insert(
          id: 'spell-fireball',
          systemId: 'dnd5e',
          category: 'spell',
          name: 'Fireball',
          summary: const Value('A bright streak flashes from your pointing finger...'),
        ),
        CompendiumTableCompanion.insert(
          id: 'spell-cure-wounds',
          systemId: 'dnd5e',
          category: 'spell',
          name: 'Cure Wounds',
          summary: const Value('A creature you touch regains hit points...'),
        ),
        CompendiumTableCompanion.insert(
          id: 'item-longsword',
          systemId: 'dnd5e',
          category: 'item',
          name: 'Longsword',
          summary: const Value('1d8 slashing versatile (1d10)'),
        ),
      ]);

      // Search all spells in dnd5e
      final spells = await db.searchCompendium('dnd5e', category: 'spell');
      expect(spells.length, equals(2));

      // Search by name keyword
      final searchResult = await db.searchCompendium('dnd5e', query: 'Fire');
      expect(searchResult.length, equals(1));
      expect(searchResult.first.name, equals('Fireball'));
    });
  });
}

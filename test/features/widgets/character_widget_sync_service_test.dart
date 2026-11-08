import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/features/widgets/character_widget_sync_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CharacterWidgetSummary Tests', () {
    test('serializes and deserializes correctly', () {
      const summary = CharacterWidgetSummary(
        id: 'hero-1',
        name: 'Gimli',
        classLevel: 'Dwarf • Fighter 5',
        currentHp: 45,
        maxHp: 52,
      );

      final json = summary.toJson();
      expect(json['id'], 'hero-1');
      expect(json['name'], 'Gimli');
      expect(json['classLevel'], 'Dwarf • Fighter 5');
      expect(json['currentHp'], 45);
      expect(json['maxHp'], 52);

      final revived = CharacterWidgetSummary.fromJson(json);
      expect(revived.id, summary.id);
      expect(revived.name, summary.name);
      expect(revived.classLevel, summary.classLevel);
      expect(revived.currentHp, summary.currentHp);
      expect(revived.maxHp, summary.maxHp);
    });

    test('fromCharacterData parses 5e properties accurately', () {
      final character = CharactersTableData(
        id: 'char-101',
        name: 'Aurelia',
        systemId: 'dnd5e',
        portraitUri: null,
        createdAt: DateTime.now(),
        lastPlayedAt: DateTime.now(),
        rawPropertiesJson: jsonEncode({
          'race': 'High Elf',
          'className': 'Wizard',
          'level': 4,
          'currentHp': 22,
          'maxHp': 22,
        }),
        notes: '',
      );

      final summary = CharacterWidgetSummary.fromCharacterData(character);
      expect(summary.id, 'char-101');
      expect(summary.name, 'Aurelia');
      expect(summary.classLevel, 'High Elf • Wizard 4');
      expect(summary.currentHp, 22);
      expect(summary.maxHp, 22);
    });

    test('fromCharacterData parses nested hp map accurately', () {
      final character = CharactersTableData(
        id: 'char-nested-hp',
        name: 'Gareth',
        systemId: 'dnd5e',
        portraitUri: null,
        createdAt: DateTime.now(),
        lastPlayedAt: DateTime.now(),
        rawPropertiesJson: jsonEncode({
          'race': 'Human',
          'className': 'Paladin',
          'level': 2,
          'hp': {'current': 15, 'max': 18, 'temp': 0},
        }),
        notes: '',
      );

      final summary = CharacterWidgetSummary.fromCharacterData(character);
      expect(summary.currentHp, 15);
      expect(summary.maxHp, 18);
      expect(summary.classLevel, 'Human • Paladin 2');
    });

    test(
      'fromCharacterData handles fallback and missing values gracefully',
      () {
        final character = CharactersTableData(
          id: 'char-102',
          name: '',
          systemId: 'dnd5e',
          portraitUri: null,
          createdAt: DateTime.now(),
          lastPlayedAt: DateTime.now(),
          rawPropertiesJson: 'invalid json',
          notes: '',
        );

        final summary = CharacterWidgetSummary.fromCharacterData(character);
        expect(summary.id, 'char-102');
        expect(summary.name, 'Unnamed Hero');
        expect(summary.classLevel, 'Adventurer');
        expect(summary.currentHp, 10);
        expect(summary.maxHp, 10);
      },
    );

    test(
      'syncAll and syncCharacter execute safely without unhandled error',
      () async {
        final character = CharactersTableData(
          id: 'char-103',
          name: 'Thorin',
          systemId: 'dnd5e',
          portraitUri: null,
          createdAt: DateTime.now(),
          lastPlayedAt: DateTime.now(),
          rawPropertiesJson: jsonEncode({
            'race': 'Dwarf',
            'className': 'Barbarian',
            'level': 3,
            'currentHp': 35,
            'maxHp': 35,
          }),
          notes: '',
        );

        // Should complete normally without throwing, even when platform channel is unmocked
        await CharacterWidgetSyncService.syncCharacter(character);
        await CharacterWidgetSyncService.syncAll([character]);
      },
    );
  });
}

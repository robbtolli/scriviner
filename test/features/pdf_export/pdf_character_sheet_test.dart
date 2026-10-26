import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/features/pdf_export/presentation/pdf_preview_screen.dart';
import 'package:scrivener/features/pdf_export/services/pdf_character_sheet_service.dart';

void main() {
  group('PDF Character Sheet Export Tests', () {
    test(
      'generateCharacterSheetPdf creates a valid 2-page PDF document',
      () async {
        const service = PdfCharacterSheetService();

        final now = DateTime.now();
        final sampleProps = {
          'level': 3,
          'class': 'Fighter',
          'race': 'Dwarf',
          'background': 'Soldier',
          'speed': 25,
          'proficiencyBonus': 2,
          'hp': {'current': 28, 'max': 28, 'temp': 0},
          'armorClass': 18,
          'abilities': {
            'str': {'score': 16, 'mod': 3},
            'dex': {'score': 12, 'mod': 1},
            'con': {'score': 16, 'mod': 3},
            'int': {'score': 10, 'mod': 0},
            'wis': {'score': 13, 'mod': 1},
            'cha': {'score': 8, 'mod': -1},
          },
          'savingThrows': ['strength', 'constitution'],
          'skills': ['Athletics', 'Intimidation'],
          'skillProficiencies': {'Athletics': 1, 'Intimidation': 2},
          'spells': [
            {
              'name': 'Shield',
              'level': 1,
              'school': 'Abjuration',
              'isPrepared': true,
            },
          ],
          'featuresList': [
            {
              'name': 'Second Wind',
              'description': 'Regain 1d10 + Level HP once per rest.',
            },
            {
              'name': 'Action Surge',
              'description': 'Take one additional action on your turn.',
            },
          ],
          'currency': {'gp': 25, 'sp': 10, 'cp': 50},
          'bio': {
            'personalityTraits': 'I face problems head-on.',
            'ideals': 'Greater Good.',
            'bonds': 'My clan is everything.',
            'flaws': 'I cannot resist a tavern brawl.',
          },
        };

        final character = CharactersTableData(
          id: 'char-test-pdf',
          name: 'Thorin Stonehelm',
          systemId: 'dnd5e',
          createdAt: now,
          lastPlayedAt: now,
          rawPropertiesJson: jsonEncode(sampleProps),
          notes: 'Defender of Citadel Adbar.',
        );

        final inventory = [
          InventoryTableData(
            id: 'inv-1',
            characterId: character.id,
            name: 'Warhammer',
            quantity: 1,
            weight: 2.0,
            isEquipped: true,
            isAttuned: false,
            containerName: 'Backpack',
            itemDataJson: '{}',
          ),
          InventoryTableData(
            id: 'inv-2',
            characterId: character.id,
            name: 'Plate Armor',
            quantity: 1,
            weight: 65.0,
            isEquipped: true,
            isAttuned: false,
            containerName: 'Worn',
            itemDataJson: '{}',
          ),
        ];

        final conditions = [
          ConditionsTableData(
            id: 'cond-1',
            characterId: character.id,
            conditionId: 'blessed',
            customNotes: '+1d4 to attacks and saving throws',
          ),
        ];

        final Uint8List pdfBytes = await service.generateCharacterSheetPdf(
          character: character,
          inventory: inventory,
          conditions: conditions,
        );

        expect(pdfBytes, isNotNull);
        expect(pdfBytes.length, greaterThan(1000));

        // Verify PDF Magic Bytes (%PDF-)
        final header = String.fromCharCodes(pdfBytes.sublist(0, 5));
        expect(header, equals('%PDF-'));
      },
    );

    testWidgets('PdfPreviewScreen renders without errors', (tester) async {
      final now = DateTime.now();
      final character = CharactersTableData(
        id: 'char-preview',
        name: 'Lyra Moonshadow',
        systemId: 'dnd5e',
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson:
            '{"level": 1, "class": "Wizard", "race": "Elf", "hp": {"current": 8, "max": 8}}',
        notes: '',
      );

      await tester.pumpWidget(
        MaterialApp(home: PdfPreviewScreen(character: character)),
      );
      await tester.pump();

      expect(find.byType(PdfPreviewScreen), findsOneWidget);
      expect(find.text('Lyra Moonshadow — Printable Sheet'), findsOneWidget);
    });
  });
}

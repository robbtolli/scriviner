import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/character_sheet_screen.dart';
import 'package:scrivener/features/character_wizard/models/srd_starter_data.dart';
import 'package:scrivener/features/character_wizard/models/wizard_draft.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('wizard character sheet loads completely without getting stuck on loading spinner', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // 1. Create a Wizard character through WizardDraft
    final wizardClass = SrdStarterData.classes.firstWhere((c) => c.id == 'wizard');
    final elfRace = SrdStarterData.races.firstWhere((r) => r.id == 'elf');
    final sageBackground = SrdStarterData.backgrounds.firstWhere((b) => b.id == 'sage');

    final draft = WizardDraft(
      name: 'Gandalf the Grey',
      charClass: wizardClass,
      race: elfRace,
      background: sageBackground,
      selectedSkills: {'Arcana', 'History'},
      selectedSpells: {'Fire Bolt', 'Mage Armor', 'Magic Missile'},
      baseAbilities: {
        'STR': 8,
        'DEX': 14,
        'CON': 13,
        'INT': 15,
        'WIS': 12,
        'CHA': 10,
      },
    );

    final companion = draft.toCharacterCompanion();
    await db.upsertCharacter(companion);
    final charId = companion.id.value;

    // 2. Pump CharacterSheetScreen for this Wizard character
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: CharacterSheetScreen(characterId: charId),
        ),
      ),
    );

    // Initial pump
    await tester.pump();
    // Pump and settle to let database stream / async notifier load
    await tester.pumpAndSettle();

    // 3. Verify that the loading spinner is GONE and character sheet loaded!
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Gandalf the Grey'), findsOneWidget);
    expect(find.textContaining('Level 1 Wizard (Elf)'), findsOneWidget);

    // 4. Verify Stats tab displays Intelligence (primary stat for Wizard)
    expect(find.text('INTELLIGENCE'), findsOneWidget);
    expect(find.text('HERO LEVEL'), findsOneWidget);

    // 5. Switch to Spells tab and verify selected spells are present
    await tester.tap(find.text('Spells'));
    await tester.pumpAndSettle();

    expect(find.text('Fire Bolt'), findsOneWidget);
    expect(find.text('Mage Armor'), findsOneWidget);
    expect(find.text('Magic Missile'), findsOneWidget);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('handles backward compatibility for raw string spells in existing characters', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Simulate an older character record where spells were saved as a list of raw strings
    const rawJsonWithRawStringSpells = '''
    {
      "level": 1,
      "class": "Wizard",
      "race": "Human",
      "abilities": {
        "str": {"score": 10, "mod": 0},
        "dex": {"score": 12, "mod": 1},
        "con": {"score": 14, "mod": 2},
        "int": {"score": 16, "mod": 3},
        "wis": {"score": 12, "mod": 1},
        "cha": {"score": 8, "mod": -1}
      },
      "spells": ["Fire Bolt", "Mage Armor"],
      "spellSlots": {
        "level1": {"total": 2, "spent": 0}
      }
    }
    ''';

    final now = DateTime.now();
    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: 'legacy_wizard',
        name: 'Legacy Mage',
        systemId: const Value('dnd5e'),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: rawJsonWithRawStringSpells,
      ),
    );

    // Pump CharacterSheetScreen for the legacy wizard
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: CharacterSheetScreen(characterId: 'legacy_wizard'),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    // Verify it doesn't crash or get stuck on a spinner
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Legacy Mage'), findsOneWidget);

    // Check Spells Tab
    await tester.tap(find.text('Spells'));
    await tester.pumpAndSettle();

    expect(find.text('Fire Bolt'), findsOneWidget);
    expect(find.text('Mage Armor'), findsOneWidget);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

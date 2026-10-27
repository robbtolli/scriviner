import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/providers/character_sheet_provider.dart';
import 'package:scrivener/features/character_wizard/models/srd_starter_data.dart';
import 'package:scrivener/features/character_wizard/presentation/steps/step_2_race.dart';
import 'package:scrivener/features/character_wizard/providers/wizard_provider.dart';

void main() {
  group('Races & Subraces Expansion Tests', () {
    late AppDatabase db;
    late ProviderContainer container;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test('All 12 core races and 7 expanded races exist with valid stats', () {
      final coreRaces = SrdStarterData.races
          .where((r) => !r.isExpanded)
          .toList();
      final expandedRaces = SrdStarterData.races
          .where((r) => r.isExpanded)
          .toList();

      expect(coreRaces.length, equals(12));
      expect(expandedRaces.length, equals(7));

      // Check Tier 1 races in core
      expect(coreRaces.any((r) => r.id == 'aasimar'), isTrue);
      expect(coreRaces.any((r) => r.id == 'goliath'), isTrue);
      expect(coreRaces.any((r) => r.id == 'orc'), isTrue);

      // Check Tier 2 races in expanded
      expect(expandedRaces.any((r) => r.id == 'tabaxi'), isTrue);
      expect(expandedRaces.any((r) => r.id == 'genasi'), isTrue);
      expect(expandedRaces.any((r) => r.id == 'tortle'), isTrue);
      expect(expandedRaces.any((r) => r.id == 'firbolg'), isTrue);
      expect(expandedRaces.any((r) => r.id == 'changeling'), isTrue);
      expect(expandedRaces.any((r) => r.id == 'goblin'), isTrue);
      expect(expandedRaces.any((r) => r.id == 'kobold'), isTrue);
    });

    test('Subraces are defined on core and expanded races', () {
      final elf = SrdStarterData.races.firstWhere((r) => r.id == 'elf');
      expect(
        elf.subraces.map((s) => s.id),
        containsAll(['high_elf', 'wood_elf', 'drow', 'sea_elf']),
      );

      final dwarf = SrdStarterData.races.firstWhere((r) => r.id == 'dwarf');
      expect(
        dwarf.subraces.map((s) => s.id),
        containsAll(['hill_dwarf', 'mountain_dwarf']),
      );

      final halfling = SrdStarterData.races.firstWhere(
        (r) => r.id == 'halfling',
      );
      expect(
        halfling.subraces.map((s) => s.id),
        containsAll(['lightfoot_halfling', 'stout_halfling']),
      );

      final gnome = SrdStarterData.races.firstWhere((r) => r.id == 'gnome');
      expect(
        gnome.subraces.map((s) => s.id),
        containsAll(['forest_gnome', 'rock_gnome']),
      );

      final aasimar = SrdStarterData.races.firstWhere((r) => r.id == 'aasimar');
      expect(
        aasimar.subraces.map((s) => s.id),
        containsAll(['protector_aasimar', 'scourge_aasimar', 'fallen_aasimar']),
      );

      final genasi = SrdStarterData.races.firstWhere((r) => r.id == 'genasi');
      expect(
        genasi.subraces.map((s) => s.id),
        containsAll([
          'air_genasi',
          'earth_genasi',
          'fire_genasi',
          'water_genasi',
        ]),
      );
    });

    test('Selecting subrace modifies final abilities and speed override', () {
      final notifier = container.read(characterWizardProvider.notifier);
      final elf = SrdStarterData.races.firstWhere((r) => r.id == 'elf');
      notifier.setRace(elf);

      // Base Elf: DEX +2, Speed 30
      var draft = container.read(characterWizardProvider);
      expect(draft.finalAbilities['DEX'], equals(12)); // 10 base + 2
      expect(draft.finalAbilities['INT'], equals(10));
      expect(draft.finalAbilities['WIS'], equals(10));
      expect(draft.speed, equals(30));

      // Select High Elf: INT +1
      final highElf = elf.subraces.firstWhere((s) => s.id == 'high_elf');
      notifier.setSubrace(highElf);
      draft = container.read(characterWizardProvider);
      expect(draft.finalAbilities['DEX'], equals(12));
      expect(draft.finalAbilities['INT'], equals(11));
      expect(draft.speed, equals(30));

      // Select Wood Elf: WIS +1, Speed 35
      final woodElf = elf.subraces.firstWhere((s) => s.id == 'wood_elf');
      notifier.setSubrace(woodElf);
      draft = container.read(characterWizardProvider);
      expect(draft.finalAbilities['DEX'], equals(12));
      expect(draft.finalAbilities['INT'], equals(10));
      expect(draft.finalAbilities['WIS'], equals(11));
      expect(draft.speed, equals(35));

      // Select Sea Elf: CON +1, Speed 30
      final seaElf = elf.subraces.firstWhere((s) => s.id == 'sea_elf');
      notifier.setSubrace(seaElf);
      draft = container.read(characterWizardProvider);
      expect(draft.finalAbilities['DEX'], equals(12));
      expect(draft.finalAbilities['CON'], equals(11));
      expect(draft.finalAbilities['WIS'], equals(10));
      expect(draft.speed, equals(30));
      expect(
        draft.subrace?.traits,
        contains('Child of the Sea (Swim 30ft & Breathe Water)'),
      );

      // Clear subrace back to base
      notifier.setSubrace(null);
      draft = container.read(characterWizardProvider);
      expect(draft.finalAbilities['WIS'], equals(10));
      expect(draft.speed, equals(30));
    });

    test('Tortle sets natural armor class to 17', () {
      final notifier = container.read(characterWizardProvider.notifier);
      final tortle = SrdStarterData.races.firstWhere((r) => r.id == 'tortle');
      notifier.setRace(tortle);

      final draft = container.read(characterWizardProvider);
      expect(draft.armorClass, equals(17));
    });

    test(
      'Saving draft with subrace persists combined race name and traits',
      () async {
        final notifier = container.read(characterWizardProvider.notifier);
        final elf = SrdStarterData.races.firstWhere((r) => r.id == 'elf');
        final woodElf = elf.subraces.firstWhere((s) => s.id == 'wood_elf');
        final fighter = SrdStarterData.classes.firstWhere(
          (c) => c.id == 'fighter',
        );
        final folkHero = SrdStarterData.backgrounds.firstWhere(
          (b) => b.id == 'folk_hero',
        );

        notifier.setName('Legolas');
        notifier.setRace(elf);
        notifier.setSubrace(woodElf);
        notifier.setClass(fighter);
        notifier.setBackground(folkHero);
        notifier.toggleSkill('Athletics');
        notifier.toggleSkill('Perception');

        final charId = await notifier.saveCharacter(db);
        expect(charId, isNotEmpty);

        // Load into CharacterSheetState
        final sheetNotifier = container.read(
          characterSheetProvider(charId).notifier,
        );
        await sheetNotifier.refresh();
        final sheetState = container.read(characterSheetProvider(charId))!;

        expect(sheetState.raceName, equals('Elf (Wood Elf)'));
        expect(sheetState.className, equals('Fighter'));
      },
    );

    test(
      'Saving character with Sea Elf subrace persists combined race name and traits',
      () async {
        final notifier = container.read(characterWizardProvider.notifier);
        final elf = SrdStarterData.races.firstWhere((r) => r.id == 'elf');
        final seaElf = elf.subraces.firstWhere((s) => s.id == 'sea_elf');
        final rogue = SrdStarterData.classes.firstWhere((c) => c.id == 'rogue');
        final acolyte = SrdStarterData.backgrounds.firstWhere(
          (b) => b.id == 'acolyte',
        );

        notifier.setName('Ariel');
        notifier.setRace(elf);
        notifier.setSubrace(seaElf);
        notifier.setClass(rogue);
        notifier.setBackground(acolyte);

        final charId = await notifier.saveCharacter(db);
        expect(charId, isNotEmpty);

        final char = await db.getCharacter(charId);
        expect(char, isNotNull);
        final rawProps =
            jsonDecode(char!.rawPropertiesJson) as Map<String, dynamic>;
        expect(rawProps['race'], equals('Elf (Sea Elf)'));
        expect(rawProps['subraceId'], equals('sea_elf'));
        expect(
          rawProps['traits'],
          containsAll([
            'Darkvision 60ft',
            'Keen Senses',
            'Fey Ancestry (Adv vs Charm)',
            'Child of the Sea (Swim 30ft & Breathe Water)',
            'Friend of the Sea',
            'Cold Resistance',
            'Sea Elf Weapon Training',
          ]),
        );
      },
    );

    testWidgets('Step2Race renders subrace selector when race is selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: Step2Race())),
        ),
      );
      await tester.pumpAndSettle();

      // Find Elf card and tap it
      final elfFinder = find.text('Elf');
      expect(elfFinder, findsOneWidget);
      await tester.tap(elfFinder);
      await tester.pumpAndSettle();

      // Subrace selector should now appear
      expect(find.text('CHOOSE SUBRACE / LINEAGE (OPTIONAL)'), findsOneWidget);
      expect(find.text('Base / Standard'), findsOneWidget);
      expect(find.textContaining('High Elf'), findsOneWidget);
      expect(find.textContaining('Wood Elf'), findsOneWidget);
      expect(find.textContaining('Sea Elf'), findsOneWidget);

      // Tap Wood Elf chip
      await tester.tap(find.textContaining('Wood Elf'));
      await tester.pumpAndSettle();

      final draft = container.read(characterWizardProvider);
      expect(draft.subrace?.id, equals('wood_elf'));
      expect(draft.speed, equals(35));
    });

    testWidgets('Step2Race expands collapsed section to show Tier 2 races', (
      tester,
    ) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: Step2Race())),
        ),
      );
      await tester.pumpAndSettle();

      // Initially, Tabaxi should not be visible because section is collapsed
      expect(find.text('Tabaxi'), findsNothing);

      // Find and tap the Expanded Races header
      final headerFinder = find.text('Expanded Races');
      expect(headerFinder, findsOneWidget);
      await tester.ensureVisible(headerFinder);
      await tester.tap(headerFinder);
      await tester.pumpAndSettle();

      // Now Tabaxi, Genasi, and Tortle should be visible
      expect(find.text('Tabaxi'), findsOneWidget);
      expect(find.text('Tortle'), findsOneWidget);
    });
  });
}

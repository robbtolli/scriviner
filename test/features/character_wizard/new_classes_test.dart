import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/providers/character_sheet_provider.dart';
import 'package:scrivener/features/character_wizard/models/srd_starter_data.dart';
import 'package:scrivener/features/character_wizard/providers/wizard_provider.dart';

void main() {
  group('Bard, Ranger, Sorcerer, Druid Class Verification', () {
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

    test('SRD definitions exist and are properly configured', () {
      final bard = SrdStarterData.classes.firstWhere((c) => c.id == 'bard');
      expect(bard.name, equals('Bard'));
      expect(bard.hitDie, equals(8));
      expect(bard.primaryAbility, equals('CHA'));
      expect(bard.savingThrows, equals(['DEX', 'CHA']));
      expect(bard.skillCount, equals(3));
      expect(bard.isSpellcaster, isTrue);

      final ranger = SrdStarterData.classes.firstWhere((c) => c.id == 'ranger');
      expect(ranger.name, equals('Ranger'));
      expect(ranger.hitDie, equals(10));
      expect(ranger.primaryAbility, equals('DEX'));
      expect(ranger.savingThrows, equals(['STR', 'DEX']));
      expect(ranger.skillCount, equals(3));
      expect(ranger.isSpellcaster, isFalse); // Level 1 half-caster

      final sorcerer = SrdStarterData.classes.firstWhere(
        (c) => c.id == 'sorcerer',
      );
      expect(sorcerer.name, equals('Sorcerer'));
      expect(sorcerer.hitDie, equals(6));
      expect(sorcerer.primaryAbility, equals('CHA'));
      expect(sorcerer.savingThrows, equals(['CON', 'CHA']));
      expect(sorcerer.skillCount, equals(2));
      expect(sorcerer.isSpellcaster, isTrue);

      final druid = SrdStarterData.classes.firstWhere((c) => c.id == 'druid');
      expect(druid.name, equals('Druid'));
      expect(druid.hitDie, equals(8));
      expect(druid.primaryAbility, equals('WIS'));
      expect(druid.savingThrows, equals(['INT', 'WIS']));
      expect(druid.skillCount, equals(2));
      expect(druid.isSpellcaster, isTrue);
    });

    test('Bard character wizard creation and sheet load', () async {
      final notifier = container.read(characterWizardProvider.notifier);
      final human = SrdStarterData.races.firstWhere((r) => r.id == 'human');
      final bard = SrdStarterData.classes.firstWhere((c) => c.id == 'bard');
      final noble = SrdStarterData.backgrounds.firstWhere(
        (b) => b.id == 'noble',
      );

      notifier.setName('Elion the Minstrel');
      notifier.setRace(human);
      notifier.setClass(bard);
      notifier.setBackground(noble);
      notifier.toggleSkill('Performance');
      notifier.toggleSkill('Deception');
      notifier.toggleSkill('Acrobatics');
      notifier.toggleSpell('vicious_mockery');
      notifier.toggleSpell('dissonant_whispers');

      final charId = await notifier.saveCharacter(db);
      expect(charId, isNotEmpty);

      // Read through characterSheetProvider
      final sheetNotifier = container.read(
        characterSheetProvider(charId).notifier,
      );
      await sheetNotifier.refresh();
      final sheetState = container.read(characterSheetProvider(charId))!;

      expect(sheetState.className, equals('Bard'));
      expect(sheetState.spellcastingAbility, equals('cha'));
      expect(sheetState.savingThrowProficiencies, containsAll(['dex', 'cha']));
      // Base CHA 15 + Human 1 = 16 (+3 mod). Prof = 2. Spell DC = 8 + 2 + 3 = 13.
      expect(sheetState.spellSaveDc, equals(13));
      expect(sheetState.spellAttackBonus, equals(5));
      expect(
        sheetState.spells.any((s) => s.name.contains('Vicious Mockery')),
        isTrue,
      );
      expect(
        sheetState.features.any((f) => f.name.contains('Bardic Inspiration')),
        isTrue,
      );
    });

    test('Ranger character wizard creation and sheet load', () async {
      final notifier = container.read(characterWizardProvider.notifier);
      final elf = SrdStarterData.races.firstWhere((r) => r.id == 'elf');
      final ranger = SrdStarterData.classes.firstWhere((c) => c.id == 'ranger');
      final folkHero = SrdStarterData.backgrounds.firstWhere(
        (b) => b.id == 'folk_hero',
      );

      notifier.setName('Strider');
      notifier.setRace(elf);
      notifier.setClass(ranger);
      notifier.setBackground(folkHero);
      notifier.toggleSkill('Stealth');
      notifier.toggleSkill('Perception');
      notifier.toggleSkill('Survival');

      final charId = await notifier.saveCharacter(db);
      expect(charId, isNotEmpty);

      final sheetNotifier = container.read(
        characterSheetProvider(charId).notifier,
      );
      await sheetNotifier.refresh();
      final sheetState = container.read(characterSheetProvider(charId))!;

      expect(sheetState.className, equals('Ranger'));
      expect(sheetState.spellcastingAbility, equals('wis'));
      expect(sheetState.savingThrowProficiencies, containsAll(['str', 'dex']));
      expect(
        sheetState.features.any((f) => f.name.contains('Natural Explorer')),
        isTrue,
      );
      expect(
        sheetState.features.any((f) => f.name.contains('Favored Enemy')),
        isTrue,
      );
    });

    test('Sorcerer character wizard creation and sheet load', () async {
      final notifier = container.read(characterWizardProvider.notifier);
      final tiefling = SrdStarterData.races.firstWhere(
        (r) => r.id == 'tiefling',
      );
      final sorcerer = SrdStarterData.classes.firstWhere(
        (c) => c.id == 'sorcerer',
      );
      final sage = SrdStarterData.backgrounds.firstWhere((b) => b.id == 'sage');

      notifier.setName('Ignis');
      notifier.setRace(tiefling);
      notifier.setClass(sorcerer);
      notifier.setBackground(sage);
      notifier.toggleSkill('Arcana');
      notifier.toggleSkill('Intimidation');
      notifier.toggleSpell('fire_bolt');
      notifier.toggleSpell('shield');

      final charId = await notifier.saveCharacter(db);
      expect(charId, isNotEmpty);

      final sheetNotifier = container.read(
        characterSheetProvider(charId).notifier,
      );
      await sheetNotifier.refresh();
      final sheetState = container.read(characterSheetProvider(charId))!;

      expect(sheetState.className, equals('Sorcerer'));
      expect(sheetState.spellcastingAbility, equals('cha'));
      expect(sheetState.savingThrowProficiencies, containsAll(['con', 'cha']));
      expect(
        sheetState.features.any((f) => f.name.contains('Sorcerous Origin')),
        isTrue,
      );
      expect(
        sheetState.spells.any((s) => s.name.contains('Fire Bolt')),
        isTrue,
      );
    });

    test('Druid character wizard creation and sheet load', () async {
      final notifier = container.read(characterWizardProvider.notifier);
      final human = SrdStarterData.races.firstWhere((r) => r.id == 'human');
      final druid = SrdStarterData.classes.firstWhere((c) => c.id == 'druid');
      final folkHero = SrdStarterData.backgrounds.firstWhere(
        (b) => b.id == 'folk_hero',
      );

      notifier.setName('Rowan');
      notifier.setRace(human);
      notifier.setClass(druid);
      notifier.setBackground(folkHero);
      notifier.toggleSkill('Nature');
      notifier.toggleSkill('Medicine');
      notifier.toggleSpell('druidcraft');
      notifier.toggleSpell('cure_wounds');

      final charId = await notifier.saveCharacter(db);
      expect(charId, isNotEmpty);

      final sheetNotifier = container.read(
        characterSheetProvider(charId).notifier,
      );
      await sheetNotifier.refresh();
      final sheetState = container.read(characterSheetProvider(charId))!;

      expect(sheetState.className, equals('Druid'));
      expect(sheetState.spellcastingAbility, equals('wis'));
      expect(sheetState.savingThrowProficiencies, containsAll(['int', 'wis']));
      expect(
        sheetState.features.any((f) => f.name.contains('Druidic')),
        isTrue,
      );
      expect(
        sheetState.spells.any((s) => s.name.contains('Druidcraft')),
        isTrue,
      );
    });
  });
}

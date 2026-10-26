import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/systems/dnd5e/dnd5e_conditions.dart';
import 'package:scrivener/systems/dnd5e/dnd5e_system.dart';

void main() {
  group('Dnd5eSystem', () {
    const system = Dnd5eSystem();

    test('metadata is correct', () {
      expect(system.systemId, equals('dnd5e'));
      expect(system.name, contains('Dungeons & Dragons'));
      expect(system.version, equals('5.1-SRD'));
    });

    test('calculateProficiencyBonus follows 5e progression curve', () {
      // Level 1-4 -> +2
      expect(system.calculateProficiencyBonus(1), equals(2));
      expect(system.calculateProficiencyBonus(4), equals(2));

      // Level 5-8 -> +3
      expect(system.calculateProficiencyBonus(5), equals(3));
      expect(system.calculateProficiencyBonus(8), equals(3));

      // Level 9-12 -> +4
      expect(system.calculateProficiencyBonus(9), equals(4));
      expect(system.calculateProficiencyBonus(12), equals(4));

      // Level 13-16 -> +5
      expect(system.calculateProficiencyBonus(13), equals(5));
      expect(system.calculateProficiencyBonus(16), equals(5));

      // Level 17-20 -> +6
      expect(system.calculateProficiencyBonus(17), equals(6));
      expect(system.calculateProficiencyBonus(20), equals(6));
    });

    test('calculateAbilityModifier follows floor((score - 10) / 2)', () {
      expect(system.calculateAbilityModifier(1), equals(-5));
      expect(system.calculateAbilityModifier(6), equals(-2));
      expect(system.calculateAbilityModifier(8), equals(-1));
      expect(system.calculateAbilityModifier(9), equals(-1));
      expect(system.calculateAbilityModifier(10), equals(0));
      expect(system.calculateAbilityModifier(11), equals(0));
      expect(system.calculateAbilityModifier(12), equals(1));
      expect(system.calculateAbilityModifier(13), equals(1));
      expect(system.calculateAbilityModifier(14), equals(2));
      expect(system.calculateAbilityModifier(15), equals(2));
      expect(system.calculateAbilityModifier(16), equals(3));
      expect(system.calculateAbilityModifier(18), equals(4));
      expect(system.calculateAbilityModifier(20), equals(5));
    });

    test(
      'resolveCharacterProperties calculates derived stats and formulas',
      () {
        final rawProps = {
          'level': 3,
          'abilities': {
            'str': {'score': 16}, // mod +3
            'dex': {'score': 14}, // mod +2
            'con': {'score': 14}, // mod +2
            'int': {'score': 10}, // mod 0
            'wis': {'score': 12}, // mod +1
            'cha': {'score': 8}, // mod -1
          },
        };

        final resolved = system.resolveCharacterProperties(
          rawProperties: rawProps,
          activeModifiers: [],
        );

        expect(resolved.getInt('attributes.proficiency_bonus'), equals(2));
        expect(resolved.getInt('abilities.str.mod'), equals(3));
        expect(resolved.getInt('abilities.dex.mod'), equals(2));
        expect(resolved.getInt('abilities.wis.mod'), equals(1));
        expect(resolved.getInt('abilities.cha.mod'), equals(-1));

        // AC: 10 + DEX mod (2) = 12
        expect(resolved.getInt('attributes.ac'), equals(12));

        // Initiative: DEX mod (2)
        expect(resolved.getInt('attributes.initiative'), equals(2));

        // Passive Perception: 10 + WIS mod (1) = 11
        expect(resolved.getInt('attributes.passive_perception'), equals(11));
      },
    );

    test(
      'active conditions supply situational bonuses to PropertyPipeline',
      () {
        final rawProps = {
          'level': 1,
          'abilities': {
            'str': {'score': 14},
            'dex': {'score': 10},
          },
        };

        final blessCondition = Dnd5eCondition.all.firstWhere(
          (c) => c.id == 'bless',
        );

        final resolved = system.resolveCharacterProperties(
          rawProperties: rawProps,
          activeModifiers: blessCondition.modifiers,
        );

        final diceBonuses = resolved.getSituationalDice('attacks.melee.bonus');
        expect(diceBonuses, contains('1d4'));
      },
    );
  });
}

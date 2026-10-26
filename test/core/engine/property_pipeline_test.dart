import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/engine/modifier.dart';
import 'package:scrivener/core/engine/property_pipeline.dart';

void main() {
  group('PropertyPipeline', () {
    test('resolves base properties without modifiers', () {
      final base = {'name': 'Gimli', 'level': 5, 'abilities.str.score': 16};

      final state = PropertyPipeline.resolve(
        baseProperties: base,
        modifiers: const [],
      );

      expect(state.getString('name'), equals('Gimli'));
      expect(state.getInt('level'), equals(5));
      expect(state.getInt('abilities.str.score'), equals(16));
    });

    test('applies additive modifiers in priority order', () {
      final base = {'attributes.ac': 10};

      final modifiers = [
        const Modifier(
          id: 'dex_bonus',
          targetProperty: 'attributes.ac',
          operation: ModifierOperation.add,
          value: 3,
          source: 'Dexterity Modifier',
          priority: ModifierPriority.base,
        ),
        const Modifier(
          id: 'shield_bonus',
          targetProperty: 'attributes.ac',
          operation: ModifierOperation.add,
          value: 2,
          source: 'Shield',
          priority: ModifierPriority.equipment,
        ),
      ];

      final state = PropertyPipeline.resolve(
        baseProperties: base,
        modifiers: modifiers,
      );

      expect(state.getInt('attributes.ac'), equals(15));
      expect(state.getModifiersFor('attributes.ac').length, equals(2));
    });

    test('applies override modifiers correctly', () {
      final base = {'abilities.str.score': 12};

      final modifiers = [
        const Modifier(
          id: 'asi_feat',
          targetProperty: 'abilities.str.score',
          operation: ModifierOperation.add,
          value: 2,
          source: 'Ability Score Improvement',
          priority: ModifierPriority.featOrClass, // priority 20
        ),
        const Modifier(
          id: 'belt_of_giant_str',
          targetProperty: 'abilities.str.score',
          operation: ModifierOperation.override,
          value: 21,
          source: 'Belt of Giant Strength',
          priority: ModifierPriority.equipment, // priority 30, overrides!
        ),
      ];

      final state = PropertyPipeline.resolve(
        baseProperties: base,
        modifiers: modifiers,
      );

      expect(state.getInt('abilities.str.score'), equals(21));
    });

    test('resolves formula rules dynamically after modifiers', () {
      final base = {'abilities.str.score': 14, 'proficiency_bonus': 2};

      final modifiers = [
        const Modifier(
          id: 'belt_str',
          targetProperty: 'abilities.str.score',
          operation: ModifierOperation.override,
          value: 20,
          source: 'Belt of Hill Giant Strength',
          priority: ModifierPriority.equipment,
        ),
      ];

      final formulas = {
        // STR mod = floor((20 - 10) / 2) = 5
        'abilities.str.mod': 'floor((@abilities.str.score - 10) / 2)',
        // Melee Attack = STR mod (5) + PB (2) = 7
        'attacks.melee.bonus': '@abilities.str.mod + @proficiency_bonus',
      };

      final state = PropertyPipeline.resolve(
        baseProperties: base,
        modifiers: modifiers,
        formulaRules: formulas,
      );

      expect(state.getInt('abilities.str.score'), equals(20));
      expect(state.getInt('abilities.str.mod'), equals(5));
      expect(state.getInt('attacks.melee.bonus'), equals(7));
    });

    test('collects situational dice bonuses (e.g. Bless)', () {
      final base = {'attacks.melee.bonus': 5};

      final modifiers = [
        const Modifier(
          id: 'bless_spell',
          targetProperty: 'attacks.melee.bonus',
          operation: ModifierOperation.diceBonus,
          value: '1d4',
          source: 'Bless Spell',
          priority: ModifierPriority.activeBuff,
        ),
      ];

      final state = PropertyPipeline.resolve(
        baseProperties: base,
        modifiers: modifiers,
      );

      expect(state.getInt('attacks.melee.bonus'), equals(5));
      expect(state.getSituationalDice('attacks.melee.bonus'), equals(['1d4']));
    });
  });
}

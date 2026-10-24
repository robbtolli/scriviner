import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/systems/dnd5e/dnd5e_rest_manager.dart';

void main() {
  group('Dnd5eRestManager', () {
    test('applyShortRest restores HP and marks spent hit dice', () {
      final initialProps = {
        'hp': {'current': 5, 'max': 20, 'temp': 0},
        'hitDice': {'total': 3, 'spent': 0, 'die': '1d10'},
        'features': {'secondWind': false},
        'spellSlots': {
          'pact': {'total': 2, 'spent': 2},
          '1': {'total': 4, 'spent': 3},
        },
      };

      final updated = Dnd5eRestManager.applyShortRest(
        properties: initialProps,
        hitDiceSpent: 2,
        hitPointsRecovered: 11,
      );

      // Current HP increased from 5 to 16
      expect(updated['hp']['current'], equals(16));
      expect(updated['hp']['max'], equals(20));

      // Hit dice spent increased to 2
      expect(updated['hitDice']['spent'], equals(2));

      // Recharges short-rest features (Second Wind and Pact slots)
      expect(updated['features']['secondWind'], isTrue);
      expect(updated['spellSlots']['pact']['spent'], equals(0));

      // Regular spell slots are NOT restored by short rest
      expect(updated['spellSlots']['1']['spent'], equals(3));
    });

    test('applyShortRest caps HP at maximum HP', () {
      final initialProps = {
        'hp': {'current': 18, 'max': 20},
        'hitDice': {'total': 2, 'spent': 0},
      };

      final updated = Dnd5eRestManager.applyShortRest(
        properties: initialProps,
        hitDiceSpent: 1,
        hitPointsRecovered: 10,
      );

      expect(updated['hp']['current'], equals(20));
      expect(updated['hitDice']['spent'], equals(1));
    });

    test('applyLongRest restores full HP, resets temp HP, recovers half hit dice, and resets all spell slots', () {
      final initialProps = {
        'hp': {'current': 4, 'max': 28, 'temp': 5},
        'hitDice': {'total': 4, 'spent': 3, 'die': '1d10'},
        'deathSaves': {'successes': 2, 'failures': 1},
        'features': {'secondWind': false},
        'spellSlots': {
          '1': {'total': 4, 'spent': 4},
          '2': {'total': 2, 'spent': 2},
        },
      };

      final updated = Dnd5eRestManager.applyLongRest(properties: initialProps);

      // HP is fully restored to max
      expect(updated['hp']['current'], equals(28));
      // Temp HP is cleared
      expect(updated['hp']['temp'], equals(0));

      // Hit dice recovered: total = 4 -> half = 2 recovered. Spent 3 - 2 = 1 spent remaining.
      expect(updated['hitDice']['spent'], equals(1));

      // Death saves reset
      expect(updated['deathSaves']['successes'], equals(0));
      expect(updated['deathSaves']['failures'], equals(0));

      // Features recharged
      expect(updated['features']['secondWind'], isTrue);

      // All spell slots restored (spent = 0)
      expect(updated['spellSlots']['1']['spent'], equals(0));
      expect(updated['spellSlots']['2']['spent'], equals(0));
    });

    test('applyLongRest recovers at least 1 hit die even at level 1', () {
      final initialProps = {
        'hp': {'current': 2, 'max': 12},
        'hitDice': {'total': 1, 'spent': 1, 'die': '1d10'},
      };

      final updated = Dnd5eRestManager.applyLongRest(properties: initialProps);

      // 1 total die -> half is floor(0.5)=0, but minimum is 1 die recovered -> spent = 0
      expect(updated['hitDice']['spent'], equals(0));
    });
  });
}

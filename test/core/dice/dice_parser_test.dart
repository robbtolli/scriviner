import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/dice/dice_parser.dart';
import 'package:scrivener/core/dice/dice_roller.dart';

void main() {
  group('DiceParser', () {
    test('parses simple dice notation', () {
      final parsed = DiceParser.parse('1d20');
      expect(parsed.diceTerms.length, equals(1));
      expect(parsed.diceTerms.first.count, equals(1));
      expect(parsed.diceTerms.first.sides, equals(20));
      expect(parsed.flatTerms, isEmpty);
    });

    test('parses notation without count (e.g. d20)', () {
      final parsed = DiceParser.parse('d20');
      expect(parsed.diceTerms.length, equals(1));
      expect(parsed.diceTerms.first.count, equals(1));
      expect(parsed.diceTerms.first.sides, equals(20));
    });

    test('parses positive and negative flat modifiers', () {
      final parsed = DiceParser.parse('1d20 + 5 - 2');
      expect(parsed.diceTerms.length, equals(1));
      expect(parsed.flatTerms.length, equals(2));
      expect(parsed.flatTerms[0].value, equals(5));
      expect(parsed.flatTerms[1].value, equals(-2));
      expect(parsed.totalFlatModifier, equals(3));
    });

    test('parses keep highest (kh) and drop lowest (dl)', () {
      final kh = DiceParser.parse('4d6kh3');
      expect(kh.diceTerms.first.count, equals(4));
      expect(kh.diceTerms.first.sides, equals(6));
      expect(kh.diceTerms.first.keepHighest, equals(3));

      final dl = DiceParser.parse('4d6dl1');
      expect(dl.diceTerms.first.count, equals(4));
      expect(dl.diceTerms.first.sides, equals(6));
      expect(dl.diceTerms.first.keepHighest, equals(3));
    });

    test('parses advantage and disadvantage shorthands', () {
      final adv = DiceParser.parse('1d20adv + 3');
      expect(adv.diceTerms.first.count, equals(2));
      expect(adv.diceTerms.first.sides, equals(20));
      expect(adv.diceTerms.first.keepHighest, equals(1));
      expect(adv.diceTerms.first.isAdvantage, isTrue);
      expect(adv.totalFlatModifier, equals(3));

      final dis = DiceParser.parse('1d20dis');
      expect(dis.diceTerms.first.count, equals(2));
      expect(dis.diceTerms.first.sides, equals(20));
      expect(dis.diceTerms.first.keepLowest, equals(1));
      expect(dis.diceTerms.first.isDisadvantage, isTrue);
    });

    test('parses complex multi-group formulas', () {
      final parsed = DiceParser.parse('2d8 + 1d4 + 3');
      expect(parsed.diceTerms.length, equals(2));
      expect(parsed.diceTerms[0].count, equals(2));
      expect(parsed.diceTerms[0].sides, equals(8));
      expect(parsed.diceTerms[1].count, equals(1));
      expect(parsed.diceTerms[1].sides, equals(4));
      expect(parsed.totalFlatModifier, equals(3));
    });
  });

  group('DiceRoller', () {
    test('rolls deterministic sequence with seeded random', () {
      final roller = DiceRoller(math.Random(42));
      final result = roller.rollFormula('1d20 + 5');

      expect(result.formula, equals('1d20 + 5'));
      expect(result.groups.length, equals(1));
      expect(result.groups.first.dice.length, equals(1));
      expect(result.modifier, equals(5));
      expect(result.total, equals(result.groups.first.dice.first.value + 5));
    });

    test('properly drops dice with keepHighest', () {
      final roller = DiceRoller(math.Random(123));
      final result = roller.rollFormula('4d6kh3');

      expect(result.groups.first.dice.length, equals(4));
      final kept = result.groups.first.dice.where((d) => !d.isDropped).toList();
      final dropped = result.groups.first.dice.where((d) => d.isDropped).toList();

      expect(kept.length, equals(3));
      expect(dropped.length, equals(1));
      for (final k in kept) {
        expect(k.value, greaterThanOrEqualTo(dropped.first.value));
      }
      expect(result.total, equals(kept.fold<int>(0, (sum, d) => sum + d.value)));
    });

    test('detects critical hit and critical miss on d20', () {
      // Mock deterministic random for 20
      final rollerMockCrit = DiceRoller(_MockRandom([19])); // 0-indexed + 1 = 20
      final critResult = rollerMockCrit.rollFormula('1d20');
      expect(critResult.isCriticalHit, isTrue);
      expect(critResult.isCriticalMiss, isFalse);

      final rollerMockMiss = DiceRoller(_MockRandom([0])); // 0-indexed + 1 = 1
      final missResult = rollerMockMiss.rollFormula('1d20');
      expect(missResult.isCriticalMiss, isTrue);
      expect(critResult.isCriticalHit, isTrue);
    });
  });
}

class _MockRandom implements math.Random {
  final List<int> values;
  int _index = 0;

  _MockRandom(this.values);

  @override
  int nextInt(int max) {
    final val = values[_index % values.length];
    _index++;
    return val;
  }

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0.0;
}

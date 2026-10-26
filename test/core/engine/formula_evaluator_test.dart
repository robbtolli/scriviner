import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/engine/formula_evaluator.dart';

void main() {
  group('FormulaEvaluator', () {
    test('evaluates simple arithmetic without variables', () {
      expect(FormulaEvaluator.evaluate('10 + 5 * 2', {}), equals(20));
      expect(FormulaEvaluator.evaluate('(10 + 5) * 2', {}), equals(30));
    });

    test('evaluates single number string directly', () {
      expect(FormulaEvaluator.evaluate('42', {}), equals(42));
    });

    test('replaces @variable tokens with mapped values', () {
      final props = {'abilities.str.score': 16, 'proficiency_bonus': 3};

      final result = FormulaEvaluator.evaluate(
        'floor((@abilities.str.score - 10) / 2) + @proficiency_bonus',
        props,
      );
      // (16 - 10) / 2 = 3. 3 + 3 = 6.
      expect(result, equals(6));
    });

    test('supports math functions: floor, ceil, round, min, max', () {
      expect(FormulaEvaluator.evaluate('floor(3.7)', {}), equals(3));
      expect(FormulaEvaluator.evaluate('ceil(3.2)', {}), equals(4));
      expect(FormulaEvaluator.evaluate('round(3.5)', {}), equals(4));
      expect(FormulaEvaluator.evaluate('min(10, 5)', {}), equals(5));
      expect(FormulaEvaluator.evaluate('max(10, 5)', {}), equals(10));
    });

    test('extracts variable dependencies correctly', () {
      final deps = FormulaEvaluator.extractDependencies(
        'floor((@abilities.dex.score - 10) / 2) + @attributes.ac_bonus + @shield.bonus',
      );
      expect(
        deps,
        containsAll([
          'abilities.dex.score',
          'attributes.ac_bonus',
          'shield.bonus',
        ]),
      );
      expect(deps.length, equals(3));
    });
  });
}

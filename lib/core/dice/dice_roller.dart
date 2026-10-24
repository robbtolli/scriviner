import 'dart:math' as math;
import 'dice_ast.dart';
import 'dice_parser.dart';

/// Roller service that evaluates [ParsedDiceExpression]s and produces detailed [DiceRollResult]s.
class DiceRoller {
  final math.Random _random;

  DiceRoller([math.Random? random]) : _random = random ?? math.Random();

  /// Rolls a parsed dice expression.
  DiceRollResult roll(
    ParsedDiceExpression expression, {
    int additionalModifier = 0,
  }) {
    final groupResults = <DiceGroupResult>[];
    int diceTotal = 0;
    bool hasCritHit = false;
    bool hasCritMiss = false;

    for (final term in expression.diceTerms) {
      final rolledValues = <int>[];
      for (int i = 0; i < term.count; i++) {
        rolledValues.add(_random.nextInt(term.sides) + 1);
      }

      // Determine which dice are kept vs dropped
      final diceResults = <SingleDieResult>[];
      if (term.keepHighest != null || term.keepLowest != null) {
        // Create indexed list to preserve original roll order
        final indexed = List.generate(
          rolledValues.length,
          (i) => MapEntry(i, rolledValues[i]),
        );

        if (term.keepHighest != null) {
          indexed.sort((a, b) => b.value.compareTo(a.value));
          final keptIndices =
              indexed.take(term.keepHighest!).map((e) => e.key).toSet();
          for (int i = 0; i < rolledValues.length; i++) {
            diceResults.add(SingleDieResult(
              value: rolledValues[i],
              sides: term.sides,
              isDropped: !keptIndices.contains(i),
            ));
          }
        } else if (term.keepLowest != null) {
          indexed.sort((a, b) => a.value.compareTo(b.value));
          final keptIndices =
              indexed.take(term.keepLowest!).map((e) => e.key).toSet();
          for (int i = 0; i < rolledValues.length; i++) {
            diceResults.add(SingleDieResult(
              value: rolledValues[i],
              sides: term.sides,
              isDropped: !keptIndices.contains(i),
            ));
          }
        }
      } else {
        for (final val in rolledValues) {
          diceResults.add(SingleDieResult(
            value: val,
            sides: term.sides,
            isDropped: false,
          ));
        }
      }

      // Calculate subtotal of kept dice
      final keptDice = diceResults.where((d) => !d.isDropped).toList();
      var subtotal = keptDice.fold(0, (sum, d) => sum + d.value);
      if (term.isNegative) {
        subtotal = -subtotal;
      }
      diceTotal += subtotal;

      // Check critical d20 events
      if (term.sides == 20) {
        if (keptDice.any((d) => d.value == 20)) {
          hasCritHit = true;
        }
        if (keptDice.isNotEmpty && keptDice.every((d) => d.value == 1)) {
          hasCritMiss = true;
        }
      }

      groupResults.add(DiceGroupResult(
        term: term,
        dice: diceResults,
        subtotal: subtotal,
      ));
    }

    final totalModifier = expression.totalFlatModifier + additionalModifier;
    final total = diceTotal + totalModifier;

    return DiceRollResult(
      formula: expression.originalFormula,
      total: total,
      groups: groupResults,
      modifier: totalModifier,
      isCriticalHit: hasCritHit,
      isCriticalMiss: hasCritMiss,
    );
  }

  /// Convenience method to parse and roll a formula string directly.
  DiceRollResult rollFormula(
    String formula, {
    int additionalModifier = 0,
  }) {
    final parsed = DiceParser.parse(formula);
    return roll(parsed, additionalModifier: additionalModifier);
  }
}

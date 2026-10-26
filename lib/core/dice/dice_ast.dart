/// A term representing rolling one or more dice with the same number of sides.
class DiceTerm {
  final int count;
  final int sides;
  final int? keepHighest;
  final int? keepLowest;
  final bool isNegative;

  const DiceTerm({
    required this.count,
    required this.sides,
    this.keepHighest,
    this.keepLowest,
    this.isNegative = false,
  });

  bool get isAdvantage => (count == 2 && sides == 20 && keepHighest == 1);

  bool get isDisadvantage => (count == 2 && sides == 20 && keepLowest == 1);

  @override
  String toString() {
    final buffer = StringBuffer();
    if (isNegative) buffer.write('-');
    buffer.write('${count}d$sides');
    if (keepHighest != null) buffer.write('kh$keepHighest');
    if (keepLowest != null) buffer.write('kl$keepLowest');
    return buffer.toString();
  }
}

/// A flat numeric modifier term (e.g., +5 or -2).
class FlatModifierTerm {
  final int value;

  const FlatModifierTerm(this.value);

  @override
  String toString() => value >= 0 ? '+$value' : '$value';
}

/// Parsed representation of a complete dice formula.
class ParsedDiceExpression {
  final String originalFormula;
  final List<DiceTerm> diceTerms;
  final List<FlatModifierTerm> flatTerms;

  const ParsedDiceExpression({
    required this.originalFormula,
    required this.diceTerms,
    required this.flatTerms,
  });

  int get totalFlatModifier =>
      flatTerms.fold(0, (sum, term) => sum + term.value);
}

/// Result of rolling a single physical die.
class SingleDieResult {
  final int value;
  final int sides;
  final bool isDropped;

  const SingleDieResult({
    required this.value,
    required this.sides,
    this.isDropped = false,
  });

  SingleDieResult copyWith({bool? isDropped}) {
    return SingleDieResult(
      value: value,
      sides: sides,
      isDropped: isDropped ?? this.isDropped,
    );
  }

  @override
  String toString() => isDropped ? '($value)' : '$value';
}

/// Result of rolling a group of dice described by a [DiceTerm].
class DiceGroupResult {
  final DiceTerm term;
  final List<SingleDieResult> dice;
  final int subtotal;

  const DiceGroupResult({
    required this.term,
    required this.dice,
    required this.subtotal,
  });
}

/// Final comprehensive result of rolling a dice formula.
class DiceRollResult {
  final String formula;
  final int total;
  final List<DiceGroupResult> groups;
  final int modifier;
  final bool isCriticalHit;
  final bool isCriticalMiss;

  const DiceRollResult({
    required this.formula,
    required this.total,
    required this.groups,
    required this.modifier,
    this.isCriticalHit = false,
    this.isCriticalMiss = false,
  });

  @override
  String toString() {
    final details = groups
        .map((g) {
          final rolls = g.dice.map((d) => d.toString()).join(', ');
          return '[${g.term}: $rolls]';
        })
        .join(' + ');

    final modStr = modifier != 0
        ? (modifier > 0 ? ' + $modifier' : ' - ${modifier.abs()}')
        : '';
    return '$formula -> $details$modStr = $total';
  }
}

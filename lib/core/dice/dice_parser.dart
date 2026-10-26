import 'dice_ast.dart';

/// Parses dice notation strings into structured [ParsedDiceExpression]s.
class DiceParser {
  static final _termRegex = RegExp(
    r'([+-]?)\s*(?:(\d*)d(\d+)(?:(kh|kl|dh|dl)(\d+))?|(\d+))',
    caseSensitive: false,
  );

  /// Parses a formula such as `1d20+5`, `4d6kh3`, `1d20adv`, or `2d8 + 1d4 - 2`.
  static ParsedDiceExpression parse(String formula) {
    if (formula.trim().isEmpty) {
      return ParsedDiceExpression(
        originalFormula: formula,
        diceTerms: const [],
        flatTerms: const [],
      );
    }

    // Preprocess shorthand expressions
    var cleaned = formula
        .replaceAll(
          RegExp(r'\b(?:1)?d20\s*adv(?:antage)?\b', caseSensitive: false),
          '2d20kh1',
        )
        .replaceAll(
          RegExp(r'\b(?:1)?d20\s*dis(?:advantage)?\b', caseSensitive: false),
          '2d20kl1',
        );

    final diceTerms = <DiceTerm>[];
    final flatTerms = <FlatModifierTerm>[];

    final matches = _termRegex.allMatches(cleaned);
    for (final match in matches) {
      final sign = match.group(1) == '-' ? -1 : 1;
      final countStr = match.group(2);
      final sidesStr = match.group(3);
      final keepDropOp = match.group(4)?.toLowerCase();
      final keepDropCountStr = match.group(5);
      final flatValStr = match.group(6);

      if (sidesStr != null) {
        final count = (countStr == null || countStr.isEmpty)
            ? 1
            : int.parse(countStr);
        final sides = int.parse(sidesStr);
        int? keepHighest;
        int? keepLowest;

        if (keepDropOp != null && keepDropCountStr != null) {
          final kdCount = int.parse(keepDropCountStr);
          if (keepDropOp == 'kh') {
            keepHighest = kdCount.clamp(1, count);
          } else if (keepDropOp == 'kl') {
            keepLowest = kdCount.clamp(1, count);
          } else if (keepDropOp == 'dl') {
            keepHighest = (count - kdCount).clamp(1, count);
          } else if (keepDropOp == 'dh') {
            keepLowest = (count - kdCount).clamp(1, count);
          }
        }

        diceTerms.add(
          DiceTerm(
            count: count,
            sides: sides,
            keepHighest: keepHighest,
            keepLowest: keepLowest,
            isNegative: sign < 0,
          ),
        );
      } else if (flatValStr != null) {
        final val = int.parse(flatValStr) * sign;
        flatTerms.add(FlatModifierTerm(val));
      }
    }

    return ParsedDiceExpression(
      originalFormula: formula,
      diceTerms: diceTerms,
      flatTerms: flatTerms,
    );
  }
}

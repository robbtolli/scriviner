import 'dice_ast.dart';

/// Parses dice notation strings into structured [ParsedDiceExpression]s.
class DiceParser {
  /// Standard polyhedral dice sides supported by the roller and 3D stage.
  static const Set<int> validSides = {4, 6, 8, 10, 12, 20, 100};

  static final _termRegex = RegExp(
    r'([+-]?)\s*(?:(\d*)d(\d+)(?:(kh|kl|dh|dl)(\d+))?|(\d+))',
    caseSensitive: false,
  );

  /// Returns true if [formula] is a syntactically and semantically valid
  /// dice expression that can be rolled.
  static bool isValid(String formula) {
    final trimmed = formula.trim();
    if (trimmed.isEmpty) return false;

    final cleaned = _preprocessShorthands(trimmed);
    final matches = _termRegex.allMatches(cleaned).toList();
    if (matches.isEmpty) return false;

    var cursor = 0;
    for (var i = 0; i < matches.length; i++) {
      final match = matches[i];
      // Ensure no unrecognized characters between terms
      if (cleaned.substring(cursor, match.start).trim().isNotEmpty) {
        return false;
      }
      cursor = match.end;

      final signStr = match.group(1) ?? '';
      // Every term after the first must have an explicit '+' or '-' separator
      if (i > 0 && signStr.isEmpty) {
        return false;
      }

      final countStr = match.group(2);
      final sidesStr = match.group(3);
      final keepDropOp = match.group(4)?.toLowerCase();
      final keepDropCountStr = match.group(5);
      final flatValStr = match.group(6);

      if (sidesStr != null) {
        final count = (countStr == null || countStr.isEmpty)
            ? 1
            : int.tryParse(countStr);
        final sides = int.tryParse(sidesStr);
        if (count == null || count < 1 || count > 999) return false;
        if (sides == null || !validSides.contains(sides)) return false;

        if (keepDropOp != null) {
          if (keepDropCountStr == null) return false;
          final kdCount = int.tryParse(keepDropCountStr);
          if (kdCount == null || kdCount < 1) return false;
          if (keepDropOp == 'kh' || keepDropOp == 'kl') {
            if (kdCount > count) return false;
          } else if (keepDropOp == 'dl' || keepDropOp == 'dh') {
            if (kdCount >= count) return false;
          }
        }
      } else if (flatValStr != null) {
        final val = int.tryParse(flatValStr);
        if (val == null) return false;
      } else {
        return false;
      }
    }

    // Ensure no trailing operators or garbage after the last matched term
    if (cleaned.substring(cursor).trim().isNotEmpty) {
      return false;
    }

    return true;
  }

  static String _preprocessShorthands(String formula) {
    return formula
        .replaceAll(
          RegExp(r'\b(?:1)?d20\s*adv(?:antage)?\b', caseSensitive: false),
          '2d20kh1',
        )
        .replaceAll(
          RegExp(r'\b(?:1)?d20\s*dis(?:advantage)?\b', caseSensitive: false),
          '2d20kl1',
        );
  }

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
    final cleaned = _preprocessShorthands(formula);

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

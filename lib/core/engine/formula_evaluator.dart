import 'dart:math' as math;
import 'package:expressions/expressions.dart';

/// Sandboxed mathematical and formula evaluation engine for RPG system properties.
class FormulaEvaluator {
  static final RegExp _varPattern = RegExp(r'@([a-zA-Z0-9_\.]+)');

  /// Evaluates a formula string (e.g. `floor((@abilities.str.score - 10) / 2) + @pb`)
  /// against a map of property keys and values.
  static num evaluate(String formula, Map<String, dynamic> propertyValues) {
    if (formula.trim().isEmpty) return 0;

    // Fast-path: If formula is just a plain number
    final directNum = num.tryParse(formula.trim());
    if (directNum != null) return directNum;

    var sanitizedFormula = formula;
    final context = <String, dynamic>{
      'floor': (num n) => n.floor(),
      'ceil': (num n) => n.ceil(),
      'round': (num n) => n.round(),
      'abs': (num n) => n.abs(),
      'sqrt': (num n) => math.sqrt(n),
      'pow': (num x, num exponent) => math.pow(x, exponent),
      'min': (num a, num b) => math.min(a, b),
      'max': (num a, num b) => math.max(a, b),
    };

    final matches = _varPattern.allMatches(formula);
    int varIndex = 0;
    final replacedMap = <String, String>{};

    for (final match in matches) {
      final fullMatch = match.group(0)!;
      final propPath = match.group(1)!;

      if (!replacedMap.containsKey(fullMatch)) {
        final varName = 'v$varIndex';
        varIndex++;
        replacedMap[fullMatch] = varName;

        final rawVal = propertyValues[propPath];
        final num val;
        if (rawVal is num) {
          val = rawVal;
        } else if (rawVal is String) {
          val = num.tryParse(rawVal) ?? 0;
        } else {
          val = 0;
        }
        context[varName] = val;
      }
    }

    replacedMap.forEach((token, varName) {
      sanitizedFormula = sanitizedFormula.replaceAll(token, varName);
    });

    try {
      final expr = Expression.parse(sanitizedFormula);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expr, context);
      if (result is num) {
        return result;
      }
      throw FormatException(
        'Formula "$formula" did not evaluate to a number. Got: $result',
      );
    } catch (e) {
      throw FormatException('Failed to evaluate formula "$formula": $e');
    }
  }

  /// Extracts all `@property.path` dependencies referenced in a formula.
  static Set<String> extractDependencies(String formula) {
    final matches = _varPattern.allMatches(formula);
    return matches.map((m) => m.group(1)!).toSet();
  }
}

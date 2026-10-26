import '../../../core/dice/dice_ast.dart';

enum RollType { normal, advantage, disadvantage }

/// Represents an individual resolved roll saved in the session history log.
class DiceRollRecord {
  final String id;
  final String context;
  final String formula;
  final int total;
  final int modifier;
  final List<DiceGroupResult> groups;
  final bool isCriticalHit;
  final bool isCriticalMiss;
  final RollType rollType;
  final DateTime timestamp;

  const DiceRollRecord({
    required this.id,
    required this.context,
    required this.formula,
    required this.total,
    required this.modifier,
    required this.groups,
    this.isCriticalHit = false,
    this.isCriticalMiss = false,
    this.rollType = RollType.normal,
    required this.timestamp,
  });

  /// Formatted breakdown string, e.g. `[18, 4] + 3 = 25`
  String get formattedBreakdown {
    final parts = <String>[];
    for (final group in groups) {
      final diceStrs = group.dice
          .map((d) {
            if (d.isDropped) {
              return '(${d.value} dropped)';
            }
            return '${d.value}';
          })
          .join(', ');
      parts.add('[$diceStrs]');
    }

    if (modifier != 0) {
      final sign = modifier > 0 ? '+' : '-';
      parts.add('$sign ${modifier.abs()}');
    }

    return '${parts.join(' ')} = $total';
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/dice/dice_roller.dart';
import '../models/dice_roll_record.dart';

class SituationalBonus {
  final String id;
  final String label;
  final String diceFormula; // e.g. "1d4"
  final int flatModifier;   // e.g. 2 for "+2 Cover"

  const SituationalBonus({
    required this.id,
    required this.label,
    this.diceFormula = '',
    this.flatModifier = 0,
  });

  static const List<SituationalBonus> defaultPresets = [
    SituationalBonus(id: 'bless', label: '+1d4 Bless', diceFormula: '1d4'),
    SituationalBonus(id: 'guidance', label: '+1d4 Guidance', diceFormula: '1d4'),
    SituationalBonus(id: 'inspiration', label: '+1d6 Inspiration', diceFormula: '1d6'),
    SituationalBonus(id: 'cover2', label: '+2 Cover', flatModifier: 2),
    SituationalBonus(id: 'coverMinus2', label: '-2 Cover', flatModifier: -2),
  ];
}

class DiceDrawerState {
  final String contextTitle;
  final Map<int, int> diceCounts; // sides -> count, e.g. {20: 1, 6: 2}
  final int flatModifier;
  final RollType rollType;
  final Set<String> activeBonusIds;
  final List<DiceRollRecord> history;

  const DiceDrawerState({
    this.contextTitle = 'Quick Roll',
    this.diceCounts = const {20: 1},
    this.flatModifier = 0,
    this.rollType = RollType.normal,
    this.activeBonusIds = const {},
    this.history = const [],
  });

  /// Computes the complete readable formula string.
  String get formula {
    final terms = <String>[];

    // 1. Polyhedral dice
    final sortedSides = diceCounts.keys.toList()..sort((a, b) => b.compareTo(a));
    for (final sides in sortedSides) {
      final count = diceCounts[sides] ?? 0;
      if (count <= 0) continue;

      if (sides == 20) {
        if (rollType == RollType.advantage) {
          terms.add('2d20kh1');
        } else if (rollType == RollType.disadvantage) {
          terms.add('2d20kl1');
        } else {
          terms.add('${count}d20');
        }
      } else {
        terms.add('${count}d$sides');
      }
    }

    // 2. Situational dice bonuses
    for (final id in activeBonusIds) {
      final preset = SituationalBonus.defaultPresets.firstWhere(
        (b) => b.id == id,
        orElse: () => SituationalBonus(id: id, label: id),
      );
      if (preset.diceFormula.isNotEmpty) {
        terms.add(preset.diceFormula);
      }
    }

    // 3. Flat modifiers
    int totalFlat = flatModifier;
    for (final id in activeBonusIds) {
      final preset = SituationalBonus.defaultPresets.firstWhere(
        (b) => b.id == id,
        orElse: () => SituationalBonus(id: id, label: id),
      );
      totalFlat += preset.flatModifier;
    }

    if (terms.isEmpty) {
      if (totalFlat != 0) return '$totalFlat';
      return '1d20';
    }

    var result = terms.join(' + ');
    if (totalFlat > 0) {
      result += ' + $totalFlat';
    } else if (totalFlat < 0) {
      result += ' - ${totalFlat.abs()}';
    }

    return result;
  }

  DiceDrawerState copyWith({
    String? contextTitle,
    Map<int, int>? diceCounts,
    int? flatModifier,
    RollType? rollType,
    Set<String>? activeBonusIds,
    List<DiceRollRecord>? history,
  }) {
    return DiceDrawerState(
      contextTitle: contextTitle ?? this.contextTitle,
      diceCounts: diceCounts ?? this.diceCounts,
      flatModifier: flatModifier ?? this.flatModifier,
      rollType: rollType ?? this.rollType,
      activeBonusIds: activeBonusIds ?? this.activeBonusIds,
      history: history ?? this.history,
    );
  }
}

class DiceDrawerNotifier extends Notifier<DiceDrawerState> {
  late DiceRoller _roller;

  @override
  DiceDrawerState build() {
    _roller = DiceRoller();
    return const DiceDrawerState();
  }

  void setDiceRoller(DiceRoller roller) {
    _roller = roller;
  }

  void addDie(int sides) {
    final updated = Map<int, int>.from(state.diceCounts);
    updated[sides] = (updated[sides] ?? 0) + 1;
    state = state.copyWith(diceCounts: updated);
  }

  void removeDie(int sides) {
    final updated = Map<int, int>.from(state.diceCounts);
    final current = updated[sides] ?? 0;
    if (current <= 1) {
      updated.remove(sides);
    } else {
      updated[sides] = current - 1;
    }
    state = state.copyWith(diceCounts: updated);
  }

  void clearDice() {
    state = state.copyWith(
      diceCounts: {},
      flatModifier: 0,
      activeBonusIds: {},
      rollType: RollType.normal,
      contextTitle: 'Quick Roll',
    );
  }

  void resetDrawer() => clearDice();

  void setDiceCount(int sides, int count) {
    final updated = Map<int, int>.from(state.diceCounts);
    if (count <= 0) {
      updated.remove(sides);
    } else {
      updated[sides] = count;
    }
    state = state.copyWith(diceCounts: updated);
  }

  void setRollTitle(String title) {
    state = state.copyWith(contextTitle: title);
  }

  void setFlatModifier(int mod) {
    state = state.copyWith(flatModifier: mod);
  }

  void adjustFlatModifier(int delta) {
    state = state.copyWith(flatModifier: state.flatModifier + delta);
  }

  void setRollType(RollType type) {
    state = state.copyWith(rollType: type);
  }

  void toggleSituationalBonus(String bonusId) {
    final updated = Set<String>.from(state.activeBonusIds);
    if (updated.contains(bonusId)) {
      updated.remove(bonusId);
    } else {
      updated.add(bonusId);
    }
    state = state.copyWith(activeBonusIds: updated);
  }

  /// Sets context from character sheet action (e.g. Weapon attack or Ability Check)
  void setContext({
    required String title,
    Map<int, int>? diceCounts,
    int flatModifier = 0,
    RollType rollType = RollType.normal,
  }) {
    state = state.copyWith(
      contextTitle: title,
      diceCounts: diceCounts ?? {20: 1},
      flatModifier: flatModifier,
      rollType: rollType,
      activeBonusIds: {},
    );
  }

  /// Executes the roll using DiceRoller and saves it to history.
  DiceRollRecord roll() {
    final formulaToRoll = state.formula;
    final result = _roller.rollFormula(formulaToRoll);

    final record = DiceRollRecord(
      id: const Uuid().v4(),
      context: state.contextTitle,
      formula: formulaToRoll,
      total: result.total,
      modifier: result.modifier,
      groups: result.groups,
      isCriticalHit: result.isCriticalHit,
      isCriticalMiss: result.isCriticalMiss,
      rollType: state.rollType,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      history: [record, ...state.history],
    );

    return record;
  }

  /// Re-populates the drawer with the exact formula and context of a past roll.
  void loadFromRecord(DiceRollRecord record) {
    // Replaces context and runs
    state = state.copyWith(
      contextTitle: record.context,
      rollType: record.rollType,
    );
  }

  void clearHistory() {
    state = state.copyWith(history: []);
  }
}

final diceDrawerProvider =
    NotifierProvider<DiceDrawerNotifier, DiceDrawerState>(
  DiceDrawerNotifier.new,
);

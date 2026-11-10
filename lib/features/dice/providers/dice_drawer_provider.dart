import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/dice/dice_ast.dart';
import '../../../core/dice/dice_parser.dart';
import '../../../core/dice/dice_roller.dart';
import '../models/dice_roll_record.dart';

class SituationalBonus {
  final String id;
  final String label;
  final String diceFormula; // e.g. "1d4"
  final int flatModifier; // e.g. 2 for "+2 Cover"

  const SituationalBonus({
    required this.id,
    required this.label,
    this.diceFormula = '',
    this.flatModifier = 0,
  });

  static const List<SituationalBonus> defaultPresets = [
    SituationalBonus(id: 'bless', label: '+1d4 Bless', diceFormula: '1d4'),
    SituationalBonus(
      id: 'guidance',
      label: '+1d4 Guidance',
      diceFormula: '1d4',
    ),
    SituationalBonus(
      id: 'inspiration',
      label: '+1d6 Inspiration',
      diceFormula: '1d6',
    ),
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

  /// Optional manually-typed formula string when the user edits the formula box.
  final String? customFormula;

  /// Most recent roll, shown by the animated dice stage.
  final DiceRollRecord? lastRoll;

  /// Incremented on every roll so the UI can restart its animation even when
  /// the result is identical to the previous one.
  final int rollSerial;

  const DiceDrawerState({
    this.contextTitle = 'Quick Roll',
    this.diceCounts = const {},
    this.flatModifier = 0,
    this.rollType = RollType.normal,
    this.activeBonusIds = const {},
    this.history = const [],
    this.customFormula,
    this.lastRoll,
    this.rollSerial = 0,
  });

  /// True if no dice or modifiers are in the formula.
  bool get isFormulaEmpty => formula.trim().isEmpty;

  /// True if the formula has at least one character/term.
  bool get hasFormula => formula.trim().isNotEmpty;

  /// True if the current formula is non-empty and passes [DiceParser.isValid].
  bool get isFormulaValid =>
      formula.trim().isNotEmpty && DiceParser.isValid(formula);

  /// True if the user has typed a non-empty formula that is invalid.
  bool get hasInvalidFormula =>
      formula.trim().isNotEmpty && !DiceParser.isValid(formula);

  /// Parsed dice terms for the current formula, used to render the unrolled
  /// blank-face dice preview in the stage before rolling.
  List<DiceTerm> get previewDiceTerms {
    if (!isFormulaValid) return const [];
    return DiceParser.parse(formula).diceTerms;
  }

  /// True if there is at least one d20 die in the formula.
  bool get hasD20 {
    if (customFormula != null) {
      if (!isFormulaValid) return false;
      return DiceParser.parse(formula).diceTerms.any((t) => t.sides == 20);
    }
    return (diceCounts[20] ?? 0) > 0;
  }

  /// Computes the complete readable formula string.
  String get formula {
    if (customFormula != null) {
      return customFormula!;
    }
    return _structuredFormula;
  }

  String get _structuredFormula {
    final terms = <String>[];

    // 1. Polyhedral dice
    final sortedSides = diceCounts.keys.toList()
      ..sort((a, b) => b.compareTo(a));
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
      if (totalFlat > 0) return '+$totalFlat';
      if (totalFlat < 0) return '$totalFlat';
      return '';
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
    String? customFormula,
    bool clearCustomFormula = false,
    DiceRollRecord? lastRoll,
    bool clearLastRoll = false,
    int? rollSerial,
  }) {
    return DiceDrawerState(
      contextTitle: contextTitle ?? this.contextTitle,
      diceCounts: diceCounts ?? this.diceCounts,
      flatModifier: flatModifier ?? this.flatModifier,
      rollType: rollType ?? this.rollType,
      activeBonusIds: activeBonusIds ?? this.activeBonusIds,
      history: history ?? this.history,
      customFormula: clearCustomFormula
          ? null
          : (customFormula ?? this.customFormula),
      lastRoll: clearLastRoll ? null : (lastRoll ?? this.lastRoll),
      rollSerial: rollSerial ?? this.rollSerial,
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

  /// Updates the formula from user text input in the editable formula box.
  /// If the text is a valid dice formula, syncs [diceCounts], [flatModifier],
  /// and [rollType] so the polyhedral dice buttons reflect the typed formula.
  void setCustomFormula(String text) {
    if (text.trim().isEmpty) {
      state = state.copyWith(
        diceCounts: {},
        flatModifier: 0,
        activeBonusIds: {},
        rollType: RollType.normal,
        clearCustomFormula: true,
        clearLastRoll: true,
      );
      return;
    }

    if (DiceParser.isValid(text)) {
      final parsed = DiceParser.parse(text);
      final syncedCounts = <int, int>{};
      var syncedRollType = RollType.normal;

      for (final term in parsed.diceTerms) {
        if (!term.isNegative) {
          if (term.isAdvantage) {
            syncedRollType = RollType.advantage;
            syncedCounts[20] = (syncedCounts[20] ?? 0) + 1;
          } else if (term.isDisadvantage) {
            syncedRollType = RollType.disadvantage;
            syncedCounts[20] = (syncedCounts[20] ?? 0) + 1;
          } else {
            syncedCounts[term.sides] =
                (syncedCounts[term.sides] ?? 0) + term.count;
          }
        }
      }

      state = state.copyWith(
        customFormula: text,
        diceCounts: syncedCounts,
        flatModifier: parsed.totalFlatModifier,
        rollType: syncedRollType,
        activeBonusIds: {},
        clearLastRoll: true,
      );
    } else {
      state = state.copyWith(customFormula: text, clearLastRoll: true);
    }
  }

  void addDie(int sides) {
    final updated = Map<int, int>.from(state.diceCounts);
    updated[sides] = (updated[sides] ?? 0) + 1;
    state = state.copyWith(
      diceCounts: updated,
      clearCustomFormula: true,
      clearLastRoll: true,
    );
  }

  void removeDie(int sides) {
    final updated = Map<int, int>.from(state.diceCounts);
    final current = updated[sides] ?? 0;
    if (current <= 1) {
      updated.remove(sides);
    } else {
      updated[sides] = current - 1;
    }
    state = state.copyWith(
      diceCounts: updated,
      rollType: (sides == 20 && !updated.containsKey(20))
          ? RollType.normal
          : null,
      clearCustomFormula: true,
      clearLastRoll: true,
    );
  }

  /// Removes all dice of [sides] from the formula at once.
  void clearDieType(int sides) {
    final updated = Map<int, int>.from(state.diceCounts);
    if (!updated.containsKey(sides)) return;
    updated.remove(sides);
    state = state.copyWith(
      diceCounts: updated,
      rollType: sides == 20 ? RollType.normal : null,
      clearCustomFormula: true,
      clearLastRoll: true,
    );
  }

  void clearDice() {
    state = state.copyWith(
      diceCounts: {},
      flatModifier: 0,
      activeBonusIds: {},
      rollType: RollType.normal,
      contextTitle: 'Quick Roll',
      clearCustomFormula: true,
      clearLastRoll: true,
    );
  }

  void resetDrawer() => clearDice();

  /// Resets context to a neutral 'Quick Roll' for independent rolling.
  /// Guarantees that rolling will not be associated with or modify character attributes.
  void setQuickRoll() {
    state = state.copyWith(
      contextTitle: 'Quick Roll',
      rollType: RollType.normal,
      activeBonusIds: {},
    );
  }

  void setDiceCount(int sides, int count) {
    final updated = Map<int, int>.from(state.diceCounts);
    if (count <= 0) {
      updated.remove(sides);
    } else {
      updated[sides] = count;
    }
    state = state.copyWith(
      diceCounts: updated,
      clearCustomFormula: true,
      clearLastRoll: true,
    );
  }

  void setRollTitle(String title) {
    state = state.copyWith(contextTitle: title);
  }

  void setFlatModifier(int mod) {
    state = state.copyWith(
      flatModifier: mod,
      clearCustomFormula: true,
      clearLastRoll: true,
    );
  }

  void adjustFlatModifier(int delta) {
    state = state.copyWith(
      flatModifier: state.flatModifier + delta,
      clearCustomFormula: true,
      clearLastRoll: true,
    );
  }

  void setRollType(RollType type) {
    if (!state.hasD20 && type != RollType.normal) return;
    state = state.copyWith(
      rollType: type,
      clearCustomFormula: true,
      clearLastRoll: true,
    );
  }

  void toggleSituationalBonus(String bonusId) {
    final updated = Set<String>.from(state.activeBonusIds);
    if (updated.contains(bonusId)) {
      updated.remove(bonusId);
    } else {
      updated.add(bonusId);
    }
    state = state.copyWith(
      activeBonusIds: updated,
      clearCustomFormula: true,
      clearLastRoll: true,
    );
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
      diceCounts: diceCounts ?? {},
      flatModifier: flatModifier,
      rollType: rollType,
      activeBonusIds: {},
      clearCustomFormula: true,
      clearLastRoll: true,
    );
  }

  /// Executes the roll using DiceRoller and saves it to history.
  DiceRollRecord roll() {
    final formulaToRoll = state.formula.isEmpty ? '1d20' : state.formula;
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
      lastRoll: record,
      rollSerial: state.rollSerial + 1,
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

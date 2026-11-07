/// How much of the roll the stage can show legibly.
enum DiceDisplayMode {
  /// Dice tumble and the rolled number appears on each landing face.
  numbered,

  /// Dice tumble but are too small for numbers; only the total is shown.
  blank,

  /// Too many dice to show individually; only the total is shown.
  totalOnly,
}

/// Chooses die size and display mode from the number of dice in a roll.
class DiceStageLayout {
  final DiceDisplayMode mode;

  /// Edge length in logical pixels of each die sprite (0 for [DiceDisplayMode.totalOnly]).
  final double dieSize;

  const DiceStageLayout(this.mode, this.dieSize);

  /// Largest roll shown as individual dice.
  static const int maxDice = 40;

  /// Largest roll whose dice are big enough for numbers on the faces.
  static const int maxNumberedDice = 12;

  /// (max dice, layout) tiers, checked in order.
  static const List<(int, DiceStageLayout)> _tiers = [
    (4, DiceStageLayout(DiceDisplayMode.numbered, 96)),
    (8, DiceStageLayout(DiceDisplayMode.numbered, 80)),
    (maxNumberedDice, DiceStageLayout(DiceDisplayMode.numbered, 64)),
    (20, DiceStageLayout(DiceDisplayMode.blank, 48)),
    (maxDice, DiceStageLayout(DiceDisplayMode.blank, 32)),
  ];

  factory DiceStageLayout.forCount(int count) {
    for (final (max, layout) in _tiers) {
      if (count <= max) return layout;
    }
    return const DiceStageLayout(DiceDisplayMode.totalOnly, 0);
  }
}

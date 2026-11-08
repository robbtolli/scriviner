import 'package:flutter/material.dart';

import '../dice_roller_drawer.dart';
import '../dice_roller_screen.dart';

class FloatingDiceFab extends StatelessWidget {
  const FloatingDiceFab({super.key});

  /// Opens the dice roller as a modal bottom sheet (used on the character screen).
  static void openDiceRoller(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollController) =>
            const DiceRollerDrawer(isBottomSheet: true),
      ),
    );
  }

  /// Opens the full-screen dice roller (used on the home screen and Android widget).
  static void openFullScreenDiceRoller(BuildContext context) {
    DiceRollerScreen.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: () => openDiceRoller(context),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 4,
      tooltip: 'Roll Dice (d4 - d100)',
      child: const Icon(Icons.casino, size: 26),
    );
  }
}

import 'package:flutter/material.dart';

import '../dice_roller_drawer.dart';

class FloatingDiceFab extends StatelessWidget {
  const FloatingDiceFab({super.key});

  static void openDiceRoller(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final scaffold = Scaffold.maybeOf(context);

    if (width >= 700 && scaffold != null && scaffold.hasEndDrawer) {
      scaffold.openEndDrawer();
    } else {
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

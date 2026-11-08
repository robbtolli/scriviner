import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dice_drawer_provider.dart';
import 'dice_roller_drawer.dart';

/// Full-screen screen for the polyhedral dice roller.
class DiceRollerScreen extends ConsumerWidget {
  const DiceRollerScreen({super.key});

  /// Navigates to the full screen dice roller.
  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const DiceRollerScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(diceDrawerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.casino, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              'DICE ROLLER',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.2,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => notifier.clearDice(),
            icon: const Icon(Icons.restart_alt, size: 16),
            label: const Text('Reset', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: const SafeArea(child: DiceRollerDrawer(isFullScreen: true)),
    );
  }
}

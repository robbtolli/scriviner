import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_selector_dialog.dart';
import 'dice_roller_drawer.dart';
import 'widgets/about_dice_caster_dialog.dart';

/// Full-screen home for the standalone Dice Caster application.
class DiceStandaloneScreen extends ConsumerWidget {
  const DiceStandaloneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.casino, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              'DICE CASTER',
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
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Select Theme',
            onPressed: () => ThemeSelectorDialog.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About Dice Caster',
            onPressed: () => AboutDiceCasterDialog.show(context),
          ),
        ],
      ),
      body: const SafeArea(child: DiceRollerDrawer(isFullScreen: true)),
    );
  }
}

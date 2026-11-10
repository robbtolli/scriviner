import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dice_roll_record.dart';
import '../providers/dice_drawer_provider.dart';
import 'dice3d/baked_die.dart';
import 'dice3d/dice_sprite_atlas.dart';
import 'widgets/polyhedral_dice_tray.dart';
import 'widgets/roll_history_list.dart';
import 'widgets/rolling_dice_stage.dart';
import 'widgets/situational_chips_row.dart';

class DiceRollerDrawer extends ConsumerWidget {
  final bool isBottomSheet;
  final bool isFullScreen;

  const DiceRollerDrawer({
    super.key,
    this.isBottomSheet = false,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(diceDrawerProvider);
    final notifier = ref.read(diceDrawerProvider.notifier);

    final content = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          if (!isFullScreen)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.casino,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
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
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => notifier.clearDice(),
                      icon: const Icon(Icons.restart_alt, size: 14),
                      label: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    if (isBottomSheet || Navigator.of(context).canPop())
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                  ],
                ),
              ],
            ),

          // Context Badge
          if (state.contextTitle != 'Quick Roll')
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(80),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_outline,
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      state.contextTitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),

          // Formula Display & Roll Button Row
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Formula Display Box
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: state.hasFormula
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                        width: 1.5,
                      ),
                      boxShadow: state.hasFormula
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withAlpha(25),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'FORMULA',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    140,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                state.formula.isEmpty
                                    ? 'Select dice'
                                    : state.formula,
                                style: TextStyle(
                                  fontSize: state.formula.isEmpty ? 16 : 20,
                                  fontStyle: state.formula.isEmpty
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                  fontWeight: state.formula.isEmpty
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color: state.formula.isEmpty
                                      ? theme.colorScheme.onSurface.withAlpha(
                                          120,
                                        )
                                      : theme.colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (state.rollType != RollType.normal)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: state.rollType == RollType.advantage
                                  ? Colors.green.withAlpha(40)
                                  : Colors.red.withAlpha(40),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: state.rollType == RollType.advantage
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                              ),
                            ),
                            child: Text(
                              state.rollType == RollType.advantage
                                  ? 'ADV'
                                  : 'DIS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: state.rollType == RollType.advantage
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Roll Button with themed d12
                _RollButton(
                  onPressed: state.hasFormula ? () => notifier.roll() : null,
                  clip: ref.watch(diceSpriteAtlasProvider).value?.clipFor(12),
                ),
              ],
            ),
          ),
          if (state.lastRoll != null) ...[
            const SizedBox(height: 12),
            RollingDiceStage(
              record: state.lastRoll!,
              serial: state.rollSerial,
              atlas: ref.watch(diceSpriteAtlasProvider).value,
            ),
          ],
          const SizedBox(height: 12),

          // Polyhedral Tray
          PolyhedralDiceTray(
            atlas: ref.watch(diceSpriteAtlasProvider).value,
            diceCounts: state.diceCounts,
            flatModifier: state.flatModifier,
            onAddDie: (sides) => notifier.addDie(sides),
            onRemoveDie: (sides) => notifier.removeDie(sides),
            onAdjustModifier: (delta) => notifier.adjustFlatModifier(delta),
          ),
          const SizedBox(height: 12),

          // Advantage / Disadvantage Segments
          const Text(
            'ROLL TYPE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          SegmentedButton<RollType>(
            segments: const [
              ButtonSegment(
                value: RollType.normal,
                label: Text('Normal', style: TextStyle(fontSize: 12)),
              ),
              ButtonSegment(
                value: RollType.advantage,
                label: Text('Advantage', style: TextStyle(fontSize: 12)),
              ),
              ButtonSegment(
                value: RollType.disadvantage,
                label: Text('Disadvantage', style: TextStyle(fontSize: 12)),
              ),
            ],
            selected: {state.rollType},
            onSelectionChanged: (set) => notifier.setRollType(set.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.colorScheme.primary.withAlpha(60);
                }
                return theme.colorScheme.surface;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.colorScheme.primary;
                }
                return theme.colorScheme.onSurface.withAlpha(180);
              }),
            ),
          ),
          const SizedBox(height: 12),

          // Situational Modifiers
          const Text(
            'SITUATIONAL MODIFIERS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          SituationalChipsRow(
            activeBonusIds: state.activeBonusIds,
            onToggleBonus: (id) => notifier.toggleSituationalBonus(id),
          ),
          const SizedBox(height: 14),
          Divider(color: theme.dividerColor),
          const SizedBox(height: 8),

          // Roll History Log
          RollHistoryList(
            history: state.history,
            onReroll: (record) {
              notifier.loadFromRecord(record);
              notifier.roll();
            },
            onClearHistory: () => notifier.clearHistory(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );

    if (isFullScreen) {
      return content;
    }

    if (isBottomSheet) {
      return Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: content,
      );
    }

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      width: 380,
      child: SafeArea(child: content),
    );
  }
}

/// Compact, highly accessible action button placed beside the formula display.
/// Displays a resting d12 themed sprite with "ROLL" overlaid on top.
class _RollButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final DiceAtlasClip? clip;

  const _RollButton({required this.onPressed, this.clip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null;
    final baseTint = Color.lerp(theme.colorScheme.primary, Colors.white, 0.25)!;
    final tint = isEnabled
        ? baseTint
        : Color.lerp(theme.disabledColor, Colors.white, 0.2)!;
    final labelColor = isEnabled
        ? (tint.computeLuminance() > 0.45 ? Colors.black87 : Colors.white)
        : theme.disabledColor;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: 'Roll',
      child: Tooltip(
        message: isEnabled ? 'Roll dice' : 'Formula is empty',
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isEnabled ? 1.0 : 0.4,
          child: Container(
            width: 76,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isEnabled
                    ? theme.colorScheme.primary
                    : theme.dividerColor,
                width: 1.5,
              ),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(35),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: clip != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            DieSprite(clip: clip!, size: 54, tint: tint),
                            Text(
                              'ROLL',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                                color: labelColor,
                                shadows: isEnabled
                                    ? [
                                        Shadow(
                                          color: labelColor == Colors.white
                                              ? Colors.black54
                                              : Colors.white70,
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.casino,
                              size: 22,
                              color: isEnabled
                                  ? theme.colorScheme.primary
                                  : theme.disabledColor,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'ROLL',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                                color: isEnabled
                                    ? theme.colorScheme.primary
                                    : theme.disabledColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

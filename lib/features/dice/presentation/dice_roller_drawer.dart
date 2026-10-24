import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../models/dice_roll_record.dart';
import '../providers/dice_drawer_provider.dart';
import 'widgets/polyhedral_dice_tray.dart';
import 'widgets/roll_history_list.dart';
import 'widgets/situational_chips_row.dart';

class DiceRollerDrawer extends ConsumerWidget {
  final bool isBottomSheet;

  const DiceRollerDrawer({
    super.key,
    this.isBottomSheet = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diceDrawerProvider);
    final notifier = ref.read(diceDrawerProvider.notifier);

    final content = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.casino, color: AppTheme.primaryGold, size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'DICE ROLLER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => notifier.clearDice(),
                    icon: const Icon(Icons.restart_alt, size: 14),
                    label: const Text('Reset', style: TextStyle(fontSize: 11)),
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
                color: AppTheme.primaryGold.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.primaryGold.withAlpha(80)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark_outline, size: 12, color: AppTheme.primaryGold),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      state.contextTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),

          // Formula Display Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryGold, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGold.withAlpha(25),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FORMULA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white.withAlpha(140),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.formula,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.rollType != RollType.normal)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      state.rollType == RollType.advantage ? 'ADV' : 'DIS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: state.rollType == RollType.advantage
                            ? Colors.greenAccent
                            : Colors.redAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Polyhedral Tray
          PolyhedralDiceTray(
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
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.grey),
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
                  return AppTheme.primaryGold.withAlpha(60);
                }
                return AppTheme.surfaceDark;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primaryGold;
                }
                return Colors.white70;
              }),
            ),
          ),
          const SizedBox(height: 12),

          // Situational Modifiers
          const Text(
            'SITUATIONAL MODIFIERS',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          SituationalChipsRow(
            activeBonusIds: state.activeBonusIds,
            onToggleBonus: (id) => notifier.toggleSituationalBonus(id),
          ),
          const SizedBox(height: 14),

          // ROLL DICE CTA
          ElevatedButton.icon(
            onPressed: () {
              final record = notifier.roll();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${record.context}: Rolled ${record.total}! (${record.formula})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: record.isCriticalHit
                      ? Colors.green
                      : record.isCriticalMiss
                          ? Colors.redAccent
                          : AppTheme.cardDark,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.casino, size: 20),
            label: Text(
              'ROLL DICE (${state.formula})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF4A4037)),
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

    if (isBottomSheet) {
      return Container(
        decoration: const BoxDecoration(
          color: AppTheme.parchmentDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: content,
      );
    }

    return Drawer(
      backgroundColor: AppTheme.parchmentDark,
      width: 380,
      child: SafeArea(child: content),
    );
  }
}

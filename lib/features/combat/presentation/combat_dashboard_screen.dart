import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/dice/dice_roller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../dice/presentation/dice_roller_drawer.dart';
import '../../dice/presentation/widgets/floating_dice_fab.dart';
import '../../dice/providers/dice_drawer_provider.dart';
import '../providers/combat_session_provider.dart';
import 'widgets/combat_vitals_row.dart';
import 'widgets/conditions_bar.dart';
import 'widgets/death_saves_widget.dart';
import 'widgets/hp_tracker_card.dart';
import 'widgets/rest_dialog.dart';
import 'widgets/spell_slots_matrix.dart';

class CombatDashboardScreen extends ConsumerWidget {
  final String characterId;
  final DiceRoller? diceRoller;

  const CombatDashboardScreen({
    super.key,
    required this.characterId,
    this.diceRoller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(combatSessionProvider(characterId));
    final notifier = ref.read(combatSessionProvider(characterId).notifier);

    if (state == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Combat Session')),
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryGold),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.primaryGold,
              ),
            ),
            Text(
              'Level ${state.level} ${state.className} (${state.raceName})',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withAlpha(160),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino_outlined),
            tooltip: 'Dice Roller',
            color: AppTheme.primaryGold,
            onPressed: () => FloatingDiceFab.openDiceRoller(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => RestDialog(
                  state: state,
                  notifier: notifier,
                  diceRoller: diceRoller,
                ),
              ),
              icon: const Icon(Icons.hotel_outlined, size: 16),
              label: const Text('REST'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surfaceDark,
                foregroundColor: AppTheme.primaryGold,
                side: const BorderSide(color: AppTheme.primaryGold, width: 1),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
      ),
      body: CombatDashboardView(
        characterId: characterId,
        diceRoller: diceRoller,
      ),
      endDrawer: const DiceRollerDrawer(),
      floatingActionButton: const FloatingDiceFab(),
    );
  }
}

/// Standalone combat dashboard view that can be embedded into tabs.
class CombatDashboardView extends ConsumerStatefulWidget {
  final String characterId;
  final DiceRoller? diceRoller;

  const CombatDashboardView({
    super.key,
    required this.characterId,
    this.diceRoller,
  });

  @override
  ConsumerState<CombatDashboardView> createState() => _CombatDashboardViewState();
}

class _CombatDashboardViewState extends ConsumerState<CombatDashboardView> {
  late DiceRoller _diceRoller;

  @override
  void initState() {
    super.initState();
    _diceRoller = widget.diceRoller ?? DiceRoller();
  }

  void _rollWeaponAttack(WeaponAttackInfo weapon, CombatSessionState state) {
    ref.read(diceDrawerProvider.notifier).setContext(
      title: '${state.name}: ${weapon.name} Attack',
      diceCounts: {20: 1},
      flatModifier: weapon.toHit,
    );
    final record = ref.read(diceDrawerProvider.notifier).roll();

    String message = '${weapon.name} Attack: rolled ${record.total} to hit!';
    if (record.isCriticalHit) {
      message = '🎯 CRITICAL HIT! ${weapon.name}: rolled ${record.total}';
    } else if (record.isCriticalMiss) {
      message = '💀 CRITICAL MISS (Natural 1) on ${weapon.name}!';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: record.isCriticalHit
            ? Colors.green
            : record.isCriticalMiss
                ? Colors.redAccent
                : AppTheme.cardDark,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _rollWeaponDamage(WeaponAttackInfo weapon, CombatSessionState state) {
    final roll = _diceRoller.rollFormula(weapon.damageFormula);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${weapon.name} Damage: ${roll.total} (${weapon.damageFormula})'),
        backgroundColor: AppTheme.primaryGold,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _useSecondWind(CombatSessionState state, CombatSessionNotifier notifier) {
    final roll = _diceRoller.rollFormula('1d10 + ${state.level}');
    notifier.applyHealing(roll.total);
    notifier.useSecondWind();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Second Wind used! Restored ${roll.total} Hit Points!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(combatSessionProvider(widget.characterId));
    final notifier = ref.read(combatSessionProvider(widget.characterId).notifier);

    if (state == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryGold),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // HP Tracker Card
            HpTrackerCard(state: state, notifier: notifier),
            const SizedBox(height: 14),

            // Death Saves (shown when HP is 0 or any marks exist)
            if (state.currentHp == 0 ||
                state.deathSaveSuccesses > 0 ||
                state.deathSaveFailures > 0) ...[
              DeathSavesWidget(
                state: state,
                notifier: notifier,
                diceRoller: _diceRoller,
              ),
              const SizedBox(height: 14),
            ],

            // Combat Vitals Row (AC, Initiative, Speed, Hit Dice)
            CombatVitalsRow(state: state),
            const SizedBox(height: 14),

            // Active Conditions & Buffs
            ConditionsBar(state: state, notifier: notifier),
            const SizedBox(height: 14),

            // Spell Slots Matrix (if character has slots)
            if (state.spellSlots.isNotEmpty) ...[
              SpellSlotsMatrix(state: state, notifier: notifier),
              const SizedBox(height: 14),
            ],

            // Actions & Attacks Section
            _buildActionsSection(state, notifier),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(CombatSessionState state, CombatSessionNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4A4037)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: const [
              Icon(Icons.sports_martial_arts, color: AppTheme.primaryGold, size: 18),
              SizedBox(width: 8),
              Text(
                'ATTACKS & ACTIONS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppTheme.primaryGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Weapon Attacks
          ...state.weapons.map((w) {
            final toHitSign = w.toHit >= 0 ? '+' : '';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF4A4037)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          w.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${w.type} • $toHitSign${w.toHit} to hit • ${w.damageFormula}',
                          style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _rollWeaponAttack(w, state),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGold,
                      side: const BorderSide(color: AppTheme.primaryGold),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text('$toHitSign${w.toHit} Hit'),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () => _rollWeaponDamage(w, state),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Dmg'),
                  ),
                ],
              ),
            );
          }),

          // Class Features (e.g. Second Wind)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF4A4037)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Second Wind (Bonus Action)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Regain 1d10 + ${state.level} HP (1/Short Rest)',
                        style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: state.hasSecondWind
                      ? () => _useSecondWind(state, notifier)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.hasSecondWind ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(state.hasSecondWind ? 'USE' : 'SPENT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

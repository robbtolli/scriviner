import 'package:flutter/material.dart';

import '../../providers/combat_session_provider.dart';
import 'damage_heal_dialog.dart';

class HpTrackerCard extends StatelessWidget {
  final CombatSessionState state;
  final CombatSessionNotifier notifier;

  const HpTrackerCard({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hpPercent = state.maxHp > 0
        ? (state.currentHp / state.maxHp).clamp(0.0, 1.0)
        : 0.0;

    final hpColor = hpPercent > 0.5
        ? Colors.greenAccent
        : hpPercent > 0.2
        ? Colors.amberAccent
        : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: state.currentHp == 0
              ? Colors.redAccent
              : theme.colorScheme.primary.withAlpha(120),
          width: state.currentHp == 0 ? 2 : 1.5,
        ),
        boxShadow: [
          if (state.currentHp == 0)
            BoxShadow(
              color: Colors.redAccent.withAlpha(50),
              blurRadius: 16,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HIT POINTS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (state.tempHp > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withAlpha(40),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blueAccent.withAlpha(140)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shield,
                        size: 13,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${state.tempHp} Temp HP',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // HP Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${state.currentHp}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: hpColor,
                ),
              ),
              Text(
                ' / ${state.maxHp}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Health Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: hpPercent,
              minHeight: 12,
              backgroundColor: theme.colorScheme.onSurface.withAlpha(20),
              valueColor: AlwaysStoppedAnimation<Color>(hpColor),
            ),
          ),
          const SizedBox(height: 18),
          // Quick adjustments row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickButton(
                context,
                '-10',
                () => notifier.applyDamage(10),
                isDamage: true,
              ),
              _buildQuickButton(
                context,
                '-5',
                () => notifier.applyDamage(5),
                isDamage: true,
              ),
              _buildQuickButton(
                context,
                '-1',
                () => notifier.applyDamage(1),
                isDamage: true,
              ),
              _buildQuickButton(
                context,
                '+1',
                () => notifier.applyHealing(1),
                isDamage: false,
              ),
              _buildQuickButton(
                context,
                '+5',
                () => notifier.applyHealing(5),
                isDamage: false,
              ),
              _buildQuickButton(
                context,
                '+10',
                () => notifier.applyHealing(10),
                isDamage: false,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => DamageHealDialog(
                  onDamage: (amount) => notifier.applyDamage(amount),
                  onHeal: (amount) => notifier.applyHealing(amount),
                  onSetTempHp: (amount) => notifier.setTempHp(amount),
                ),
              );
            },
            icon: const Icon(Icons.calculate_outlined, size: 18),
            label: const Text('CUSTOM DAMAGE / HEAL'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary, width: 1),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(
    BuildContext context,
    String label,
    VoidCallback onTap, {
    required bool isDamage,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDamage
              ? Colors.redAccent.withAlpha(25)
              : Colors.green.withAlpha(25),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDamage
                ? Colors.redAccent.withAlpha(80)
                : Colors.green.withAlpha(80),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDamage ? Colors.redAccent : Colors.greenAccent,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/combat_session_provider.dart';

class CombatVitalsRow extends StatelessWidget {
  final CombatSessionState state;

  const CombatVitalsRow({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final initSign = state.initiative >= 0 ? '+' : '';

    return Row(
      children: [
        // Armor Class
        Expanded(
          child: _buildVitalBox(
            context,
            icon: Icons.shield_outlined,
            label: 'ARMOR CLASS',
            value: '${state.armorClass}',
            subtitle: 'AC',
          ),
        ),
        const SizedBox(width: 8),
        // Initiative
        Expanded(
          child: _buildVitalBox(
            context,
            icon: Icons.flash_on_outlined,
            label: 'INITIATIVE',
            value: '$initSign${state.initiative}',
            subtitle: 'DEX',
          ),
        ),
        const SizedBox(width: 8),
        // Speed
        Expanded(
          child: _buildVitalBox(
            context,
            icon: Icons.directions_run_outlined,
            label: 'SPEED',
            value: '${state.speed}',
            subtitle: 'ft',
          ),
        ),
        const SizedBox(width: 8),
        // Hit Dice
        Expanded(
          child: _buildVitalBox(
            context,
            icon: Icons.favorite_border,
            label: 'HIT DICE',
            value: '${state.availableHitDice}/${state.hitDiceTotal}',
            subtitle: state.hitDiceDie,
          ),
        ),
      ],
    );
  }

  Widget _buildVitalBox(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A4037)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: AppTheme.primaryGold),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.primaryGold,
            ),
          ),
        ],
      ),
    );
  }
}

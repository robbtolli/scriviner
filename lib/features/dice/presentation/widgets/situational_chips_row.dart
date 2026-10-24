import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/dice_drawer_provider.dart';

class SituationalChipsRow extends StatelessWidget {
  final Set<String> activeBonusIds;
  final void Function(String bonusId) onToggleBonus;

  const SituationalChipsRow({
    super.key,
    required this.activeBonusIds,
    required this.onToggleBonus,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: SituationalBonus.defaultPresets.map((bonus) {
          final isSelected = activeBonusIds.contains(bonus.id);

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(bonus.label),
              selected: isSelected,
              onSelected: (_) => onToggleBonus(bonus.id),
              selectedColor: AppTheme.primaryGold.withAlpha(40),
              backgroundColor: AppTheme.surfaceDark,
              checkmarkColor: AppTheme.primaryGold,
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryGold : Colors.white70,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.primaryGold
                    : const Color(0xFF4A4037),
              ),
              visualDensity: VisualDensity.compact,
            ),
          );
        }).toList(),
      ),
    );
  }
}

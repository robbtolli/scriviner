import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

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
              selectedColor: theme.colorScheme.primary.withAlpha(40),
              backgroundColor: theme.colorScheme.surface,
              checkmarkColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(180),
              ),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.dividerColor,
              ),
              visualDensity: VisualDensity.compact,
            ),
          );
        }).toList(),
      ),
    );
  }
}

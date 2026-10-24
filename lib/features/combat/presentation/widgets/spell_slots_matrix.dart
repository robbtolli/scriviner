import 'package:flutter/material.dart';

import '../../../../core/theme/models/scrivener_theme_tokens.dart';
import '../../providers/combat_session_provider.dart';

class SpellSlotsMatrix extends StatelessWidget {
  final CombatSessionState state;
  final CombatSessionNotifier notifier;

  const SpellSlotsMatrix({
    super.key,
    required this.state,
    required this.notifier,
  });

  String _formatSlotName(String key) {
    if (key.toLowerCase() == 'pact') return 'Pact Magic';
    if (key.toLowerCase().startsWith('level_')) {
      final lvl = key.substring(6);
      return 'Level $lvl';
    }
    if (int.tryParse(key) != null) {
      return 'Level $key';
    }
    return key[0].toUpperCase() + key.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<ScrivenerThemeTokens>() ?? ScrivenerThemeTokens.ancientTomeTokens;

    if (state.spellSlots.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedEntries = state.spellSlots.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        border: Border.fromBorderSide(tokens.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(tokens.iconography.spells, color: theme.colorScheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'SPELL SLOTS & RESOURCES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                'Tap pip to expend/restore',
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withAlpha(120),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...sortedEntries.map((entry) {
            final slotKey = entry.key;
            final slotInfo = entry.value;
            final title = _formatSlotName(slotKey);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: List.generate(slotInfo.total, (index) {
                        // Spent slots are at indices 0..spent-1
                        final isSpent = index < slotInfo.spent;
                        return InkWell(
                          onTap: () => notifier.toggleSpellSlot(slotKey, index),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              isSpent
                                  ? Icons.radio_button_unchecked
                                  : Icons.circle,
                              color: isSpent
                                  ? Colors.grey
                                  : theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Text(
                    '${slotInfo.available} / ${slotInfo.total}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: slotInfo.available > 0
                          ? theme.colorScheme.primary
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

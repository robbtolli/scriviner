import 'package:flutter/material.dart';

import '../../../../core/theme/models/scrivener_theme_tokens.dart';
import '../../../../systems/dnd5e/dnd5e_conditions.dart';
import '../../providers/combat_session_provider.dart';

class ConditionsBar extends StatelessWidget {
  final CombatSessionState state;
  final CombatSessionNotifier notifier;

  const ConditionsBar({
    super.key,
    required this.state,
    required this.notifier,
  });

  void _showConditionPicker(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withAlpha(60),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Conditions & Buffs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  Divider(color: theme.dividerColor),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: Dnd5eCondition.all.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: 1, color: theme.dividerColor.withAlpha(50)),
                      itemBuilder: (context, index) {
                        final condition = Dnd5eCondition.all[index];
                        final isActive = state.activeConditions.contains(condition.id);

                        return CheckboxListTile(
                          value: isActive,
                          activeColor: theme.colorScheme.primary,
                          checkColor: theme.colorScheme.onPrimary,
                          title: Text(
                            condition.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            condition.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withAlpha(160),
                            ),
                          ),
                          onChanged: (_) {
                            notifier.toggleCondition(condition.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showConditionDetail(BuildContext context, Dnd5eCondition condition) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.primary),
        ),
        title: Text(
          condition.name,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          condition.description,
          style: TextStyle(fontSize: 14, height: 1.4, color: theme.colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () {
              notifier.toggleCondition(condition.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Remove Condition', style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<ScrivenerThemeTokens>() ?? ScrivenerThemeTokens.ancientTomeTokens;

    final activeConditionsList = state.activeConditions
        .map((id) => Dnd5eCondition.all.firstWhere(
              (c) => c.id == id,
              orElse: () => Dnd5eCondition(
                id: id,
                name: id[0].toUpperCase() + id.substring(1),
                description: 'Custom condition.',
              ),
            ))
        .toList();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_moon_outlined, color: theme.colorScheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'ACTIVE CONDITIONS & BUFFS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => _showConditionPicker(context),
                icon: const Icon(Icons.add, size: 14),
                label: const Text('MANAGE', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary, width: 0.8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (activeConditionsList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'No active conditions (Normal status)',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface.withAlpha(120),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activeConditionsList.map((condition) {
                final isBuff = condition.id == 'bless';
                return ActionChip(
                  avatar: Icon(
                    isBuff ? Icons.auto_awesome : Icons.warning_amber_rounded,
                    size: 16,
                    color: isBuff ? Colors.amberAccent : Colors.redAccent,
                  ),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(condition.name),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => notifier.toggleCondition(condition.id),
                        child: const Icon(Icons.close, size: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  backgroundColor: isBuff
                      ? Colors.amberAccent.withAlpha(25)
                      : Colors.redAccent.withAlpha(25),
                  side: BorderSide(
                    color: isBuff
                        ? Colors.amberAccent.withAlpha(90)
                        : Colors.redAccent.withAlpha(90),
                  ),
                  onPressed: () => _showConditionDetail(context, condition),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
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
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
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
                      color: Colors.grey.withAlpha(100),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Conditions & Buffs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF4A4037)),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: Dnd5eCondition.all.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, color: Color(0xFF332C26)),
                      itemBuilder: (context, index) {
                        final condition = Dnd5eCondition.all[index];
                        final isActive = state.activeConditions.contains(condition.id);

                        return CheckboxListTile(
                          value: isActive,
                          activeColor: AppTheme.primaryGold,
                          checkColor: Colors.black,
                          title: Text(
                            condition.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isActive ? AppTheme.primaryGold : Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            condition.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(160),
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.primaryGold),
        ),
        title: Text(
          condition.name,
          style: const TextStyle(
            color: AppTheme.primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          condition.description,
          style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.white),
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
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4A4037)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_moon_outlined, color: AppTheme.primaryGold, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'ACTIVE CONDITIONS & BUFFS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => _showConditionPicker(context),
                icon: const Icon(Icons.add, size: 14),
                label: const Text('MANAGE', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGold,
                  side: const BorderSide(color: AppTheme.primaryGold, width: 0.8),
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
                  color: Colors.white.withAlpha(120),
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

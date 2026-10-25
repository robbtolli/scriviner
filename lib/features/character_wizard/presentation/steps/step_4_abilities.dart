import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/wizard_draft.dart';
import '../../providers/wizard_provider.dart';
import '../widgets/ability_score_roller.dart';

class Step4Abilities extends ConsumerWidget {
  const Step4Abilities({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(characterWizardProvider);
    final notifier = ref.read(characterWizardProvider.notifier);

    final stats = ['STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 4: Ability Scores',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your six ability scores determine your physical power, agility, resilience, and mental prowess.',
            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14),
          ),
          const SizedBox(height: 16),
          // Generation Method Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<AbilityGenMethod>(
              segments: const [
                ButtonSegment(
                  value: AbilityGenMethod.standardArray,
                  label: Text('Standard Array'),
                  icon: Icon(Icons.table_chart),
                ),
                ButtonSegment(
                  value: AbilityGenMethod.pointBuy,
                  label: Text('Point Buy'),
                  icon: Icon(Icons.tune),
                ),
                ButtonSegment(
                  value: AbilityGenMethod.rolled,
                  label: Text('Roll 4d6'),
                  icon: Icon(Icons.casino),
                ),
              ],
              selected: {draft.abilityMethod},
              onSelectionChanged: (selected) {
                notifier.setAbilityMethod(selected.first);
              },
            ),
          ),
          const SizedBox(height: 16),
          // Helper banner based on method
          if (draft.abilityMethod == AbilityGenMethod.standardArray) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryGold.withAlpha(80)),
              ),
              child: LayoutBuilder(
                builder: (context, bannerConstraints) {
                  final infoText = Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppTheme.primaryGold, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Standard Array distributes [15, 14, 13, 12, 10, 8].',
                          style: TextStyle(fontSize: 13, color: Colors.white.withAlpha(200)),
                        ),
                      ),
                    ],
                  );

                  if (bannerConstraints.maxWidth < 450 && draft.charClass != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        infoText,
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => notifier.autoAssignStandardArrayForClass(draft.charClass!),
                          icon: const Icon(Icons.auto_fix_high, size: 16),
                          label: Text('Auto-Assign (${draft.charClass!.name})'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: infoText),
                      if (draft.charClass != null) ...[
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () => notifier.autoAssignStandardArrayForClass(draft.charClass!),
                          icon: const Icon(Icons.auto_fix_high, size: 16),
                          label: Text('Auto-Assign (${draft.charClass!.name})'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ] else if (draft.abilityMethod == AbilityGenMethod.pointBuy) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: draft.remainingPointBuyPoints < 0 ? Colors.redAccent : AppTheme.primaryGold,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    draft.remainingPointBuyPoints < 0 ? Icons.error_outline : Icons.shopping_bag_outlined,
                    color: draft.remainingPointBuyPoints < 0 ? Colors.redAccent : AppTheme.primaryGold,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Point Buy Budget: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${draft.remainingPointBuyPoints} / 27 points left',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: draft.remainingPointBuyPoints < 0 ? Colors.redAccent : AppTheme.primaryGold,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            AbilityScoreRoller(
              rolledScores: draft.rolledPool,
              onRoll: () => notifier.rollStats(),
            ),
          ],
          const SizedBox(height: 20),
          // Ability Rows
          ...stats.map((stat) {
            final base = draft.baseAbilities[stat] ?? 10;
            final bonus = draft.race?.abilityBonuses[stat] ?? 0;
            final total = base + bonus;
            final mod = ((total - 10) / 2).floor();
            final modStr = mod >= 0 ? '+$mod' : '$mod';

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withAlpha(20)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stat,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          _getStatName(stat),
                          style: TextStyle(fontSize: 10, color: Colors.white.withAlpha(140)),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (draft.abilityMethod == AbilityGenMethod.pointBuy) ...[
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: base > 8 ? () => notifier.setAbilityScore(stat, base - 1) : null,
                    ),
                    Text(
                      '$base',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: base < 15 && draft.remainingPointBuyPoints >= WizardDraft.getPointBuyCost(base + 1) - WizardDraft.getPointBuyCost(base)
                          ? () => notifier.setAbilityScore(stat, base + 1)
                          : null,
                    ),
                  ] else ...[
                    DropdownButton<int>(
                      value: base,
                      dropdownColor: AppTheme.surfaceDark,
                      items: (draft.abilityMethod == AbilityGenMethod.standardArray
                              ? [15, 14, 13, 12, 10, 8]
                              : draft.rolledPool.isNotEmpty
                                  ? draft.rolledPool
                                  : [18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8])
                          .toSet()
                          .map((val) => DropdownMenuItem(
                                value: val,
                                child: Text('$val', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ))
                          .toList(),
                      onChanged: (newVal) {
                        if (newVal != null) notifier.setAbilityScore(stat, newVal);
                      },
                    ),
                  ],
                  const SizedBox(width: 8),
                  if (bonus > 0) ...[
                    Text(
                      '+$bonus',
                      style: const TextStyle(fontSize: 11, color: Colors.greenAccent, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    width: 44,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.primaryGold),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      modStr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          // Educational Guide
          _buildStatExplainer(),
        ],
      ),
    );
  }

  Widget _buildStatExplainer() {
    return ExpansionTile(
      title: const Text(
        'What does each ability score do?',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryGold),
      ),
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• STR (Strength): Melee weapon damage, athletics, jump distance, encumbrance.'),
              SizedBox(height: 4),
              Text('• DEX (Dexterity): Armor class (evasion), initiative, ranged attacks, stealth.'),
              SizedBox(height: 4),
              Text('• CON (Constitution): Maximum health points, surviving poison, concentration.'),
              SizedBox(height: 4),
              Text('• INT (Intelligence): Wizard magic, knowledge (arcana, history), investigation.'),
              SizedBox(height: 4),
              Text('• WIS (Wisdom): Cleric/Druid magic, noticing hidden traps (perception), insight.'),
              SizedBox(height: 4),
              Text('• CHA (Charisma): Bard/Sorcerer/Warlock magic, persuasion, deception, intimidation.'),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatName(String stat) {
    switch (stat) {
      case 'STR':
        return 'Strength';
      case 'DEX':
        return 'Dexterity';
      case 'CON':
        return 'Constitution';
      case 'INT':
        return 'Intelligence';
      case 'WIS':
        return 'Wisdom';
      case 'CHA':
        return 'Charisma';
      default:
        return '';
    }
  }
}

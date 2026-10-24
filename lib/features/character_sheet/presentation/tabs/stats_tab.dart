import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../dice/presentation/widgets/floating_dice_fab.dart';
import '../../../dice/providers/dice_drawer_provider.dart';
import '../../providers/character_sheet_provider.dart';
import '../widgets/level_up_wizard_dialog.dart';

class AbilityMeta {
  final String key;
  final String name;
  final String abbr;
  final String description;

  const AbilityMeta({
    required this.key,
    required this.name,
    required this.abbr,
    required this.description,
  });
}

const List<AbilityMeta> standardAbilities = [
  AbilityMeta(
    key: 'str',
    name: 'Strength',
    abbr: 'STR',
    description: 'Athletics, melee attacks & carrying power',
  ),
  AbilityMeta(
    key: 'dex',
    name: 'Dexterity',
    abbr: 'DEX',
    description: 'Acrobatics, stealth, initiative & armor class',
  ),
  AbilityMeta(
    key: 'con',
    name: 'Constitution',
    abbr: 'CON',
    description: 'Health, stamina & concentration checks',
  ),
  AbilityMeta(
    key: 'int',
    name: 'Intelligence',
    abbr: 'INT',
    description: 'Arcana, history, investigation & memory',
  ),
  AbilityMeta(
    key: 'wis',
    name: 'Wisdom',
    abbr: 'WIS',
    description: 'Perception, insight, medicine & intuition',
  ),
  AbilityMeta(
    key: 'cha',
    name: 'Charisma',
    abbr: 'CHA',
    description: 'Persuasion, deception, intimidation & performance',
  ),
];

class StatsTab extends ConsumerWidget {
  final CharacterSheetState state;
  final CharacterSheetNotifier notifier;

  const StatsTab({
    super.key,
    required this.state,
    required this.notifier,
  });

  String _formatModifier(int mod) => mod >= 0 ? '+$mod' : '$mod';

  void _rollAbilityCheck(
    BuildContext context,
    WidgetRef ref,
    String abilityName,
    int modifier,
  ) {
    ref.read(diceDrawerProvider.notifier).setContext(
      title: '${state.name}: $abilityName Check',
      diceCounts: {20: 1},
      flatModifier: modifier,
    );
    FloatingDiceFab.openDiceRoller(context);
  }

  void _rollSavingThrow(
    BuildContext context,
    WidgetRef ref,
    String abilityName,
    int saveBonus,
  ) {
    ref.read(diceDrawerProvider.notifier).setContext(
      title: '${state.name}: $abilityName Save',
      diceCounts: {20: 1},
      flatModifier: saveBonus,
    );
    FloatingDiceFab.openDiceRoller(context);
  }

  void _showEditScoreDialog(
    BuildContext context,
    String key,
    String name,
    int currentScore,
  ) {
    int score = currentScore;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final mod = ((score - 10) / 2).floor();
            final modStr = _formatModifier(mod);
            return AlertDialog(
              backgroundColor: AppTheme.cardDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFF4A4037)),
              ),
              title: Text(
                'Edit $name Score',
                style: const TextStyle(
                  color: AppTheme.primaryGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Modifier: $modStr',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        onPressed: score > 1 ? () => setState(() => score--) : null,
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.surfaceDark,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton.filledTonal(
                        onPressed: score < 30 ? () => setState(() => score++) : null,
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.surfaceDark,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    notifier.updateAbilityScore(key, score);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('SAVE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showManualLevelDialog(BuildContext context) {
    int level = state.level;
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final prof = 2 + ((level - 1) / 4).floor();
            return AlertDialog(
              backgroundColor: AppTheme.cardDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFF4A4037)),
              ),
              title: const Text(
                'Manual Level Edit',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$level',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Proficiency Bonus: +$prof  •  Hit Dice: ${level}d',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        onPressed: level > 1 ? () => setState(() => level--) : null,
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.surfaceDark,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton.filledTonal(
                        onPressed: level < 20 ? () => setState(() => level++) : null,
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.surfaceDark,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    notifier.updateLevel(level);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Level updated to Level $level!'),
                        backgroundColor: Colors.green.shade700,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('SAVE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openLevelUpWizard(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => LevelUpWizardDialog(
        state: state,
        notifier: notifier,
      ),
    );
  }

  Widget _buildHeroLevelCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withAlpha(120)),
      ),
      child: Row(
        children: [
          // Level Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryGold),
            ),
            child: Column(
              children: [
                const Text(
                  'HERO LEVEL',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${state.level}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Character Class & Subtext
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level ${state.level} ${state.className}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  state.level >= 20
                      ? 'Maximum Level Cap (Level 20)'
                      : 'Advance to Level ${state.level + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action Buttons: Manual Edit & Level Up Wizard
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: Colors.grey,
                tooltip: 'Manually Edit Level',
                onPressed: () => _showManualLevelDialog(context),
              ),
              const SizedBox(width: 6),
              ElevatedButton.icon(
                onPressed: state.level < 20 ? () => _openLevelUpWizard(context) : null,
                icon: const Icon(Icons.auto_awesome, size: 15),
                label: const Text('LEVEL UP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero Level & Advancement Card
        _buildHeroLevelCard(context),
        const SizedBox(height: 12),

        // Top Overview Banner: Proficiency Bonus & Passive Scores
        _buildOverviewBanner(context),
        const SizedBox(height: 16),

        // Section Title
        const Row(
          children: [
            Icon(Icons.analytics_outlined, size: 18, color: AppTheme.primaryGold),
            SizedBox(width: 8),
            Text(
              'ABILITY SCORES & SAVING THROWS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppTheme.primaryGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Abilities Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 800
                ? 3
                : constraints.maxWidth >= 500
                    ? 2
                    : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: standardAbilities.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 220,
              ),
              itemBuilder: (context, index) {
                final ability = standardAbilities[index];
                return _buildAbilityCard(context, ref, ability);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOverviewBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A4037)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Proficiency Bonus Badge
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primaryGold.withAlpha(80)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'PROFICIENCY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '+${state.proficiencyBonus}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Passive Perception
              Expanded(
                child: _buildPassiveTile(
                  icon: Icons.visibility_outlined,
                  label: 'PASSIVE PERC',
                  value: '${state.passivePerception}',
                ),
              ),
              const SizedBox(width: 8),
              // Passive Investigation
              Expanded(
                child: _buildPassiveTile(
                  icon: Icons.search,
                  label: 'PASSIVE INVEST',
                  value: '${state.passiveInvestigation}',
                ),
              ),
              const SizedBox(width: 8),
              // Passive Insight
              Expanded(
                child: _buildPassiveTile(
                  icon: Icons.lightbulb_outline,
                  label: 'PASSIVE INSIGHT',
                  value: '${state.passiveInsight}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassiveTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4A4037)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilityCard(
    BuildContext context,
    WidgetRef ref,
    AbilityMeta ability,
  ) {
    final score = state.getAbilityScore(ability.key);
    final mod = state.getAbilityModifier(ability.key);
    final modStr = _formatModifier(mod);

    final isSaveProf = state.savingThrowProficiencies.contains(ability.key.toLowerCase());
    final saveBonus = state.getSavingThrowBonus(ability.key);
    final saveBonusStr = _formatModifier(saveBonus);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSaveProf ? AppTheme.primaryGold.withAlpha(120) : const Color(0xFF4A4037),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Ability Name, Abbr, Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ability.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16),
                color: Colors.grey,
                tooltip: 'Edit ${ability.name} Score',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _showEditScoreDialog(
                  context,
                  ability.key,
                  ability.name,
                  score,
                ),
              ),
            ],
          ),
          const Spacer(),

          // Center: Large Modifier & Roll Check Button
          Row(
            children: [
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  modStr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _rollAbilityCheck(context, ref, ability.name, mod),
                  icon: const Icon(Icons.casino_outlined, size: 16),
                  label: Text('CHECK ($modStr)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surfaceDark,
                    foregroundColor: AppTheme.primaryGold,
                    side: const BorderSide(color: AppTheme.primaryGold, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),

          // Divider
          const Divider(color: Color(0xFF4A4037), height: 16),

          // Saving Throw Section
          Row(
            children: [
              // Proficiency Toggle
              GestureDetector(
                onTap: () => notifier.toggleSavingThrowProficiency(ability.key),
                child: Row(
                  children: [
                    Icon(
                      isSaveProf ? Icons.star : Icons.star_border,
                      size: 18,
                      color: isSaveProf ? AppTheme.primaryGold : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Save Roll Button
              InkWell(
                onTap: () => _rollSavingThrow(context, ref, ability.name, saveBonus),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSaveProf
                        ? AppTheme.primaryGold.withAlpha(30)
                        : AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSaveProf
                          ? AppTheme.primaryGold
                          : const Color(0xFF4A4037),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        saveBonusStr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSaveProf ? AppTheme.primaryGold : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.casino,
                        size: 12,
                        color: isSaveProf ? AppTheme.primaryGold : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

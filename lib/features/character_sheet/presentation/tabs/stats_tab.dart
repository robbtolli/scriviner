import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/models/scrivener_theme_tokens.dart';
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
    description:
        'Natural athleticism, brute power, lifting, and melee attack damage.',
  ),
  AbilityMeta(
    key: 'dex',
    name: 'Dexterity',
    abbr: 'DEX',
    description: 'Agility, reflexes, balance, armor class bonus, and stealth.',
  ),
  AbilityMeta(
    key: 'con',
    name: 'Constitution',
    abbr: 'CON',
    description:
        'Health, stamina, maximum hit points, and concentration saves.',
  ),
  AbilityMeta(
    key: 'int',
    name: 'Intelligence',
    abbr: 'INT',
    description:
        'Mental acuity, knowledge recall, spellcasting for wizards, and investigation.',
  ),
  AbilityMeta(
    key: 'wis',
    name: 'Wisdom',
    abbr: 'WIS',
    description: 'Perception, intuition, gut instinct, and survival instincts.',
  ),
  AbilityMeta(
    key: 'cha',
    name: 'Charisma',
    abbr: 'CHA',
    description:
        'Force of personality, persuasion, leadership, and deceptive magnetism.',
  ),
];

class StatsTab extends ConsumerWidget {
  final CharacterSheetState state;
  final CharacterSheetNotifier notifier;

  const StatsTab({super.key, required this.state, required this.notifier});

  String _formatModifier(int mod) {
    if (mod >= 0) {
      return '+$mod';
    }
    return '$mod';
  }

  void _rollAbilityCheck(
    BuildContext context,
    WidgetRef ref,
    String abilityName,
    int mod,
  ) {
    final diceNotifier = ref.read(diceDrawerProvider.notifier);
    diceNotifier.resetDrawer();
    diceNotifier.setDiceCount(20, 1);
    diceNotifier.setFlatModifier(mod);
    diceNotifier.setRollTitle('${state.name}: $abilityName Check');
    FloatingDiceFab.openDiceRoller(context);
  }

  void _rollSavingThrow(
    BuildContext context,
    WidgetRef ref,
    String abilityName,
    int bonus,
  ) {
    final diceNotifier = ref.read(diceDrawerProvider.notifier);
    diceNotifier.resetDrawer();
    diceNotifier.setDiceCount(20, 1);
    diceNotifier.setFlatModifier(bonus);
    diceNotifier.setRollTitle('${state.name}: $abilityName Saving Throw');
    FloatingDiceFab.openDiceRoller(context);
  }

  void _showEditScoreDialog(
    BuildContext context,
    String key,
    String name,
    int currentScore,
  ) {
    int score = currentScore;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final mod = ((score - 10) / 2).floor();
            final modStr = _formatModifier(mod);
            return AlertDialog(
              backgroundColor: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: theme.dividerColor.withAlpha(80)),
              ),
              title: Text(
                'Edit $name Score',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Modifier: $modStr',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        onPressed: score > 1
                            ? () => setState(() => score--)
                            : null,
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface,
                          foregroundColor: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton.filledTonal(
                        onPressed: score < 30
                            ? () => setState(() => score++)
                            : null,
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface,
                          foregroundColor: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    notifier.updateAbilityScore(key, score);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
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
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final prof = 2 + ((level - 1) / 4).floor();
            return AlertDialog(
              backgroundColor: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: theme.dividerColor.withAlpha(80)),
              ),
              title: Text(
                'Manual Level Edit',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$level',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Proficiency Bonus: +$prof  •  Hit Dice: ${level}d',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        onPressed: level > 1
                            ? () => setState(() => level--)
                            : null,
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface,
                          foregroundColor: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton.filledTonal(
                        onPressed: level < 20
                            ? () => setState(() => level++)
                            : null,
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface,
                          foregroundColor: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.grey),
                  ),
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
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
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

  void _launchLevelUpWizard(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => LevelUpWizardDialog(state: state, notifier: notifier),
    );
  }

  Widget _buildHeroLevelCard(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(120)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final levelBadge = Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.colorScheme.primary),
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          );

          final classInfo = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level ${state.level} ${state.className}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
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
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );

          final actionButtons = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                tooltip: 'Manually Edit Level',
                color: theme.colorScheme.onSurface.withAlpha(180),
                onPressed: () => _showManualLevelDialog(context),
              ),
              const SizedBox(width: 4),
              ElevatedButton.icon(
                onPressed: state.level < 20
                    ? () => _launchLevelUpWizard(context)
                    : null,
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('LEVEL UP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          );

          if (constraints.maxWidth < 460) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    levelBadge,
                    const SizedBox(width: 14),
                    Expanded(child: classInfo),
                  ],
                ),
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerRight, child: actionButtons),
              ],
            );
          }

          return Row(
            children: [
              levelBadge,
              const SizedBox(width: 14),
              Expanded(child: classInfo),
              actionButtons,
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tokens = context.tokens;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero Level Advancement Card
        _buildHeroLevelCard(context),
        const SizedBox(height: 12),

        // Top Overview Banner: Proficiency Bonus & Passive Scores
        _buildOverviewBanner(context),
        const SizedBox(height: 16),

        // Section Title
        Row(
          children: [
            Icon(
              tokens.iconography.tabStats,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'ABILITY SCORES & SAVING THROWS',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: theme.colorScheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
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
    final theme = Theme.of(context);
    final tokens = context.tokens;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        border: Border.all(color: theme.dividerColor.withAlpha(80)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Proficiency Bonus Badge
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(80),
                    ),
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
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
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
                  context,
                  icon: Icons.visibility_outlined,
                  label: 'PASSIVE PERC',
                  value: '${state.passivePerception}',
                ),
              ),
              const SizedBox(width: 8),
              // Passive Investigation
              Expanded(
                child: _buildPassiveTile(
                  context,
                  icon: Icons.search,
                  label: 'PASSIVE INVEST',
                  value: '${state.passiveInvestigation}',
                ),
              ),
              const SizedBox(width: 8),
              // Passive Insight
              Expanded(
                child: _buildPassiveTile(
                  context,
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

  Widget _buildPassiveTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withAlpha(80)),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
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
    final theme = Theme.of(context);
    final tokens = context.tokens;

    final score = state.getAbilityScore(ability.key);
    final mod = state.getAbilityModifier(ability.key);
    final modStr = _formatModifier(mod);

    final isSaveProf = state.savingThrowProficiencies.contains(
      ability.key.toLowerCase(),
    );
    final saveBonus = state.getSavingThrowBonus(ability.key);
    final saveBonusStr = _formatModifier(saveBonus);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        border: Border.all(
          color: isSaveProf
              ? theme.colorScheme.primary.withAlpha(120)
              : theme.dividerColor.withAlpha(80),
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
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Score: $score',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withAlpha(140),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16),
                color: theme.colorScheme.onSurface.withAlpha(160),
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
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _rollAbilityCheck(context, ref, ability.name, mod),
                  icon: Icon(tokens.iconography.checkAction, size: 16),
                  label: Text('CHECK ($modStr)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.surface,
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),

          // Divider
          Divider(color: theme.dividerColor.withAlpha(60), height: 16),

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
                      color: isSaveProf
                          ? theme.colorScheme.primary
                          : Colors.grey,
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
                onTap: () =>
                    _rollSavingThrow(context, ref, ability.name, saveBonus),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSaveProf
                        ? theme.colorScheme.primary.withAlpha(30)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSaveProf
                          ? theme.colorScheme.primary
                          : theme.dividerColor.withAlpha(80),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        saveBonusStr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSaveProf
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        tokens.iconography.saveAction,
                        size: 14,
                        color: isSaveProf
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withAlpha(160),
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

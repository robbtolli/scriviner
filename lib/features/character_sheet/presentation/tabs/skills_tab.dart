import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/models/scrivener_theme_tokens.dart';
import '../../../dice/presentation/widgets/floating_dice_fab.dart';
import '../../../dice/providers/dice_drawer_provider.dart';
import '../../providers/character_sheet_provider.dart';

class SkillMeta {
  final String name;
  final String abilityKey;

  const SkillMeta(this.name, this.abilityKey);
}

const List<SkillMeta> standardSkills = [
  SkillMeta('Acrobatics', 'dex'),
  SkillMeta('Animal Handling', 'wis'),
  SkillMeta('Arcana', 'int'),
  SkillMeta('Athletics', 'str'),
  SkillMeta('Deception', 'cha'),
  SkillMeta('History', 'int'),
  SkillMeta('Insight', 'wis'),
  SkillMeta('Intimidation', 'cha'),
  SkillMeta('Investigation', 'int'),
  SkillMeta('Medicine', 'wis'),
  SkillMeta('Nature', 'int'),
  SkillMeta('Perception', 'wis'),
  SkillMeta('Performance', 'cha'),
  SkillMeta('Persuasion', 'cha'),
  SkillMeta('Religion', 'int'),
  SkillMeta('Sleight of Hand', 'dex'),
  SkillMeta('Stealth', 'dex'),
  SkillMeta('Survival', 'wis'),
];

class SkillsTab extends ConsumerStatefulWidget {
  final CharacterSheetState state;
  final CharacterSheetNotifier notifier;

  const SkillsTab({
    super.key,
    required this.state,
    required this.notifier,
  });

  @override
  ConsumerState<SkillsTab> createState() => _SkillsTabState();
}

class _SkillsTabState extends ConsumerState<SkillsTab> {
  String _searchQuery = '';
  String _selectedAbilityFilter = 'ALL';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatModifier(int mod) {
    if (mod >= 0) {
      return '+$mod';
    }
    return '$mod';
  }

  void _rollSkillCheck(BuildContext context, String skillName, int bonus) {
    final diceNotifier = ref.read(diceDrawerProvider.notifier);
    diceNotifier.resetDrawer();
    diceNotifier.setDiceCount(20, 1);
    diceNotifier.setFlatModifier(bonus);
    diceNotifier.setRollTitle('${widget.state.name}: $skillName Check');
    FloatingDiceFab.openDiceRoller(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;
    final state = widget.state;
    final notifier = widget.notifier;

    final filteredSkills = standardSkills.where((skill) {
      if (_selectedAbilityFilter != 'ALL' &&
          skill.abilityKey.toLowerCase() != _selectedAbilityFilter.toLowerCase()) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !skill.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        // Search & Filter Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: theme.colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Input
              TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search skills (e.g. Perception, Athletics)...',
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(120), fontSize: 13),
                  prefixIcon: Icon(Icons.search, size: 20, color: theme.colorScheme.onSurface.withAlpha(140)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 18, color: theme.colorScheme.onSurface.withAlpha(140)),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.dividerColor.withAlpha(80)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.dividerColor.withAlpha(80)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Filter Chips Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'ALL',
                    'STR',
                    'DEX',
                    'INT',
                    'WIS',
                    'CHA',
                  ].map((filter) {
                    final isSelected = _selectedAbilityFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedAbilityFilter = filter;
                          });
                        },
                        selectedColor: theme.colorScheme.primary,
                        backgroundColor: theme.cardColor,
                        labelStyle: TextStyle(
                          color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface.withAlpha(180),
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? theme.colorScheme.primary : theme.dividerColor.withAlpha(80),
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Legend / Key
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: theme.cardColor,
          child: Row(
            children: [
              Text(
                'TAP ICON TO CYCLE:',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: theme.colorScheme.onSurface.withAlpha(140),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.radio_button_unchecked, size: 12, color: Colors.grey),
              const SizedBox(width: 2),
              const Text('None', style: TextStyle(fontSize: 10, color: Colors.grey)),
              const SizedBox(width: 8),
              Icon(Icons.star, size: 12, color: theme.colorScheme.primary),
              const SizedBox(width: 2),
              Text('Proficient',
                  style: TextStyle(fontSize: 10, color: theme.colorScheme.primary)),
              const SizedBox(width: 8),
              const Icon(Icons.stars, size: 12, color: Colors.amberAccent),
              const SizedBox(width: 2),
              const Text('Expertise',
                  style: TextStyle(fontSize: 10, color: Colors.amberAccent)),
              const Spacer(),
              Text(
                '${filteredSkills.length} Skills',
                style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withAlpha(140)),
              ),
            ],
          ),
        ),

        // Skills List
        Expanded(
          child: filteredSkills.isEmpty
              ? Center(
                  child: Text(
                    'No skills found matching "$_searchQuery"',
                    style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(140)),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: filteredSkills.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final skill = filteredSkills[index];
                    final profLevel = state.skillProficiencies[skill.name] ?? 0;
                    final abilityMod = state.getAbilityModifier(skill.abilityKey);
                    final bonus = state.getSkillBonus(skill.name, skill.abilityKey);
                    final bonusStr = _formatModifier(bonus);

                    // Proficiency Icon and Color
                    IconData profIcon;
                    Color profColor;
                    if (profLevel == 2) {
                      profIcon = Icons.stars;
                      profColor = Colors.amberAccent;
                    } else if (profLevel == 1) {
                      profIcon = Icons.star;
                      profColor = theme.colorScheme.primary;
                    } else {
                      profIcon = Icons.radio_button_unchecked;
                      profColor = Colors.grey;
                    }

                    // Calculation breakdown text
                    final profBonusAdded = profLevel * state.proficiencyBonus;
                    final breakdown = profBonusAdded > 0
                        ? '${skill.abilityKey.toUpperCase()} (${_formatModifier(abilityMod)}) + Prof (+$profBonusAdded)'
                        : '${skill.abilityKey.toUpperCase()} (${_formatModifier(abilityMod)})';

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: profLevel > 0
                              ? theme.colorScheme.primary.withAlpha(90)
                              : theme.dividerColor.withAlpha(80),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Proficiency Cycle Button
                          IconButton(
                            icon: Icon(profIcon, color: profColor, size: 22),
                            tooltip: 'Cycle proficiency (Normal / Proficient / Expertise)',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            onPressed: () => notifier.cycleSkillProficiency(skill.name),
                          ),
                          const SizedBox(width: 8),

                          // Skill Name and Governing Ability / Breakdown
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        skill.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: theme.dividerColor.withAlpha(80),
                                        ),
                                      ),
                                      child: Text(
                                        skill.abilityKey.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface.withAlpha(160),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  breakdown,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurface.withAlpha(140),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Bonus Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: profLevel > 0
                                  ? theme.colorScheme.primary.withAlpha(20)
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: profLevel > 0
                                    ? theme.colorScheme.primary
                                    : theme.dividerColor.withAlpha(80),
                              ),
                            ),
                            child: Text(
                              bonusStr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: profLevel > 0
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),

                          // Roll Button
                          ElevatedButton.icon(
                            onPressed: () => _rollSkillCheck(
                              context,
                              skill.name,
                              bonus,
                            ),
                            icon: Icon(tokens.iconography.diceAction, size: 14),
                            label: const Text('ROLL'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.surface,
                              foregroundColor: theme.colorScheme.primary,
                              side: BorderSide(
                                  color: theme.colorScheme.primary, width: 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

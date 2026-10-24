import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../dice/presentation/widgets/floating_dice_fab.dart';
import '../../../dice/providers/dice_drawer_provider.dart';
import '../../models/character_sheet_data.dart';
import '../../providers/character_sheet_provider.dart';

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
  String _selectedAbilityFilter = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatModifier(int mod) => mod >= 0 ? '+$mod' : '$mod';

  void _rollSkillCheck(
    BuildContext context,
    String skillName,
    int modifier,
  ) {
    ref.read(diceDrawerProvider.notifier).setContext(
      title: '${widget.state.name}: $skillName Check',
      diceCounts: {20: 1},
      flatModifier: modifier,
    );
    FloatingDiceFab.openDiceRoller(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final notifier = widget.notifier;

    // Filter skills
    final filteredSkills = standard5eSkills.where((skill) {
      if (_selectedAbilityFilter != 'ALL' &&
          skill.abilityKey.toUpperCase() != _selectedAbilityFilter) {
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
          color: AppTheme.surfaceDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Input
              TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search skills (e.g. Perception, Athletics)...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppTheme.cardDark,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF4A4037)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF4A4037)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.primaryGold),
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
                        selectedColor: AppTheme.primaryGold,
                        backgroundColor: AppTheme.cardDark,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryGold : const Color(0xFF4A4037),
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

        // Proficiency Legend
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: AppTheme.cardDark,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TAP ICON TO CYCLE:',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.radio_button_unchecked, size: 12, color: Colors.grey),
                  const SizedBox(width: 2),
                  const Text('None  ', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  const Icon(Icons.star, size: 12, color: AppTheme.primaryGold),
                  const SizedBox(width: 2),
                  Text('Prof (+${state.proficiencyBonus})  ',
                      style: const TextStyle(fontSize: 10, color: AppTheme.primaryGold)),
                  const Icon(Icons.stars, size: 12, color: Colors.amberAccent),
                  const SizedBox(width: 2),
                  Text('Expert (+${state.proficiencyBonus * 2})',
                      style: const TextStyle(fontSize: 10, color: Colors.amberAccent)),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFF4A4037)),

        // Skills List
        Expanded(
          child: filteredSkills.isEmpty
              ? const Center(
                  child: Text(
                    'No matching skills found',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredSkills.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
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
                      profColor = AppTheme.primaryGold;
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
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: profLevel > 0
                              ? AppTheme.primaryGold.withAlpha(90)
                              : const Color(0xFF4A4037),
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
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceDark,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: const Color(0xFF4A4037),
                                        ),
                                      ),
                                      child: Text(
                                        skill.abilityKey.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade400,
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
                                    color: Colors.grey.shade500,
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
                                  ? AppTheme.primaryGold.withAlpha(20)
                                  : AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: profLevel > 0
                                    ? AppTheme.primaryGold
                                    : const Color(0xFF4A4037),
                              ),
                            ),
                            child: Text(
                              bonusStr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: profLevel > 0
                                    ? AppTheme.primaryGold
                                    : Colors.white,
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
                            icon: const Icon(Icons.casino_outlined, size: 14),
                            label: const Text('ROLL'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.surfaceDark,
                              foregroundColor: AppTheme.primaryGold,
                              side: const BorderSide(
                                  color: AppTheme.primaryGold, width: 1),
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

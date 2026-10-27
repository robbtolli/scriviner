import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/srd_starter_data.dart';
import '../../models/wizard_draft.dart';
import '../../providers/wizard_provider.dart';

class Step2Race extends ConsumerStatefulWidget {
  const Step2Race({super.key});

  @override
  ConsumerState<Step2Race> createState() => _Step2RaceState();
}

class _Step2RaceState extends ConsumerState<Step2Race> {
  bool _expandedSectionOpen = false;

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(characterWizardProvider);
    final notifier = ref.read(characterWizardProvider.notifier);

    // Auto-open expanded section if an expanded race is selected
    final isSelectedExpanded = draft.race?.isExpanded ?? false;
    final isSectionOpen = _expandedSectionOpen || isSelectedExpanded;

    final coreRaces = SrdStarterData.races.where((r) => !r.isExpanded).toList();
    final expandedRaces = SrdStarterData.races
        .where((r) => r.isExpanded)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2: Choose Race & Lineage',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your race grants innate ability score bonuses, walking speed, and special heroic traits.',
            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14),
          ),
          const SizedBox(height: 20),

          // Core Races
          ...coreRaces.map(
            (race) => _buildRaceCard(context, race, draft, notifier),
          ),

          const SizedBox(height: 12),

          // Collapsible "Expanded Races" Section
          InkWell(
            onTap: () {
              setState(() {
                _expandedSectionOpen = !isSectionOpen;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelectedExpanded
                      ? AppTheme.primaryGold
                      : Colors.white.withAlpha(25),
                  width: isSelectedExpanded ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppTheme.primaryGold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            const Text(
                              'Expanded Races',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceDark,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${expandedRaces.length} available',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryGold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tabaxi, Genasi, Tortle, Firbolg, Changeling, Goblin, Kobold',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withAlpha(150),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSectionOpen ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.primaryGold,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          if (isSectionOpen) ...[
            const SizedBox(height: 12),
            ...expandedRaces.map(
              (race) => _buildRaceCard(context, race, draft, notifier),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRaceCard(
    BuildContext context,
    RaceDefinition race,
    WizardDraft draft,
    CharacterWizardNotifier notifier,
  ) {
    final isSelected = draft.race?.id == race.id;

    // Calculate dynamic bonuses reflecting subrace when selected
    final bonuses = Map<String, int>.from(race.abilityBonuses);
    if (isSelected && draft.subrace != null) {
      draft.subrace!.abilityBonuses.forEach((stat, val) {
        bonuses[stat] = (bonuses[stat] ?? 0) + val;
      });
    }

    final displaySpeed = (isSelected && draft.subrace?.speed != null)
        ? draft.subrace!.speed!
        : race.speed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => notifier.setRace(race),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryGold.withAlpha(25)
                : AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryGold
                  : Colors.white.withAlpha(20),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                isSelected && draft.subrace != null
                                    ? '${race.name} (${draft.subrace!.name})'
                                    : race.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? AppTheme.primaryGold
                                      : Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.primaryGold,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (bonuses.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: bonuses.entries.map((entry) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceDark,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppTheme.primaryGold.withAlpha(100),
                                ),
                              ),
                              child: Text(
                                '+${entry.value} ${entry.key}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryGold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    race.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withAlpha(190),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.directions_run,
                        size: 14,
                        color: Colors.white.withAlpha(160),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Speed: $displaySpeed ft',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(160),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Icon(
                        Icons.star_border,
                        size: 14,
                        color: Colors.white.withAlpha(160),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Traits: ${race.traits.join(" • ")}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withAlpha(160),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Inline Subrace Selector (displayed when selected and has subraces)
                  if (isSelected && race.subraces.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark.withAlpha(180),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.primaryGold.withAlpha(60),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.alt_route,
                                size: 14,
                                color: AppTheme.primaryGold,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'CHOOSE SUBRACE / LINEAGE (OPTIONAL)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                  color: AppTheme.primaryGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildSubraceChip(
                                label: 'Base / Standard',
                                isSelected: draft.subrace == null,
                                onTap: () => notifier.setSubrace(null),
                              ),
                              ...race.subraces.map((sub) {
                                final isSubSelected =
                                    draft.subrace?.id == sub.id;
                                final bonusDesc = sub.abilityBonuses.entries
                                    .map((e) => '+${e.value} ${e.key}')
                                    .join(', ');
                                final label = bonusDesc.isNotEmpty
                                    ? '${sub.name} ($bonusDesc)'
                                    : sub.name;

                                return _buildSubraceChip(
                                  label: label,
                                  isSelected: isSubSelected,
                                  onTap: () => notifier.setSubrace(sub),
                                );
                              }),
                            ],
                          ),
                          if (draft.subrace != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.cardDark,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.white.withAlpha(15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    draft.subrace!.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withAlpha(190),
                                      height: 1.3,
                                    ),
                                  ),
                                  if (draft.subrace!.traits.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      'Extra Traits: ${draft.subrace!.traits.join(" • ")}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryGold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubraceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryGold.withAlpha(35)
              : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryGold
                : Colors.white.withAlpha(30),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppTheme.primaryGold : Colors.white,
          ),
        ),
      ),
    );
  }
}

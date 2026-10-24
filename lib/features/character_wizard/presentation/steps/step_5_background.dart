import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/srd_starter_data.dart';
import '../../providers/wizard_provider.dart';

class Step5Background extends ConsumerWidget {
  const Step5Background({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(characterWizardProvider);
    final notifier = ref.read(characterWizardProvider.notifier);

    final requiredSkills = draft.charClass?.skillCount ?? 2;
    final availableSkills = draft.charClass?.availableSkills ?? const [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 5: Background & Skills',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your background reveals what your character did before becoming an adventurer.',
            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14),
          ),
          const SizedBox(height: 20),
          const Text(
            'CHOOSE BACKGROUND',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 10),
          ...SrdStarterData.backgrounds.map((bg) {
            final isSelected = draft.background?.id == bg.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => notifier.setBackground(bg),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryGold.withAlpha(25) : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(20),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bg.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isSelected ? AppTheme.primaryGold : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Grants skills: ${bg.grantedSkills.join(", ")}',
                              style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(180)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Feature: ${bg.featureName} - ${bg.featureDescription}',
                              style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(140)),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppTheme.primaryGold, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'CLASS SKILLS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppTheme.primaryGold,
                ),
              ),
              const Spacer(),
              Text(
                'Selected: ${draft.selectedSkills.length} of $requiredSkills',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: draft.selectedSkills.length == requiredSkills
                      ? Colors.greenAccent
                      : AppTheme.primaryGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Select $requiredSkills skills from your ${draft.charClass?.name ?? "class"} training:',
            style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 13),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableSkills.map((skill) {
              final isGrantedByBg = draft.background?.grantedSkills.contains(skill) ?? false;
              final isSelected = draft.selectedSkills.contains(skill);

              return FilterChip(
                label: Text(
                  isGrantedByBg ? '$skill (Background)' : skill,
                  style: TextStyle(
                    color: isGrantedByBg
                        ? Colors.grey
                        : isSelected
                            ? Colors.black
                            : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selected: isSelected || isGrantedByBg,
                selectedColor: isGrantedByBg ? Colors.white.withAlpha(40) : AppTheme.primaryGold,
                backgroundColor: AppTheme.cardDark,
                onSelected: isGrantedByBg
                    ? null
                    : (_) {
                        notifier.toggleSkill(skill);
                      },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

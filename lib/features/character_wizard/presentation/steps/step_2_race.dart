import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/srd_starter_data.dart';
import '../../providers/wizard_provider.dart';

class Step2Race extends ConsumerWidget {
  const Step2Race({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(characterWizardProvider);
    final notifier = ref.read(characterWizardProvider.notifier);

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
          ...SrdStarterData.races.map((race) {
            final isSelected = draft.race?.id == race.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => notifier.setRace(race),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryGold.withAlpha(25) : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(20),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            race.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppTheme.primaryGold : Colors.white,
                            ),
                          ),
                          const Spacer(),
                          // Ability score bonus badges
                          ...race.abilityBonuses.entries.map((entry) {
                            return Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceDark,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppTheme.primaryGold.withAlpha(100)),
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
                          }),
                          const SizedBox(width: 8),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppTheme.primaryGold, size: 20),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        race.description,
                        style: TextStyle(fontSize: 13, color: Colors.white.withAlpha(190), height: 1.3),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.directions_run, size: 14, color: Colors.white.withAlpha(160)),
                          const SizedBox(width: 4),
                          Text(
                            'Speed: ${race.speed} ft',
                            style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                          ),
                          const SizedBox(width: 14),
                          Icon(Icons.star_border, size: 14, color: Colors.white.withAlpha(160)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Traits: ${race.traits.join(" • ")}',
                              style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

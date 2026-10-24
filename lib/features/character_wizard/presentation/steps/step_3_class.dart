import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/srd_starter_data.dart';
import '../../providers/wizard_provider.dart';

class Step3Class extends ConsumerWidget {
  const Step3Class({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(characterWizardProvider);
    final notifier = ref.read(characterWizardProvider.notifier);

    // If an archetype was selected in Step 1, highlight those classes first
    final classes = SrdStarterData.classes;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3: Choose Class',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your class is the foundation of your abilities, skills, and combat role.',
            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14),
          ),
          const SizedBox(height: 20),
          ...classes.map((cls) {
            final isSelected = draft.charClass?.id == cls.id;
            final matchesArchetype = draft.archetype == null || draft.archetype == cls.archetype;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Opacity(
                opacity: matchesArchetype ? 1.0 : 0.6,
                child: InkWell(
                  onTap: () => notifier.setClass(cls),
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
                              cls.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppTheme.primaryGold : Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceDark,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Hit Die: 1d${cls.hitDie}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryGold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: AppTheme.primaryGold, size: 20),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cls.description,
                          style: TextStyle(fontSize: 13, color: Colors.white.withAlpha(190), height: 1.3),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Primary: ${cls.primaryAbility}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amberAccent),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              'Saves: ${cls.savingThrows.join(", ")}',
                              style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                            ),
                            const Spacer(),
                            if (cls.isSpellcaster)
                              const Text(
                                '✨ Spellcaster',
                                style: TextStyle(fontSize: 12, color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Level 1 Features: ${cls.startingFeatures.join(" • ")}',
                          style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(140)),
                        ),
                      ],
                    ),
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

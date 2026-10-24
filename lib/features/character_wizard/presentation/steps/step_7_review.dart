import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/wizard_provider.dart';

class Step7Review extends ConsumerWidget {
  final VoidCallback onComplete;

  const Step7Review({
    super.key,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(characterWizardProvider);

    final checks = [
      ('Character Name', draft.name.trim().isNotEmpty, draft.name),
      ('Race & Heritage', draft.race != null, draft.race?.name ?? 'Not chosen'),
      ('Heroic Class', draft.charClass != null, draft.charClass?.name ?? 'Not chosen'),
      (
        'Ability Scores',
        true,
        draft.finalAbilities.entries.map((e) => '${e.key}: ${e.value}').join(', ')
      ),
      ('Background & Origin', draft.background != null, draft.background?.name ?? 'Not chosen'),
      ('Skill Proficiencies', draft.allProficientSkills.isNotEmpty, draft.allProficientSkills.join(', ')),
      ('Starting Equipment', true, draft.equipmentPackage),
      if (draft.charClass?.isSpellcaster == true)
        ('Prepared Spells', draft.selectedSpells.isNotEmpty, '${draft.selectedSpells.length} spells chosen'),
    ];

    final isAllValid = checks.every((c) => c.$2);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 7: Review & Embark',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your hero is ready for the chronicle. Review your choices below before setting out.',
            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14),
          ),
          const SizedBox(height: 20),
          ...checks.map((check) {
            final label = check.$1;
            final isOk = check.$2;
            final detail = check.$3;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isOk ? Colors.white.withAlpha(20) : Colors.redAccent.withAlpha(120),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isOk ? Icons.check_circle : Icons.error_outline,
                    color: isOk ? Colors.greenAccent : Colors.redAccent,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          detail,
                          style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(160)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 28),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isAllValid ? onComplete : null,
                  icon: const Icon(Icons.explore),
                  label: const Text('EMBARK ON ADVENTURE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

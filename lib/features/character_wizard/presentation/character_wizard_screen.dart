import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/wizard_provider.dart';
import 'steps/step_1_concept.dart';
import 'steps/step_2_race.dart';
import 'steps/step_3_class.dart';
import 'steps/step_4_abilities.dart';
import 'steps/step_5_background.dart';
import 'steps/step_6_equipment_spells.dart';
import 'steps/step_7_review.dart';
import 'widgets/live_sheet_preview.dart';

class CharacterWizardScreen extends ConsumerWidget {
  final void Function(String characterId)? onCharacterCreated;

  const CharacterWizardScreen({
    super.key,
    this.onCharacterCreated,
  });

  static const List<String> _stepTitles = [
    'Concept & Identity',
    'Race & Heritage',
    'Heroic Class',
    'Ability Scores',
    'Background & Skills',
    'Equipment & Magic',
    'Review & Embark',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(characterWizardProvider);
    final notifier = ref.read(characterWizardProvider.notifier);

    final currentStep = draft.currentStep;
    final progress = (currentStep + 1) / _stepTitles.length;

    void handleNext() {
      final (isValid, errorMsg) = draft.validateStep(currentStep);
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg ?? 'Please complete this step to continue.'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      notifier.nextStep();
    }

    void handleComplete() async {
      final db = ref.read(databaseProvider);
      final charId = await notifier.saveCharacter(db);
      notifier.reset();
      if (context.mounted) {
        Navigator.of(context).pop();
        if (onCharacterCreated != null) {
          onCharacterCreated!(charId);
        }
      }
    }

    Widget stepWidget;
    switch (currentStep) {
      case 0:
        stepWidget = const Step1Concept();
        break;
      case 1:
        stepWidget = const Step2Race();
        break;
      case 2:
        stepWidget = const Step3Class();
        break;
      case 3:
        stepWidget = const Step4Abilities();
        break;
      case 4:
        stepWidget = const Step5Background();
        break;
      case 5:
        stepWidget = const Step6EquipmentSpells();
        break;
      case 6:
        stepWidget = Step7Review(onComplete: handleComplete);
        break;
      default:
        stepWidget = const Step1Concept();
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          notifier.reset();
        }
      },
      child: Scaffold(
        appBar: AppBar(
        title: Text(
          'Step ${currentStep + 1} of 7: ${_stepTitles[currentStep]}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withAlpha(20),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGold),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;

          if (isWide) {
            // Split-view on Desktop and Tablet
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: stepWidget,
                ),
                VerticalDivider(width: 1, color: Colors.white.withAlpha(20)),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LIVE CHARACTER PREVIEW',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LiveSheetPreview(draft: draft),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Mobile Single-column
            return stepWidget;
          }
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: Colors.white.withAlpha(20))),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                if (currentStep > 0)
                  OutlinedButton.icon(
                    onPressed: () => notifier.previousStep(),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('BACK'),
                  )
                else
                  TextButton(
                    onPressed: () {
                      notifier.reset();
                      Navigator.of(context).pop();
                    },
                    child: const Text('CANCEL'),
                  ),
                const Spacer(),
                if (currentStep < 6)
                  ElevatedButton.icon(
                    onPressed: handleNext,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('NEXT STEP'),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

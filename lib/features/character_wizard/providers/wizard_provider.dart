import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/dice/dice_roller.dart';
import '../models/srd_starter_data.dart';
import '../models/wizard_draft.dart';

class CharacterWizardNotifier extends Notifier<WizardDraft> {
  final DiceRoller _diceRoller;

  CharacterWizardNotifier([DiceRoller? diceRoller])
    : _diceRoller = diceRoller ?? DiceRoller();

  @override
  WizardDraft build() => const WizardDraft();

  void reset() {
    state = const WizardDraft();
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setGender(String? gender) {
    state = state.copyWith(gender: gender);
  }

  void setArchetype(PlaystyleArchetype? archetype) {
    state = state.copyWith(archetype: archetype);
  }

  void setRace(RaceDefinition race) {
    state = state.copyWith(race: race);
  }

  void setClass(ClassDefinition charClass) {
    state = state.copyWith(charClass: charClass);
    // Auto-assign recommended standard array scores for this class
    autoAssignStandardArrayForClass(charClass);
  }

  void setAbilityMethod(AbilityGenMethod method) {
    if (method == AbilityGenMethod.pointBuy) {
      // Default point buy to 8s
      state = state.copyWith(
        abilityMethod: method,
        baseAbilities: {
          'STR': 8,
          'DEX': 8,
          'CON': 8,
          'INT': 8,
          'WIS': 8,
          'CHA': 8,
        },
      );
    } else if (method == AbilityGenMethod.standardArray) {
      state = state.copyWith(abilityMethod: method);
      if (state.charClass != null) {
        autoAssignStandardArrayForClass(state.charClass!);
      }
    } else {
      state = state.copyWith(abilityMethod: method);
      rollStats();
    }
  }

  /// Automatically maps the standard array [15, 14, 13, 12, 10, 8]
  /// to the most optimal stats for the selected class.
  void autoAssignStandardArrayForClass(ClassDefinition charClass) {
    final Map<String, int> assigned;

    switch (charClass.id) {
      case 'fighter':
      case 'barbarian':
      case 'paladin':
        assigned = {
          'STR': 15,
          'CON': 14,
          'DEX': 13,
          'WIS': 12,
          'CHA': 10,
          'INT': 8,
        };
        break;
      case 'rogue':
        assigned = {
          'DEX': 15,
          'CON': 14,
          'INT': 13,
          'WIS': 12,
          'CHA': 10,
          'STR': 8,
        };
        break;
      case 'wizard':
        assigned = {
          'INT': 15,
          'CON': 14,
          'DEX': 13,
          'WIS': 12,
          'CHA': 10,
          'STR': 8,
        };
        break;
      case 'cleric':
        assigned = {
          'WIS': 15,
          'CON': 14,
          'STR': 13,
          'DEX': 12,
          'CHA': 10,
          'INT': 8,
        };
        break;
      case 'bard':
        assigned = {
          'CHA': 15,
          'DEX': 14,
          'CON': 13,
          'WIS': 12,
          'INT': 10,
          'STR': 8,
        };
        break;
      case 'ranger':
        assigned = {
          'DEX': 15,
          'WIS': 14,
          'CON': 13,
          'STR': 12,
          'INT': 10,
          'CHA': 8,
        };
        break;
      case 'sorcerer':
        assigned = {
          'CHA': 15,
          'CON': 14,
          'DEX': 13,
          'WIS': 12,
          'INT': 10,
          'STR': 8,
        };
        break;
      case 'druid':
        assigned = {
          'WIS': 15,
          'CON': 14,
          'DEX': 13,
          'INT': 12,
          'STR': 10,
          'CHA': 8,
        };
        break;
      default:
        assigned = {
          'STR': 15,
          'CON': 14,
          'DEX': 13,
          'WIS': 12,
          'CHA': 10,
          'INT': 8,
        };
    }

    state = state.copyWith(baseAbilities: assigned);
  }

  void setAbilityScore(String stat, int score) {
    final updated = Map<String, int>.from(state.baseAbilities);
    updated[stat] = score;
    state = state.copyWith(baseAbilities: updated);
  }

  void rollStats() {
    final rolled = <int>[];
    for (int i = 0; i < 6; i++) {
      final res = _diceRoller.rollFormula('4d6kh3');
      rolled.add(res.total);
    }
    rolled.sort((a, b) => b.compareTo(a)); // Sort descending

    // Auto-map highest rolled values if class is chosen
    final abilities = Map<String, int>.from(state.baseAbilities);
    final stats = ['STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA'];
    for (int i = 0; i < 6; i++) {
      abilities[stats[i]] = rolled[i];
    }

    state = state.copyWith(rolledPool: rolled, baseAbilities: abilities);
  }

  void setBackground(BackgroundDefinition background) {
    // If background skills conflict with selectedSkills, clean them up
    final cleanedSkills = Set<String>.from(state.selectedSkills)
      ..removeWhere((s) => background.grantedSkills.contains(s));

    state = state.copyWith(
      background: background,
      selectedSkills: cleanedSkills,
    );
  }

  void toggleSkill(String skill) {
    final current = Set<String>.from(state.selectedSkills);
    if (current.contains(skill)) {
      current.remove(skill);
    } else {
      final maxAllowed = state.charClass?.skillCount ?? 2;
      if (current.length < maxAllowed) {
        current.add(skill);
      }
    }
    state = state.copyWith(selectedSkills: current);
  }

  void toggleSpell(String spellId) {
    final current = Set<String>.from(state.selectedSpells);
    if (current.contains(spellId)) {
      current.remove(spellId);
    } else {
      current.add(spellId);
    }
    state = state.copyWith(selectedSpells: current);
  }

  void setEquipmentPackage(String package) {
    state = state.copyWith(equipmentPackage: package);
  }

  bool nextStep() {
    final (isValid, _) = state.validateStep(state.currentStep);
    if (!isValid) return false;
    if (state.currentStep < 6) {
      state = state.copyWith(currentStep: state.currentStep + 1);
      return true;
    }
    return false;
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 6) {
      state = state.copyWith(currentStep: step);
    }
  }

  /// Saves the completed character to the database and returns the character ID.
  Future<String> saveCharacter(AppDatabase db) async {
    final companion = state.toCharacterCompanion();
    await db.upsertCharacter(companion);
    return companion.id.value;
  }
}

final characterWizardProvider =
    NotifierProvider<CharacterWizardNotifier, WizardDraft>(
      CharacterWizardNotifier.new,
    );

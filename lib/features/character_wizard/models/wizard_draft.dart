import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import 'srd_starter_data.dart';

enum AbilityGenMethod {
  standardArray(
    'Standard Array',
    'Balanced and beginner-friendly: 15, 14, 13, 12, 10, 8.',
  ),
  pointBuy('Point Buy', 'Spend 27 points to customize your ability scores.'),
  rolled(
    'Roll Stats (4d6kh3)',
    'Roll 4d6 and keep the highest 3 dice for each stat.',
  );

  final String title;
  final String description;
  const AbilityGenMethod(this.title, this.description);
}

class WizardDraft {
  final int currentStep;
  final String name;
  final String? gender;
  final PlaystyleArchetype? archetype;
  final RaceDefinition? race;
  final SubraceDefinition? subrace;
  final ClassDefinition? charClass;
  final AbilityGenMethod abilityMethod;
  final Map<String, int> baseAbilities;
  final List<int> rolledPool;
  final BackgroundDefinition? background;
  final Set<String> selectedSkills;
  final Set<String> selectedSpells;
  final String equipmentPackage;

  const WizardDraft({
    this.currentStep = 0,
    this.name = '',
    this.gender,
    this.archetype,
    this.race,
    this.subrace,
    this.charClass,
    this.abilityMethod = AbilityGenMethod.standardArray,
    this.baseAbilities = const {
      'STR': 10,
      'DEX': 10,
      'CON': 10,
      'INT': 10,
      'WIS': 10,
      'CHA': 10,
    },
    this.rolledPool = const [],
    this.background,
    this.selectedSkills = const {},
    this.selectedSpells = const {},
    this.equipmentPackage = 'Standard Explorer Package',
  });

  WizardDraft copyWith({
    int? currentStep,
    String? name,
    String? gender,
    PlaystyleArchetype? archetype,
    RaceDefinition? race,
    SubraceDefinition? subrace,
    bool clearSubrace = false,
    ClassDefinition? charClass,
    AbilityGenMethod? abilityMethod,
    Map<String, int>? baseAbilities,
    List<int>? rolledPool,
    BackgroundDefinition? background,
    Set<String>? selectedSkills,
    Set<String>? selectedSpells,
    String? equipmentPackage,
  }) {
    return WizardDraft(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      archetype: archetype ?? this.archetype,
      race: race ?? this.race,
      subrace: clearSubrace ? null : (subrace ?? this.subrace),
      charClass: charClass ?? this.charClass,
      abilityMethod: abilityMethod ?? this.abilityMethod,
      baseAbilities: baseAbilities ?? this.baseAbilities,
      rolledPool: rolledPool ?? this.rolledPool,
      background: background ?? this.background,
      selectedSkills: selectedSkills ?? this.selectedSkills,
      selectedSpells: selectedSpells ?? this.selectedSpells,
      equipmentPackage: equipmentPackage ?? this.equipmentPackage,
    );
  }

  /// Calculates final scores including racial and subracial bonuses.
  Map<String, int> get finalAbilities {
    final result = Map<String, int>.from(baseAbilities);
    if (race != null) {
      race!.abilityBonuses.forEach((stat, bonus) {
        result[stat] = (result[stat] ?? 10) + bonus;
      });
      if (subrace != null) {
        subrace!.abilityBonuses.forEach((stat, bonus) {
          result[stat] = (result[stat] ?? 10) + bonus;
        });
      }
    }
    return result;
  }

  /// Calculates ability modifiers: floor((score - 10) / 2)
  Map<String, int> get abilityModifiers {
    return finalAbilities.map(
      (stat, score) => MapEntry(stat, ((score - 10) / 2).floor()),
    );
  }

  int get proficiencyBonus => 2; // Level 1 standard

  int get maxHp {
    final conMod = abilityModifiers['CON'] ?? 0;
    final hitDie = charClass?.hitDie ?? 8;
    return (hitDie + conMod).clamp(1, 999);
  }

  int get armorClass {
    final dexMod = abilityModifiers['DEX'] ?? 0;
    if (race?.id == 'tortle') {
      return 17; // Tortle Natural Armor: base AC 17
    }
    if (charClass?.id == 'barbarian') {
      final conMod = abilityModifiers['CON'] ?? 0;
      return 10 + dexMod + conMod;
    }
    return 10 + dexMod;
  }

  int get speed => subrace?.speed ?? race?.speed ?? 30;

  int get passivePerception {
    final wisMod = abilityModifiers['WIS'] ?? 0;
    final isProficient = allProficientSkills.contains('Perception');
    return 10 + wisMod + (isProficient ? proficiencyBonus : 0);
  }

  Set<String> get allProficientSkills {
    final combined = <String>{};
    if (background != null) {
      combined.addAll(background!.grantedSkills);
    }
    combined.addAll(selectedSkills);
    return combined;
  }

  /// Point buy cost calculator: 8->0, 9->1, ..., 14->7, 15->9
  static int getPointBuyCost(int score) {
    if (score <= 8) return 0;
    if (score == 9) return 1;
    if (score == 10) return 2;
    if (score == 11) return 3;
    if (score == 12) return 4;
    if (score == 13) return 5;
    if (score == 14) return 7;
    if (score >= 15) return 9;
    return 0;
  }

  int get remainingPointBuyPoints {
    var spent = 0;
    for (final score in baseAbilities.values) {
      spent += getPointBuyCost(score);
    }
    return 27 - spent;
  }

  /// Validates the current step before advancing.
  (bool, String?) validateStep(int step) {
    switch (step) {
      case 0:
        if (name.trim().isEmpty) {
          return (false, 'Please give your character a name.');
        }
        return (true, null);
      case 1:
        if (race == null) return (false, 'Please choose a race.');
        return (true, null);
      case 2:
        if (charClass == null) return (false, 'Please choose a class.');
        return (true, null);
      case 3:
        if (abilityMethod == AbilityGenMethod.pointBuy &&
            remainingPointBuyPoints < 0) {
          return (false, 'You have exceeded the 27 point buy limit.');
        }
        return (true, null);
      case 4:
        if (background == null) return (false, 'Please choose a background.');
        final requiredSkillCount = charClass?.skillCount ?? 2;
        if (selectedSkills.length < requiredSkillCount) {
          return (
            false,
            'Please select $requiredSkillCount class skills (selected ${selectedSkills.length}).',
          );
        }
        return (true, null);
      case 5:
        if (charClass != null && charClass!.isSpellcaster) {
          if (selectedSpells.isEmpty) {
            return (false, 'Please choose at least one spell or cantrip.');
          }
        }
        return (true, null);
      case 6:
        return (true, null);
      default:
        return (true, null);
    }
  }

  /// Converts the wizard draft into a Drift database companion.
  CharactersTableCompanion toCharacterCompanion() {
    final now = DateTime.now();
    final charId = const Uuid().v4();

    final rawProps = {
      'level': 1,
      'gender': gender,
      'class': charClass?.name ?? 'Adventurer',
      'classId': charClass?.id ?? 'fighter',
      'race': subrace != null
          ? '${race?.name} (${subrace!.name})'
          : (race?.name ?? 'Human'),
      'raceId': race?.id ?? 'human',
      'subraceId': subrace?.id,
      'traits': [...?race?.traits, ...?subrace?.traits],
      'background': background?.name ?? 'Folk Hero',
      'hp': {'current': maxHp, 'max': maxHp, 'temp': 0},
      'armorClass': armorClass,
      'speed': speed,
      'proficiencyBonus': proficiencyBonus,
      'abilities': finalAbilities.map(
        (stat, score) => MapEntry(stat.toLowerCase(), {
          'score': score,
          'mod': abilityModifiers[stat] ?? 0,
        }),
      ),
      'savingThrows': (charClass?.savingThrows ?? [])
          .map((e) => e.toLowerCase())
          .toList(),
      'skills': allProficientSkills.toList(),
      'skillProficiencies': {for (final s in allProficientSkills) s: 1},
      'spells': selectedSpells.map((spellName) {
        final found = SrdStarterData.spells.cast<SpellDefinition?>().firstWhere(
          (s) =>
              s?.name.toLowerCase() == spellName.toLowerCase() ||
              s?.id.toLowerCase() == spellName.toLowerCase(),
          orElse: () => null,
        );
        return {
          'id':
              'spell_${(found?.id ?? spellName).toLowerCase().replaceAll(' ', '_')}',
          'name': found?.name ?? spellName,
          'level': found?.level ?? 0,
          'school': found?.school ?? 'Evocation',
          'castingTime': found?.castingTime ?? '1 action',
          'range': found?.range ?? 'Touch',
          'components': 'V, S',
          'duration': 'Instantaneous',
          'isPrepared': true,
          'isRitual': false,
          'description': found?.description ?? '',
        };
      }).toList(),
      'featuresList': (charClass?.startingFeatures ?? []).map((featName) {
        return {
          'id': 'feat_${featName.toLowerCase().replaceAll(' ', '_')}',
          'name': featName,
          'source': charClass?.name ?? 'Class',
          'recharge': 'Short or Long Rest',
          'usesMax': 1,
          'usesSpent': 0,
          'description': '$featName granted by ${charClass?.name}',
        };
      }).toList(),
      'hitDice': {'total': 1, 'spent': 0, 'die': '1d${charClass?.hitDie ?? 8}'},
      'spellSlots': charClass?.isSpellcaster == true
          ? {
              '1': {'total': 2, 'spent': 0},
            }
          : {},
      'equipment': [equipmentPackage],
    };

    return CharactersTableCompanion.insert(
      id: charId,
      systemId: const Value('dnd5e'),
      name: name.trim(),
      portraitUri: Value(null),
      createdAt: now,
      lastPlayedAt: now,
      rawPropertiesJson: jsonEncode(rawProps),
      notes: const Value('Created via Guided Character Wizard'),
    );
  }
}

# Authoring TTRPG Systems & Rulesets

While Scrivener ships out-of-the-box with full support for Dungeons & Dragons 5e / 2024 SRD, the core calculation engine was engineered from the beginning to be **ruleset agnostic**. 

This document explains how Scrivener abstracts tabletop systems via the `GameSystem` contract and how developers can implement support for Pathfinder 2e, Shadowdark, Call of Cthulhu, or custom homebrew mechanics.

---

## 1. The `GameSystem` Contract

Every tabletop ruleset in Scrivener implements the abstract interface `GameSystem` (`lib/systems/system_contract.dart`):

```dart
abstract class GameSystem {
  String get systemId;
  String get name;
  String get version;

  /// Resolves raw character properties into final computed properties using system rules.
  ResolvedCharacterState resolveCharacterProperties({
    required Map<String, dynamic> rawProperties,
    required List<Modifier> activeModifiers,
  });

  /// Calculates proficiency bonus or level-based progression bonus.
  int calculateProficiencyBonus(int level);

  /// Computes ability modifier from a raw score.
  int calculateAbilityModifier(int score);
}
```

---

## 2. Implementing D&D 5e / 2024 as Reference

Let's inspect how D&D 5e is implemented in `Dnd5eSystem` (`lib/systems/dnd5e/dnd5e_system.dart`):

```dart
class Dnd5eSystem implements GameSystem {
  const Dnd5eSystem();

  @override
  String get systemId => 'dnd5e';

  @override
  String get name => 'Dungeons & Dragons 5e / 2024';

  @override
  String get version => '5.1-SRD';

  @override
  int calculateProficiencyBonus(int level) {
    if (level < 1) return 2;
    return 2 + ((level - 1) / 4).floor();
  }

  @override
  int calculateAbilityModifier(int score) {
    return ((score - 10) / 2).floor();
  }

  @override
  ResolvedCharacterState resolveCharacterProperties({
    required Map<String, dynamic> rawProperties,
    required List<Modifier> activeModifiers,
  }) {
    final base = <String, dynamic>{};
    final level = rawProperties['level'] as int? ?? 1;
    base['level'] = level;
    base['attributes.proficiency_bonus'] = calculateProficiencyBonus(level);

    // Extract raw abilities
    final rawAbilities = rawProperties['abilities'] as Map<String, dynamic>? ?? {};
    final stats = ['str', 'dex', 'con', 'int', 'wis', 'cha'];

    for (final stat in stats) {
      final statData = rawAbilities[stat];
      int score = 10;
      if (statData is Map) {
        score = (statData['score'] as num?)?.toInt() ?? 10;
      } else if (statData is num) {
        score = statData.toInt();
      }
      base['abilities.$stat.score'] = score;
    }

    // Formulas for standard 5e derived statistics
    final formulas = <String, String>{
      'abilities.str.mod': 'floor((@abilities.str.score - 10) / 2)',
      'abilities.dex.mod': 'floor((@abilities.dex.score - 10) / 2)',
      'abilities.con.mod': 'floor((@abilities.con.score - 10) / 2)',
      'abilities.int.mod': 'floor((@abilities.int.score - 10) / 2)',
      'abilities.wis.mod': 'floor((@abilities.wis.score - 10) / 2)',
      'abilities.cha.mod': 'floor((@abilities.cha.score - 10) / 2)',
      'attributes.initiative': '@abilities.dex.mod',
      'attributes.ac': '10 + @abilities.dex.mod',
      'attributes.passive_perception': '10 + @abilities.wis.mod',
    };

    return PropertyPipeline.resolve(
      baseProperties: base,
      modifiers: activeModifiers,
      formulaRules: formulas,
    );
  }
}
```

---

## 3. Implementing a New System: Pathfinder 2e (Example)

Pathfinder 2e uses a proficiency system scaling by level plus training rank (Untrained = +0, Trained = Level + 2, Expert = Level + 4, Master = Level + 6, Legendary = Level + 8).

Here is how a `Pathfinder2eSystem` contract is implemented:

```dart
class Pathfinder2eSystem implements GameSystem {
  const Pathfinder2eSystem();

  @override
  String get systemId => 'pf2e';

  @override
  String get name => 'Pathfinder 2e (Remaster)';

  @override
  String get version => 'Remaster-ORC';

  @override
  int calculateProficiencyBonus(int level) {
    // In PF2e, proficiency bonuses are tied to training rank + level
    return level;
  }

  @override
  int calculateAbilityModifier(int score) {
    // Pathfinder 2e Remaster uses direct ability modifiers (+1, +2, etc.)
    return ((score - 10) / 2).floor();
  }

  @override
  ResolvedCharacterState resolveCharacterProperties({
    required Map<String, dynamic> rawProperties,
    required List<Modifier> activeModifiers,
  }) {
    final base = <String, dynamic>{};
    final level = rawProperties['level'] as int? ?? 1;
    base['level'] = level;

    // Formulas for PF2e DC and perception
    final formulas = <String, String>{
      'attributes.perception_dc': '10 + @skills.perception.bonus',
      'attributes.class_dc': '10 + @level + @key_ability.mod',
      'attributes.ac': '10 + @attributes.dex_cap + @armor.ac_bonus',
    };

    return PropertyPipeline.resolve(
      baseProperties: base,
      modifiers: activeModifiers,
      formulaRules: formulas,
    );
  }
}
```

---

## 4. Best Practices for System Extensions

1. **Keep Mathematical Logic Declarative**: Always register formulas in `formulaRules` rather than performing hardcoded math inside UI widgets. This ensures modifiers from spells, potions, or magic items cascade dynamically.
2. **Namespace Property Keys**: Use dot-delimited tokens like `abilities.str.score` and `attributes.ac`. This makes tokens easily discoverable and referenceable in formula evaluation.
3. **Handle Edge Cases**: Ensure formulas handle negative scores and null fallbacks safely.

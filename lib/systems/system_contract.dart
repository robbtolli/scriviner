import '../core/engine/modifier.dart';
import '../core/engine/property_pipeline.dart';

/// Contract representing an extensible tabletop RPG game system (e.g. D&D 5e, Pathfinder 2e).
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

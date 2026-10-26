import '../system_contract.dart';
import '../../core/engine/modifier.dart';
import '../../core/engine/property_pipeline.dart';

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
    final rawAbilities =
        rawProperties['abilities'] as Map<String, dynamic>? ?? {};
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

import '../../core/engine/modifier.dart';

class Dnd5eCondition {
  final String id;
  final String name;
  final String description;
  final List<Modifier> modifiers;

  const Dnd5eCondition({
    required this.id,
    required this.name,
    required this.description,
    this.modifiers = const [],
  });

  static const List<Dnd5eCondition> all = [
    Dnd5eCondition(
      id: 'blinded',
      name: 'Blinded',
      description:
          'You cannot see. Attack rolls against you have advantage; your attack rolls have disadvantage. Automatically fail sight-based checks.',
    ),
    Dnd5eCondition(
      id: 'charmed',
      name: 'Charmed',
      description:
          'You cannot attack the charmer or target them with harmful abilities. The charmer has advantage on social ability checks against you.',
    ),
    Dnd5eCondition(
      id: 'deafened',
      name: 'Deafened',
      description:
          'You cannot hear and automatically fail any ability check that requires hearing.',
    ),
    Dnd5eCondition(
      id: 'frightened',
      name: 'Frightened',
      description:
          'Disadvantage on ability checks and attack rolls while the source of fear is in line of sight. You cannot willingly move closer to the source.',
    ),
    Dnd5eCondition(
      id: 'grappled',
      name: 'Grappled',
      description:
          'Your speed becomes 0, and you cannot benefit from any bonus to your speed.',
    ),
    Dnd5eCondition(
      id: 'incapacitated',
      name: 'Incapacitated',
      description: 'You cannot take actions or reactions.',
    ),
    Dnd5eCondition(
      id: 'invisible',
      name: 'Invisible',
      description:
          'Impossible to see without special senses. You have advantage on attack rolls, and attack rolls against you have disadvantage.',
    ),
    Dnd5eCondition(
      id: 'paralyzed',
      name: 'Paralyzed',
      description:
          'Incapacitated and cannot move or speak. Automatically fail STR and DEX saves. Attack rolls against you have advantage, and any attack that hits within 5 ft is a critical hit.',
    ),
    Dnd5eCondition(
      id: 'petrified',
      name: 'Petrified',
      description:
          'Transformed into a solid inanimate stone substance. Incapacitated, weight increased by 10x, resistance to all damage, immune to poison and disease.',
    ),
    Dnd5eCondition(
      id: 'poisoned',
      name: 'Poisoned',
      description: 'You have disadvantage on attack rolls and ability checks.',
    ),
    Dnd5eCondition(
      id: 'prone',
      name: 'Prone',
      description:
          'Your only movement option is crawling (costs double). Disadvantage on attack rolls. Attack rolls against you have advantage within 5 ft, or disadvantage from further.',
    ),
    Dnd5eCondition(
      id: 'restrained',
      name: 'Restrained',
      description:
          'Speed 0. Attack rolls against you have advantage; your attack rolls have disadvantage. Disadvantage on DEX saving throws.',
    ),
    Dnd5eCondition(
      id: 'stunned',
      name: 'Stunned',
      description:
          'Incapacitated, cannot move, can speak only falteringly. Automatically fail STR and DEX saves. Attack rolls against you have advantage.',
    ),
    Dnd5eCondition(
      id: 'unconscious',
      name: 'Unconscious',
      description:
          'Incapacitated, cannot move or speak, unaware of surroundings. Drop whatever you are holding and fall prone. Automatically fail STR and DEX saves. Hits within 5 ft are critical.',
    ),
    Dnd5eCondition(
      id: 'bless',
      name: 'Bless (Spell Buff)',
      description:
          'Whenever you make an attack roll or saving throw, you roll 1d4 and add the number rolled to the total.',
      modifiers: [
        Modifier(
          id: 'bless_attack',
          targetProperty: 'attacks.melee.bonus',
          operation: ModifierOperation.diceBonus,
          value: '1d4',
          source: 'Bless',
          priority: ModifierPriority.activeBuff,
        ),
        Modifier(
          id: 'bless_save',
          targetProperty: 'saves.all.bonus',
          operation: ModifierOperation.diceBonus,
          value: '1d4',
          source: 'Bless',
          priority: ModifierPriority.activeBuff,
        ),
      ],
    ),
  ];

  static Dnd5eCondition? findById(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

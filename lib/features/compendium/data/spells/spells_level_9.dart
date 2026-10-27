import '../../models/compendium_entry.dart';

/// SRD 5.1 9th-Level Spells
final List<CompendiumEntry> srdSpellsLevel9 = [
  CompendiumEntry(
    id: 'srd_spell_astral_projection',
    category: 'spell',
    name: 'Astral Projection',
    summary:
        'Project your astral body and up to eight willing creatures onto the Astral Plane while physical bodies remain in suspended animation. Ritual.',
    data: {
      'level': 9,
      'school': 'Necromancy',
      'castingTime': '1 hour',
      'range': '10 feet',
      'components':
          'V, S, M (for each creature affected, one jacinth worth at least 1,000 gp and one silver bar worth 100 gp)',
      'duration': 'Special',
      'ritual': true,
      'classes': ['cleric', 'warlock', 'wizard'],
      'description':
          'You and up to eight willing creatures within range project your astral bodies into the Astral Plane. The material body you leave behind is unconscious and in a state of suspended animation; it doesn\'t age and doesn\'t need food or air. A silvery cord extends from between your shoulder blades and trails behind your astral form, tethering it to your physical body.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_foresight',
    category: 'spell',
    name: 'Foresight',
    summary:
        'Touch a willing creature: cannot be surprised and has advantage on all attack rolls, ability checks, and saving throws for 8 hours.',
    data: {
      'level': 9,
      'school': 'Divination',
      'castingTime': '1 minute',
      'range': 'Touch',
      'components': 'V, S, M (a hummingbird feather)',
      'duration': '8 hours',
      'classes': ['bard', 'druid', 'warlock', 'wizard'],
      'description':
          'You touch a willing creature and bestow a limited ability to see into the immediate future. For the duration, the target can\'t be surprised and has advantage on attack rolls, ability checks, and saving throws. Additionally, other creatures have disadvantage on attack rolls against the target for the duration.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_gate',
    category: 'spell',
    name: 'Gate',
    summary:
        'Conjure a portal to a specific location on another plane of existence for up to 1 minute, or summon a named creature through it.',
    data: {
      'level': 9,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a diamond worth at least 5,000 gp)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['cleric', 'sorcerer', 'wizard'],
      'description':
          'You conjure a portal linking an unoccupied space you can see within range to a precise location on a different plane of existence. The portal is a circular opening between 5 and 20 feet in diameter. You can orient the portal in any direction you choose. The portal lasts for the duration. When you cast this spell, you can speak the name of a specific creature: the portal opens in the immediate vicinity of that creature and draws it through.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_mass_heal',
    category: 'spell',
    name: 'Mass Heal',
    summary:
        'A flood of healing energy cures diseases and blindness/deafness, and restores up to 700 hit points divided among chosen creatures.',
    data: {
      'level': 9,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['cleric'],
      'description':
          'A flood of healing energy flows from you into injured creatures around you. You restore up to 700 hit points, divided as you choose among any number of creatures that you can see within range. Creatures healed by this spell are also cured of all diseases and any effect making them blinded or deafened. This spell has no effect on undead or constructs.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_meteor_swarm',
    category: 'spell',
    name: 'Meteor Swarm',
    summary:
        'Blazing orbs plummet to four points within 1 mile: each deals 20d6 fire + 20d6 bludgeoning damage in a 40-ft radius (DEX save half).',
    data: {
      'level': 9,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '1 mile',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'Blazing orbs of fire plummet to the ground at four different points you can see within range. Each creature in a 40-foot-radius sphere centered on each point you choose must make a Dexterity saving throw. A creature takes 20d6 fire damage and 20d6 bludgeoning damage on a failed save, or half as much damage on a successful one. A creature in the area of more than one fiery burst is affected only once.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_power_word_heal',
    category: 'spell',
    name: 'Power Word Heal',
    summary:
        'Touch a creature: regains all of its hit points and ends charmed, frightened, paralyzed, or stunned conditions.',
    data: {
      'level': 9,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['bard'],
      'description':
          'A wave of healing energy washes over the creature you touch. The target regains all its hit points. If the creature is charmed, frightened, paralyzed, or stunned, the condition ends. If the creature is prone, it can use its reaction to stand up. This spell has no effect on undead or constructs.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_power_word_kill',
    category: 'spell',
    name: 'Power Word Kill',
    summary:
        'Utter a word of power targeting a creature within 60 ft: if it has 100 hit points or fewer, it dies instantly without a saving throw.',
    data: {
      'level': 9,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You utter a word of power that can compel one creature you can see within range to die instantly. If the creature you choose has 100 hit points or fewer, it dies. Otherwise, the spell has no effect.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_prismatic_wall',
    category: 'spell',
    name: 'Prismatic Wall',
    summary:
        'A shimmering, multicolored plane of light composed of seven layers blocks passage, destroys missiles, and blinds/damages foes.',
    data: {
      'level': 9,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': '10 minutes',
      'classes': ['wizard'],
      'description':
          'A shimmering, multicolored plane of light forms a vertical opaque wall up to 90 feet long, 30 feet high, and 1 inch thick, or a sphere up to 30 feet in diameter. The wall sheds bright light in a 100-foot radius and dim light for an additional 100 feet. The wall consists of seven layers, each with a different color and protective properties (Red, Orange, Yellow, Green, Blue, Indigo, Violet). Rods, missiles, and spells of 8th level or lower cannot pass through.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_shapechange',
    category: 'spell',
    name: 'Shapechange',
    summary:
        'Transform into any creature with a CR equal to or less than your level for up to 1 hour; change forms again as an action.',
    data: {
      'level': 9,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S, M (a jade circlet worth at least 1,500 gp)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['druid', 'wizard'],
      'description':
          'You assume the form of a different creature for the duration. The new form can be any of your choice with a challenge rating equal to your level or lower. The creature can\'t be a construct or an undead, and you must have seen such a creature at least once. You assume the hit points and Hit Dice of the new form. You can use your action to change into a different eligible form at any time during the duration.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_time_stop',
    category: 'spell',
    name: 'Time Stop',
    summary:
        'Briefly stop the flow of time for everyone but yourself: take 1d4 + 1 turns in a row in which to act, cast spells, and move.',
    data: {
      'level': 9,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You briefly stop the flow of time for everyone but yourself. No time passes for other creatures, while you take 1d4 + 1 turns in a row, during which you can use actions and move as normal. This spell ends if one of the actions you use during this period, or any effects that you create during this period, affects a creature other than you or an object being worn or carried by someone other than you.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_true_polymorph',
    category: 'spell',
    name: 'True Polymorph',
    summary:
        'Transform a creature into a creature, creature into an object, or object into a creature. Becomes permanent after 1 hour.',
    data: {
      'level': 9,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '30 feet',
      'components':
          'V, S, M (a drop of mercury, a dollop of gum arabic, and a wisp of smoke)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['bard', 'warlock', 'wizard'],
      'description':
          'Choose one creature or nonmagical object that you can see within range. You transform the creature into a different creature, the creature into an object, or the object into a creature. If you concentrate on this spell for the full duration, the transformation becomes permanent until dispelled. Unwilling creatures make a Wisdom saving throw to resist.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_true_resurrection',
    category: 'spell',
    name: 'True Resurrection',
    summary:
        'Touch a creature dead up to 200 years: returns to life with all HP; can even provide a new body if the original is gone.',
    data: {
      'level': 9,
      'school': 'Necromancy',
      'castingTime': '1 hour',
      'range': 'Touch',
      'components':
          'V, S, M (a sprinkle of holy water and diamonds worth at least 25,000 gp, which the spell consumes)',
      'duration': 'Instantaneous',
      'classes': ['cleric', 'druid'],
      'description':
          'You touch a creature that has been dead for no more than 200 years and that died for any reason except old age. If the creature\'s soul is free and willing, the creature is restored to life with all its hit points. This spell closes all mortal wounds and restores any missing body parts. The spell can even provide a new body if the original no longer exists, in which case you must speak the creature\'s name.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_wish',
    category: 'spell',
    name: 'Wish',
    summary:
        'The mightiest spell: duplicate any spell of 8th level or lower without requirements, or alter reality at the risk of spell stress.',
    data: {
      'level': 9,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'Wish is the mightiest spell a mortal creature can cast. By simply speaking aloud, you can alter the very foundations of reality in accord with your desires. The basic use of this spell is to duplicate any other spell of 8th level or lower. You don\'t need to meet any requirements in that spell, including costly components. Alternatively, you can produce one of several alternative effects (create an object up to 25,000 gp, heal 20 creatures, grant damage resistance to 10 creatures, grant spell immunity, or undo a single recent event).',
    },
  ),
];

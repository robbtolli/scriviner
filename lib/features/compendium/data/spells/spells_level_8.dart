import '../../models/compendium_entry.dart';

/// SRD 5.1 8th-Level Spells
final List<CompendiumEntry> srdSpellsLevel8 = [
  CompendiumEntry(
    id: 'srd_spell_antimagic_field',
    category: 'spell',
    name: 'Antimagic Field',
    summary:
        'A 10-foot sphere surrounds you: spells cannot be cast, magic items become mundane, and magical effects are suppressed.',
    data: {
      'level': 8,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Self (10-foot-radius sphere)',
      'components': 'V, S, M (a pinch of powdered iron or iron filings)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['cleric', 'wizard'],
      'description':
          'A 10-foot-radius invisible sphere of antimagic surrounds you. This area is divorced from the magical energy that suffuses the multiverse. Within the sphere, spells can\'t be cast, summoned creatures disappear, and even magic items become mundane. Until the spell ends, the sphere moves with you, centered on you.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_dominate_monster',
    category: 'spell',
    name: 'Dominate Monster',
    summary:
        'Telepathically control any creature (including aberrations, dragons, undead) for up to 1 hour on failed WIS save.',
    data: {
      'level': 8,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You attempt to beguile a creature that you can see within range. It must succeed on a Wisdom saving throw or be charmed by you for the duration. While the creature is charmed, you have a telepathic link with it through which you can issue commands that it must do its best to obey.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_earthquake',
    category: 'spell',
    name: 'Earthquake',
    summary:
        'Create an intense seismic tremor in a 100-foot radius: damages structures, creates fissures, and knocks creatures prone.',
    data: {
      'level': 8,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '500 feet',
      'components':
          'V, S, M (a pinch of dirt, a piece of rock, and a lump of clay)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['cleric', 'druid', 'sorcerer'],
      'description':
          'You create a seismic disturbance at a point on the ground that you can see within range. For the duration, an intense tremor rips through the ground in a 100-foot-radius circle centered on that point. Ground in the area is difficult terrain. Each creature on the ground that is concentrating must make a Constitution saving throw. At the end of each of your turns, each creature on the ground must make a Dexterity saving throw or be knocked prone. Structures take 50 bludgeoning damage each turn.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_feeblemind',
    category: 'spell',
    name: 'Feeblemind',
    summary:
        'Blast a target\'s mind for 4d6 psychic damage; on failed INT save, Intelligence and Charisma scores drop to 1 and cannot cast spells.',
    data: {
      'level': 8,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '150 feet',
      'components':
          'V, S, M (a handful of clay, crystal, glass, or mineral spheres)',
      'duration': 'Instantaneous',
      'classes': ['bard', 'druid', 'warlock', 'wizard'],
      'description':
          'You blast the mind of a creature that you can see within range, attempting to shatter its intellect and personality. The target takes 4d6 psychic damage and must make an Intelligence saving throw. On a failed save, the creature\'s Intelligence and Charisma scores become 1. The creature can\'t cast spells, activate magic items, understand language, or communicate in any intelligible way.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_holy_aura',
    category: 'spell',
    name: 'Holy Aura',
    summary:
        'Divine light in a 30-foot radius: chosen creatures have advantage on all saving throws, attackers have disadv, and fiends/undead are blinded.',
    data: {
      'level': 8,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Self (30-foot-radius sphere)',
      'components': 'V, S, M (a tiny reliquary worth at least 1,000 gp)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['cleric'],
      'description':
          'Divine light sheds from you in a 30-foot radius. Chosen creatures in the radius shed dim light in a 5-foot radius, have advantage on all saving throws, and other creatures have disadvantage on attack rolls against them until the spell ends. In addition, when a fiend or undead hits an affected creature with a melee attack, the aura flashes with brilliant light: the attacker must succeed on a Constitution saving throw or be blinded until the spell ends.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_incendiary_cloud',
    category: 'spell',
    name: 'Incendiary Cloud',
    summary:
        'Swirling cloud of white-hot embers deals 10d8 fire damage in a 20-foot radius (DEX save half); heavily obscures area.',
    data: {
      'level': 8,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '150 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'A swirling cloud of smoke shot with white-hot embers appears in a 20-foot-radius sphere centered on a point within range. The cloud spreads around corners and is heavily obscured. When the cloud appears, each creature in it must make a Dexterity saving throw, taking 10d8 fire damage on a failed save, or half on a success. A creature must also make the save when it enters the spell\'s area for the first time on a turn or ends its turn there. The cloud moves 10 feet directly away from you in a direction you choose at the start of each of your turns.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_maze',
    category: 'spell',
    name: 'Maze',
    summary:
        'Banish a creature into a labyrinthine demiplane for up to 10 minutes without a save; escapes only with DC 20 INT check.',
    data: {
      'level': 8,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['wizard'],
      'description':
          'You banish a creature that you can see within range into a labyrinthine demiplane. The target remains there for the duration or until it escapes the maze. The target can use its action to attempt to escape: it makes a DC 20 Intelligence check. If it succeeds, it escapes, and the spell ends (a minotaur or goristro automatically succeeds). When the spell ends, the target reappears in the space it left.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_mind_blank',
    category: 'spell',
    name: 'Mind Blank',
    summary:
        'Touch a willing creature: completely immune to psychic damage, divination/mind-reading spells, and the charmed condition for 24 hours.',
    data: {
      'level': 8,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': '24 hours',
      'classes': ['bard', 'wizard'],
      'description':
          'Until the spell ends, one willing creature you touch is immune to psychic damage, any effect that would sense its emotions or read its thoughts, divination spells, and the charmed condition. The spell even foils Wish spells and spells of similar power used to affect the target\'s mind or gain information by such means.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_power_word_stun',
    category: 'spell',
    name: 'Power Word Stun',
    summary:
        'Speak a word of power targeting a creature within 60 ft: if it has 150 HP or fewer, it is stunned (CON save each turn to recover).',
    data: {
      'level': 8,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You speak a word of power that can overwhelm the mind of one creature you can see within range, leaving it dumbfounded. If the target has 150 hit points or fewer, it is stunned. Otherwise, the spell has no effect. The stunned target must make a Constitution saving throw at the end of each of its turns. On a successful save, this stunning effect ends.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_sunburst',
    category: 'spell',
    name: 'Sunburst',
    summary:
        'Brilliant sunlight flashes in a 60-foot radius: deals 12d6 radiant damage and blinds creatures for 1 minute (CON save half and prevents blindness).',
    data: {
      'level': 8,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '150 feet',
      'components': 'V, S, M (fire and a piece of sunstone)',
      'duration': 'Instantaneous',
      'classes': ['druid', 'sorcerer', 'wizard'],
      'description':
          'Brilliant sunlight flashes in a 60-foot radius centered on a point you choose within range. Each creature in that light must make a Constitution saving throw. On a failed save, a creature takes 12d6 radiant damage and is blinded for 1 minute. On a successful save, it takes half as much damage and isn\'t blinded by this spell. Undead and oozes have disadvantage on this saving throw.',
    },
  ),
];

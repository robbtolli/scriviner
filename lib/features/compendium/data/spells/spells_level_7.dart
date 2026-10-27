import '../../models/compendium_entry.dart';

/// SRD 5.1 7th-Level Spells
final List<CompendiumEntry> srdSpellsLevel7 = [
  CompendiumEntry(
    id: 'srd_spell_delayed_blast_fireball',
    category: 'spell',
    name: 'Delayed Blast Fireball',
    summary:
        'A glowing bead of fire sits for up to 1 minute, gaining +1d6 damage per round, then explodes for 12d6+ fire damage (DEX save half).',
    data: {
      'level': 7,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '150 feet',
      'components': 'V, S, M (a tiny ball of bat guano and sulfur)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'A beam of yellow light flashes from your pointing finger, then condenses to linger at a chosen point within range as a glowing bead for the duration. When the spell ends, either because your concentration is broken or because you decide to end it, the bead blossoms into a 20-foot-radius sphere of fire. Each creature in the area must make a Dexterity saving throw. A creature takes fire damage equal to 12d6 plus 1d6 for each round it was delayed, or half as much on a successful save.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_finger_of_death',
    category: 'spell',
    name: 'Finger of Death',
    summary:
        'Send negative energy into a creature: deals 7d8 + 30 necrotic damage (CON save half); humanoids killed rise as permanent zombies under your command.',
    data: {
      'level': 7,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'warlock', 'wizard'],
      'description':
          'You send negative energy coursing through a creature that you can see within range, causing it searing pain. The target must make a Constitution saving throw. It takes 7d8 + 30 necrotic damage on a failed save, or half as much damage on a successful one. A humanoid killed by this spell rises at the start of your next turn as a zombie that is permanently under your command, following your verbal orders.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_fire_storm',
    category: 'spell',
    name: 'Fire Storm',
    summary:
        'Storm of sheets of roaring flame deals 7d10 fire damage in up to ten 10-foot cubes (DEX save half).',
    data: {
      'level': 7,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '150 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['cleric', 'druid', 'sorcerer'],
      'description':
          'A storm made of sheets of roaring flame appears in a location you choose within range. The area of the storm consists of up to ten 10-foot cubes, which you can arrange as you wish. Each creature in the area must make a Dexterity saving throw. It takes 7d10 fire damage on a failed save, or half as much damage on a successful one.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_forcecage',
    category: 'spell',
    name: 'Forcecage',
    summary:
        'Traps a creature in an invisible, indestructible prison of force up to a 20-ft cage or 10-ft solid box for 1 hour without concentration.',
    data: {
      'level': 7,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '100 feet',
      'components': 'V, S, M (ruby dust worth 1,500 gp)',
      'duration': '1 hour',
      'classes': ['bard', 'warlock', 'wizard'],
      'description':
          'An immobile, invisible, cube-shaped prison composed of magical force springs into existence around an area you choose within range. The prison can be a cage or a solid box, as you choose. A prison in the shape of a cage can be up to 20 feet on a side and is made from 1/2-inch diameter bars. A prison in the shape of a box can be up to 10 feet on a side, creating a solid barrier. When you cast the spell, any creature that is completely inside the cage\'s area is trapped. A creature inside cannot leave by nonmagical means, and teleportation requires a Charisma saving throw to escape.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_plane_shift',
    category: 'spell',
    name: 'Plane Shift',
    summary:
        'Transport yourself and up to eight willing creatures to another plane of existence, or banish an unwilling creature on a melee spell hit.',
    data: {
      'level': 7,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components':
          'V, S, M (a forked, metal rod worth at least 250 gp, attuned to a particular plane of existence)',
      'duration': 'Instantaneous',
      'classes': ['cleric', 'druid', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You and up to eight willing creatures who link hands in a circle are transported to a different plane of existence. You can specify a target destination in general terms, such as the City of Brass on the Elemental Plane of Fire or the palace of Dispater on the second layer of the Nine Hells. You can also use this spell to banish an unwilling creature to another plane: make a melee spell attack against the creature; on a hit, the creature must pass a Charisma saving throw or be banished.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_prismatic_spray',
    category: 'spell',
    name: 'Prismatic Spray',
    summary:
        'Eight multicolored rays flash from hand: each creature in 60-ft cone takes 10d6 damage (fire, acid, lightning, poison, cold) or is petrified/blinded.',
    data: {
      'level': 7,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Self (60-foot cone)',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'Eight multicolored rays of light flash from your hand in a 60-foot cone. Each creature in the cone must make a Dexterity saving throw. For each target, roll a d8 to determine which color ray affects it: 1 (Red - 10d6 fire), 2 (Orange - 10d6 acid), 3 (Yellow - 10d6 lightning), 4 (Green - 10d6 poison), 5 (Blue - 10d6 cold), 6 (Indigo - restrained and potentially petrified), 7 (Violet - blinded and potentially banished), or 8 (Special - struck by two rays).',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_regenerate',
    category: 'spell',
    name: 'Regenerate',
    summary:
        'Touch a creature: it regains 4d8 + 15 HP immediately, regains 1 HP every round for 1 hour, and regrows severed body parts.',
    data: {
      'level': 7,
      'school': 'Transmutation',
      'castingTime': '1 minute',
      'range': 'Touch',
      'components': 'V, S, M (a prayer wheel and holy water)',
      'duration': '1 hour',
      'classes': ['bard', 'cleric', 'druid'],
      'description':
          'You touch a creature and stimulate its natural healing ability. The target regains 4d8 + 15 hit points. For the duration of the spell, the target regains 1 hit point at the start of each of its turns (10 hit points each minute). The target\'s severed body members (fingers, legs, tails, and so on), if any, are restored after 2 minutes. If you have the severed part and hold it to the stump, the spell instantaneously causes the limb to knit to the stump.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_resurrection',
    category: 'spell',
    name: 'Resurrection',
    summary:
        'Touch a dead creature that has been dead no longer than a century: returns to life with all hit points, curing diseases and poisons.',
    data: {
      'level': 7,
      'school': 'Necromancy',
      'castingTime': '1 hour',
      'range': 'Touch',
      'components':
          'V, S, M (a diamond worth at least 1,000 gp, which the spell consumes)',
      'duration': 'Instantaneous',
      'classes': ['bard', 'cleric'],
      'description':
          'You touch a dead creature that has been dead for no more than a century, that didn\'t die of old age, and that isn\'t undead. If its soul is free and willing, the target comes back to life with all its hit points. This spell neutralizes any poisons and cures normal diseases afflicting the creature when it died. It also closes all mortal wounds and restores any missing body parts.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_reverse_gravity',
    category: 'spell',
    name: 'Reverse Gravity',
    summary:
        'Reverses gravity in a 50-ft radius, 100-ft high cylinder for up to 1 minute: unanchored creatures and objects fall upward.',
    data: {
      'level': 7,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '100 feet',
      'components': 'V, S, M (a lodestone and iron filings)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['druid', 'sorcerer', 'wizard'],
      'description':
          'This spell reverses gravity in a 50-foot-radius, 100-foot-high cylinder centered on a point within range. All creatures and objects that aren\'t somehow anchored to the ground in the area fall upward and reach the top of the area when you cast this spell. A creature can make a Dexterity saving throw to grab onto a fixed object it can reach. If an object or creature strikes a solid surface (such as a ceiling) in its rise, it takes falling damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_teleport',
    category: 'spell',
    name: 'Teleport',
    summary:
        'Instantly transports you and up to eight willing creatures or a single object to a destination anywhere on the same plane.',
    data: {
      'level': 7,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '10 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'This spell instantly transports you and up to eight willing creatures of your choice that you can see within range, or a single object that you can see within range, to a destination you select. The destination must be known to you, and it must be on the same plane of existence as you. Roll a d100 to check arrival accuracy based on your familiarity with the destination (Permanent Circle, Associated Object, Very Familiar, Seen Casually, Viewed Once, False Destination).',
    },
  ),
];

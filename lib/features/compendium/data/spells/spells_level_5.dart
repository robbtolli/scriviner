import '../../models/compendium_entry.dart';

/// SRD 5.1 5th-Level Spells
final List<CompendiumEntry> srdSpellsLevel5 = [
  CompendiumEntry(
    id: 'srd_spell_animate_objects',
    category: 'spell',
    name: 'Animate Objects',
    summary:
        'Animate up to ten nonmagical objects as creatures under your command for up to 1 minute.',
    data: {
      'level': 5,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'Objects come to life at your command. Choose up to ten nonmagical objects within range that are not being worn or carried. Each target animates and becomes a creature under your control until the spell ends or until reduced to 0 hit points. As a bonus action, you can mentally command any creature you made with this spell.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_cloudkill',
    category: 'spell',
    name: 'Cloudkill',
    summary:
        '20-foot-radius sphere of poisonous, yellowish-green fog deals 5d8 poison damage (CON save half) and moves away each turn.',
    data: {
      'level': 5,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You create a 20-foot-radius sphere of poisonous, yellowish-green fog centered on a point you choose within range. The fog spreads around corners. It lasts for the duration or until a strong wind disperses it. When a creature enters the spell\'s area for the first time on a turn or starts its turn there, that creature must make a Constitution saving throw, taking 5d8 poison damage on a failed save, or half on a success. The sphere moves 10 feet away from you at the start of each of your turns.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_commune',
    category: 'spell',
    name: 'Commune',
    summary:
        'Contact your deity or divine proxy and ask up to three questions that can be answered with a yes or no. Ritual.',
    data: {
      'level': 5,
      'school': 'Divination',
      'castingTime': '1 minute',
      'range': 'Self',
      'components': 'V, S, M (incense and a vial of holy or unholy water)',
      'duration': '1 minute',
      'ritual': true,
      'classes': ['cleric'],
      'description':
          'You contact your deity or a divine proxy and ask up to three questions that can be answered with a yes or no. You must ask your questions before the spell ends. You receive a correct answer for each question.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_cone_of_cold',
    category: 'spell',
    name: 'Cone of Cold',
    summary:
        'Blast of cold air in a 60-foot cone deals 8d8 cold damage (CON save half); victims become frozen statues if killed.',
    data: {
      'level': 5,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Self (60-foot cone)',
      'components': 'V, S, M (a small crystal or glass cone)',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'A blast of cold air erupts from your hands. Each creature in a 60-foot cone must make a Constitution saving throw. A creature takes 8d8 cold damage on a failed save, or half as much damage on a successful one. A creature killed by this spell becomes a frozen statue until it thaws.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_dispel_evil_and_good',
    category: 'spell',
    name: 'Dispel Evil and Good',
    summary:
        'Celestial/fiendish creatures have disadv attacking you; dismiss them back to their home planes with touch.',
    data: {
      'level': 5,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S, M (holy water or powdered silver and iron)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['cleric', 'paladin'],
      'description':
          'Shimmering energy wraps around you and protects you from evil and good. Celestion, elemental, fey, fiend, and undead have disadvantage on attack rolls against you. You can also break enchantment or drive creatures back to their native planes by making a melee spell attack.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_dominate_person',
    category: 'spell',
    name: 'Dominate Person',
    summary:
        'Telepathically control a humanoid for up to 1 minute on a failed WIS save (new save whenever taking damage).',
    data: {
      'level': 5,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'You attempt to beguile a humanoid that you can see within range. It must succeed on a Wisdom saving throw or be charmed by you for the duration. While the target is charmed, you have a telepathic link with it and can issue commands that it must obey.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_flame_strike',
    category: 'spell',
    name: 'Flame Strike',
    summary:
        'Vertical column of divine fire deals 4d6 fire + 4d6 radiant damage in a 10-ft radius cylinder (DEX save half).',
    data: {
      'level': 5,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (pinch of sulfur)',
      'duration': 'Instantaneous',
      'classes': ['cleric'],
      'description':
          'A vertical column of divine fire roars down from the heavens in a location you specify. Each creature in a 10-foot-radius, 40-foot-high cylinder centered on a point within range must make a Dexterity saving throw. A creature takes 4d6 fire damage and 4d6 radiant damage on a failed save, or half as much damage on a successful one.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_greater_restoration',
    category: 'spell',
    name: 'Greater Restoration',
    summary:
        'Touch a creature to end one exhaustion level, charmed, petrified, curse, or reduce ability score / max HP reductions.',
    data: {
      'level': 5,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components':
          'V, S, M (diamond dust worth at least 100 gp, which the spell consumes)',
      'duration': 'Instantaneous',
      'classes': ['bard', 'cleric', 'druid'],
      'description':
          'You imbue a creature you touch with positive energy to undo a debilitating effect. You can reduce the target\'s exhaustion level by one, or end one of the following effects: one effect that charmed or petrified the target, one curse including attunement to a cursed magic item, any reduction to one of the target\'s ability scores, or one effect reducing the target\'s hit point maximum.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_hold_monster',
    category: 'spell',
    name: 'Hold Monster',
    summary:
        'Paralyze any creature (humanoid or monster) within 90 feet for up to 1 minute on a failed WIS save.',
    data: {
      'level': 5,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '90 feet',
      'components': 'V, S, M (a small, straight piece of iron)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'Choose a creature that you can see within range. The target must succeed on a Wisdom saving throw or be paralyzed for the duration. This spell has no effect on undead. At the end of each of its turns, the target can make another Wisdom saving throw. On a success, the spell ends on the target.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_mass_cure_wounds',
    category: 'spell',
    name: 'Mass Cure Wounds',
    summary:
        'Wave of healing energy restores 3d8 + spellcasting modifier HP to up to six creatures in a 30-ft sphere.',
    data: {
      'level': 5,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['bard', 'cleric', 'druid'],
      'description':
          'A wave of healing energy washes out from a point of your choice within range. Choose up to six creatures in a 30-foot-radius sphere centered on that point. Each target regains hit points equal to 3d8 + your spellcasting ability modifier. This spell has no effect on undead or constructs.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_raise_dead',
    category: 'spell',
    name: 'Raise Dead',
    summary:
        'Touch a creature that died within the last 10 days to return it to life with 1 hit point (closes mortal wounds).',
    data: {
      'level': 5,
      'school': 'Necromancy',
      'castingTime': '1 hour',
      'range': 'Touch',
      'components':
          'V, S, M (a diamond worth at least 500 gp, which the spell consumes)',
      'duration': 'Instantaneous',
      'classes': ['bard', 'cleric', 'paladin'],
      'description':
          'You return a dead creature you touch to life, provided that it has been dead no longer than 10 days. If the creature\'s soul is both willing and at liberty to rejoin the body, the creature returns to life with 1 hit point. This spell also neutralizes any poisons and cures normal diseases afflicting the creature when it died. It doesn\'t, however, remove magical diseases, curses, or similar effects. Coming back from the dead is an ordeal: the target takes a -4 penalty to all attack rolls, saving throws, and ability checks, reduced by 1 for each long rest.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_scrying',
    category: 'spell',
    name: 'Scrying',
    summary:
        'See and hear a particular creature or location on the same plane of existence for up to 10 minutes (WIS save negates).',
    data: {
      'level': 5,
      'school': 'Divination',
      'castingTime': '10 minutes',
      'range': 'Self',
      'components':
          'V, S, M (a focus worth at least 1,000 gp, such as a crystal ball, silver mirror, or font of holy water)',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['bard', 'cleric', 'druid', 'warlock', 'wizard'],
      'description':
          'You can see and hear a particular creature you choose that is on the same plane of existence as you. The target must make a Wisdom saving throw, which is modified by how well you know the target and the sort of physical connection you have to it. On a failed save, the spell creates an invisible sensor within 10 feet of the target through which you can see and hear.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_telekinesis',
    category: 'spell',
    name: 'Telekinesis',
    summary:
        'Gain the ability to move or manipulate creatures (contested check) or objects weighing up to 1,000 lbs by thought.',
    data: {
      'level': 5,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You gain the ability to move or manipulate creatures or objects by thought. When you cast the spell, and as your action each round for the duration, you can exert your will on one creature or object that you can see within range, causing the appropriate effect: Creature (make an ability check with your spellcasting ability contested by the creature\'s Strength check to move it up to 30 feet in any direction and restrain it) or Object (move an object weighing up to 1,000 pounds up to 30 feet in any direction).',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_wall_of_force',
    category: 'spell',
    name: 'Wall of Force',
    summary:
        'An invisible, indestructible wall or dome of force springs into existence for up to 10 minutes.',
    data: {
      'level': 5,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components':
          'V, S, M (a pinch of powder made by crushing a clear gemstone)',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['wizard'],
      'description':
          'An invisible wall of force springs into existence at a point you choose within range. The wall appears in any orientation you choose, as a horizontal or vertical barrier or at an angle. It can be free floating or resting on a solid surface. You can form it into a hemispherical dome or a sphere with a radius of up to 10 feet, or you can shape a flat surface made up of ten 10-foot-by-10-foot panels. Nothing can physically pass through the wall. It is immune to all damage and can\'t be dispelled by Dispel Magic (though Disintegrate destroys it instantly).',
    },
  ),
];

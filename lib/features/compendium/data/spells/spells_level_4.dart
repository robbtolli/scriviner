import '../../models/compendium_entry.dart';

/// SRD 5.1 4th-Level Spells
final List<CompendiumEntry> srdSpellsLevel4 = [
  CompendiumEntry(
    id: 'srd_spell_banishment',
    category: 'spell',
    name: 'Banishment',
    summary:
        'Banish a creature to another plane for up to 1 minute on a failed CHA save (permanent if native elsewhere).',
    data: {
      'level': 4,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (an item distasteful to the target)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['cleric', 'paladin', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You attempt to send one creature that you can see within range to another plane of existence. The target must succeed on a Charisma saving throw or be banished. If the target is native to the plane of existence you\'re on, you banish the target to a harmless demiplane where it is incapacitated. If the target is native to a different plane of existence than the one you\'re on, the target is banished with a faint popping noise, returning to its home plane. If the spell ends before 1 minute has elapsed, the target reappears; if the spell lasts 1 minute, the target doesn\'t return.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_blight',
    category: 'spell',
    name: 'Blight',
    summary:
        'Necromantic energy washes over a creature dealing 8d8 necrotic damage (CON save half; plants have disadv).',
    data: {
      'level': 4,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['druid', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'Necromantic energy washes over a creature of your choice that you can see within range, draining moisture and vitality from it. The target must make a Constitution saving throw. The target takes 8d8 necrotic damage on a failed save, or half as much damage on a successful one. This spell has no effect on undead or constructs. If you target a plant creature or a magical plant, it makes the saving throw with disadvantage, and the spell deals maximum damage to it.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_confusion',
    category: 'spell',
    name: 'Confusion',
    summary:
        'Assaults the minds of creatures in a 10-ft sphere: target rolls d10 each turn to determine random behavior on failed WIS save.',
    data: {
      'level': 4,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '90 feet',
      'components': 'V, S, M (three nut shells)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'druid', 'sorcerer', 'wizard'],
      'description':
          'This spell assaults and distorts the minds of creatures, generating delusions and provoking uncontrolled actions. Each creature in a 10-foot-radius sphere centered on a point you choose within range must succeed on a Wisdom saving throw when you cast this spell or be affected by it. An affected target can\'t take reactions and must roll a d10 at the start of each of its turns to determine its behavior.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_death_ward',
    category: 'spell',
    name: 'Death Ward',
    summary:
        'Touch a creature: first time it would drop to 0 HP, it drops to 1 HP instead, or negates instantaneous death effects.',
    data: {
      'level': 4,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': '8 hours',
      'classes': ['cleric', 'paladin'],
      'description':
          'You touch a creature and grant it a measure of protection from death. The first time the target would drop to 0 hit points as a result of taking damage, the target instead drops to 1 hit point, and the spell ends. If the spell is still in effect when the target is subjected to an effect that would kill it instantaneously without dealing damage, that effect is instead negated against the target, and the spell ends.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_dimension_door',
    category: 'spell',
    name: 'Dimension Door',
    summary:
        'Teleport yourself and up to one willing creature to any spot within 500 feet, whether you have line of sight or not.',
    data: {
      'level': 4,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '500 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You teleport yourself from your current location to any other spot within range. You arrive at exactly the spot desired. It can be a place you can see, one you can visualize, or one you can describe by stating distance and direction. You can bring along objects as long as their weight doesn\'t exceed what you can carry. You can also bring one willing creature of your size or smaller who is carrying gear up to its carrying capacity.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_fire_shield',
    category: 'spell',
    name: 'Fire Shield',
    summary:
        'Flames shield you: gain resistance to cold or fire; melee attackers take 2d8 fire or cold damage when hitting you.',
    data: {
      'level': 4,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S, M (a bit of phosphorus or a firefly)',
      'duration': '10 minutes',
      'classes': ['wizard'],
      'description':
          'Thin and wispy flames wreathe your body for the duration, shedding bright light in a 10-foot radius and dim light for an additional 10 feet. You can end the spell early by using an action to dismiss it. The flames provide you with a warm shield (resistance to cold damage) or a chill shield (resistance to fire damage). In addition, whenever a creature within 5 feet of you hits you with a melee attack, the shield erupts with flame, dealing 2d8 fire (warm shield) or 2d8 cold (chill shield) damage to the attacker.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_freedom_of_movement',
    category: 'spell',
    name: 'Freedom of Movement',
    summary:
        'Touch a willing creature: movement unaffected by difficult terrain, spells can\'t paralyze or restrain, spend 5 ft to escape grapples.',
    data: {
      'level': 4,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components':
          'V, S, M (a strip of leather, bound around the arm or a similar extremity)',
      'duration': '1 hour',
      'classes': ['bard', 'cleric', 'druid', 'ranger'],
      'description':
          'You touch a willing creature. For the duration, the target\'s movement is unaffected by difficult terrain, and spells and other magical effects can neither reduce the target\'s speed nor cause the target to be paralyzed or restrained. The target can also spend 5 feet of movement to automatically escape from nonmagical restraints, such as manacles or a creature that has it grappled.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_greater_invisibility',
    category: 'spell',
    name: 'Greater Invisibility',
    summary:
        'Touch a creature to make it invisible for up to 1 minute; remains invisible even when attacking or casting spells.',
    data: {
      'level': 4,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'You or a creature you touch becomes invisible until the spell ends. Anything the target is wearing or carrying is invisible as long as it is on the target\'s person. Unlike standard Invisibility, attacking or casting spells does not end this spell.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_ice_storm',
    category: 'spell',
    name: 'Ice Storm',
    summary:
        'Hail storm deals 2d8 bludgeoning + 4d6 cold damage in 20-ft radius cylinder; ground becomes difficult terrain.',
    data: {
      'level': 4,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '300 feet',
      'components': 'V, S, M (a pinch of dust and a few drops of water)',
      'duration': 'Instantaneous',
      'classes': ['druid', 'sorcerer', 'wizard'],
      'description':
          'A hail of rock-hard ice pounds to the ground in a 20-foot-radius, 40-foot-high cylinder centered on a point within range. Each creature in the cylinder must make a Dexterity saving throw. A creature takes 2d8 bludgeoning damage and 4d6 cold damage on a failed save, or half as much damage on a successful one. Hailstones turn the storm\'s area of effect into difficult terrain until the end of your next turn.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_polymorph',
    category: 'spell',
    name: 'Polymorph',
    summary:
        'Transform a creature into a beast of equal or lower CR/level for up to 1 hour (unwilling target makes WIS save).',
    data: {
      'level': 4,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a caterpillar cocoon)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['bard', 'druid', 'sorcerer', 'wizard'],
      'description':
          'This spell transforms a creature with at least 1 hit point that you can see within range into a new form. An unwilling creature must make a Wisdom saving throw to avoid the effect. The transformation lasts for the duration, or until the target drops to 0 hit points or dies. The new form can be any beast whose challenge rating is equal to or less than the target\'s CR or character level. The target assumes the hit points of its new form.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_resilient_sphere',
    category: 'spell',
    name: 'Resilient Sphere',
    summary:
        'Enclose a creature or object in an impenetrable shimmering sphere of force (DEX save negates).',
    data: {
      'level': 4,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '30 feet',
      'components':
          'V, S, M (a hemispherical piece of clear crystal and a matching hemispherical piece of gum arabic)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['wizard'],
      'description':
          'A sphere of shimmering force encloses a creature or object of Large or smaller size within range. An unwilling creature must make a Dexterity saving throw. On a failed save, the creature is enclosed for the duration. Nothing—not physical objects, energy, or other spell effects—can pass through the barrier, in or out, though a creature in the sphere can breathe there. The sphere is immune to all damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_stoneskin',
    category: 'spell',
    name: 'Stoneskin',
    summary:
        'Touch a willing creature: target gains resistance to nonmagical bludgeoning, piercing, and slashing damage.',
    data: {
      'level': 4,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components':
          'V, S, M (diamond dust worth 100 gp, which the spell consumes)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['druid', 'ranger', 'sorcerer', 'wizard'],
      'description':
          'This spell turns the flesh of a willing creature you touch as hard as stone. Until the spell ends, the target has resistance to nonmagical bludgeoning, piercing, and slashing damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_wall_of_fire',
    category: 'spell',
    name: 'Wall of Fire',
    summary:
        'Create a wall of fire up to 60 ft long or ring 20 ft in diameter: deals 5d8 fire damage on failed DEX save.',
    data: {
      'level': 4,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S, M (a small piece of phosphorus)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['druid', 'sorcerer', 'wizard'],
      'description':
          'You create a wall of fire on a solid surface within range. You can make the wall up to 60 feet long, 20 feet high, and 1 foot thick, or a ringed wall up to 20 feet in diameter, 20 feet high, and 1 foot thick. The wall is opaque and lasts for the duration. One side of the wall deals 5d8 fire damage to each creature within 10 feet of that side or inside the wall when it appears (Dexterity save for half), and when a creature ends its turn within 10 feet of that side.',
    },
  ),
];

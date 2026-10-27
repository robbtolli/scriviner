import '../../models/compendium_entry.dart';

/// SRD 5.1 6th-Level Spells
final List<CompendiumEntry> srdSpellsLevel6 = [
  CompendiumEntry(
    id: 'srd_spell_chain_lightning',
    category: 'spell',
    name: 'Chain Lightning',
    summary:
        'A bolt of lightning deals 10d8 lightning damage to a primary target, then arcs to up to three other targets within 30 ft.',
    data: {
      'level': 6,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '150 feet',
      'components':
          'V, S, M (a bit of fur; a piece of amber, glass, or a crystal rod; and three silver pins)',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You create a bolt of lightning that arcs toward a target of your choice that you can see within range. Three bolts then leap from that target to as many as three other targets, each of which must be within 30 feet of the first target. A target can be a creature or an object and can be targeted by only one of the bolts. A target must make a Dexterity saving throw. The target takes 10d8 lightning damage on a failed save, or half as much damage on a successful one.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_disintegrate',
    category: 'spell',
    name: 'Disintegrate',
    summary:
        'Thin green ray deals 10d6 + 40 force damage (DEX save negates); target is turned to a pile of fine gray dust if reduced to 0 HP.',
    data: {
      'level': 6,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a lodestone and a pinch of dust)',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'A thin green ray springs from your pointing finger to a target that you can see within range. The target can be a creature, an object, or a creation of magical force, such as the wall created by Wall of Force. A creature targeted by this spell must make a Dexterity saving throw. On a failed save, the target takes 10d6 + 40 force damage. If this damage reduces the target to 0 hit points, it is disintegrated into a pile of fine gray dust. A disintegrated creature can be restored to life only by means of a True Resurrection or a Wish spell.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_globe_of_invulnerability',
    category: 'spell',
    name: 'Globe of Invulnerability',
    summary:
        'An immobile, shimmering 10-ft barrier shields you: spells of 5th level or lower cannot affect creatures within.',
    data: {
      'level': 6,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Self (10-foot-radius sphere)',
      'components':
          'V, S, M (a glass or crystal bead that shatters when the spell ends)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'An immobile, faintly shimmering barrier appears in a 10-foot radius around you and remains for the duration. Any spell of 5th level or lower cast from outside the barrier can\'t affect creatures or objects within it, even if the spell is cast using a higher level spell slot. Such a spell can\'t target anything within the barrier, and the barrier excludes spell areas of effect.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_harm',
    category: 'spell',
    name: 'Harm',
    summary:
        'Unleash virulent disease: target takes 14d6 necrotic damage (CON save half) and max HP is reduced by damage taken.',
    data: {
      'level': 6,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['cleric'],
      'description':
          'You unleash a virulent disease on a creature that you can see within range. The target must make a Constitution saving throw. On a failed save, it takes 14d6 necrotic damage, or half as much damage on a successful save. The damage can\'t reduce the target\'s hit points below 1. If the target fails the saving throw, its hit point maximum is reduced for 1 hour by an amount equal to the necrotic damage it took.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_heal',
    category: 'spell',
    name: 'Heal',
    summary:
        'A creature you choose within 60 ft regains 70 hit points and ends blindness, deafness, and all diseases.',
    data: {
      'level': 6,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['cleric', 'druid'],
      'description':
          'Choose a creature that you can see within range. A surge of positive energy washes through the creature, causing it to regain 70 hit points. This spell also ends blindness, deafness, and any diseases affecting the target. This spell has no effect on constructs or undead.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_heroes_feast',
    category: 'spell',
    name: 'Heroes\' Feast',
    summary:
        'Bring forth magnificent feast for 12: cures diseases, grants immunity to poison/frightened, and adds 2d10 to HP max for 24 hours.',
    data: {
      'level': 6,
      'school': 'Conjuration',
      'castingTime': '10 minutes',
      'range': '30 feet',
      'components':
          'V, S, M (a gem-encrusted bowl worth at least 1,000 gp, which the spell consumes)',
      'duration': 'Instantaneous',
      'classes': ['cleric', 'druid'],
      'description':
          'You bring forth a magnificent feast, including magnificent food and drink. The feast takes 1 hour to consume and disappears at the end of that time, and the beneficial effects don\'t set in until this hour is over. Up to twelve other creatures can partake of the feast. A creature that partakes of the feast gains several benefits: cured of all diseases and poison, immune to poison and being frightened, advantage on all Wisdom saving throws, and its hit point maximum increases by 2d10 for 24 hours.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_sunbeam',
    category: 'spell',
    name: 'Sunbeam',
    summary:
        'A beam of brilliant sunlight 60 ft long deals 6d8 radiant damage and blinds creatures on failed CON save; repeat each turn as an action.',
    data: {
      'level': 6,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Self (60-foot line)',
      'components': 'V, S, M (a magnifying glass)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['druid', 'sorcerer', 'wizard'],
      'description':
          'A beam of brilliant light flashes out from your hand in a 5-foot-wide, 60-foot-long line. Each creature in the line must make a Constitution saving throw. On a failed save, a creature takes 6d8 radiant damage and is blinded until your next turn. On a successful save, it takes half as much damage and isn\'t blinded. Undead and oozes have disadvantage on this saving throw. You can create a new line of radiance as your action on any turn until the spell ends.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_true_seeing',
    category: 'spell',
    name: 'True Seeing',
    summary:
        'Touch a willing creature to grant it truesight out to 120 feet, notice secret doors, and see into the Ethereal Plane for 1 hour.',
    data: {
      'level': 6,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Touch',
      'components':
          'V, S, M (an ointment for the eyes that costs 25 gp; consumes ointment)',
      'duration': '1 hour',
      'classes': ['bard', 'cleric', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'This spell gives the willing creature you touch the ability to see things as they actually are. For the duration, the creature has truesight, notices secret doors hidden by magic, and can see into the Ethereal Plane, all out to a range of 120 feet.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_wind_walk',
    category: 'spell',
    name: 'Wind Walk',
    summary:
        'Transform yourself and up to ten willing creatures into gaseous clouds with a flying speed of 300 feet for 8 hours.',
    data: {
      'level': 6,
      'school': 'Transmutation',
      'castingTime': '1 minute',
      'range': '30 feet',
      'components': 'V, S, M (fire and holy water)',
      'duration': '8 hours',
      'classes': ['druid'],
      'description':
          'You and up to ten willing creatures you can see within range assume a gaseous form for the duration, appearing as wisps of cloud. While in this cloud form, a creature has a flying speed of 300 feet and has resistance to damage from nonmagical weapons. The only actions a creature can take in this form are the Dash action or to revert to its normal form (which takes 1 minute).',
    },
  ),
];

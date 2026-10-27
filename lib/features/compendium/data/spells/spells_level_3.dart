import '../../models/compendium_entry.dart';

/// SRD 5.1 3rd-Level Spells
final List<CompendiumEntry> srdSpellsLevel3 = [
  CompendiumEntry(
    id: 'srd_spell_animate_dead',
    category: 'spell',
    name: 'Animate Dead',
    summary:
        'Animate a Medium or Small humanoid corpse into a skeleton or zombie under your command for 24 hours.',
    data: {
      'level': 3,
      'school': 'Necromancy',
      'castingTime': '1 minute',
      'range': '10 feet',
      'components':
          'V, S, M (a drop of blood, a piece of flesh, and a pinch of bone dust)',
      'duration': 'Instantaneous',
      'classes': ['cleric', 'wizard'],
      'description':
          'This spell creates an undead servant. Choose a pile of bones or a corpse of a Medium or Small humanoid within range. Your spell imbues the target with a foul mimicry of life, raising it as an undead creature. The target becomes a skeleton if you chose bones or a zombie if you chose a corpse. On each of your turns, you can use a bonus action to mentally command any creature you made with this spell if the creature is within 60 feet of you.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_beacon_of_hope',
    category: 'spell',
    name: 'Beacon of Hope',
    summary:
        'Bestow hope and vitality: chosen creatures have adv on WIS saves and death saves, and receive max healing.',
    data: {
      'level': 3,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['cleric'],
      'description':
          'This spell bestows hope and vitality. Choose any number of creatures within range. For the duration, each target has advantage on Wisdom saving throws and death saving throws, and regains the maximum number of hit points possible from any healing.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_bestow_curse',
    category: 'spell',
    name: 'Bestow Curse',
    summary:
        'Touch a creature to curse it on a failed WIS save: choose disadvantage on checks/saves, loss of actions, or extra damage.',
    data: {
      'level': 3,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'cleric', 'wizard'],
      'description':
          'You touch a creature, and that creature must succeed on a Wisdom saving throw or become cursed for the duration of the spell. Choose the nature of the curse from the following: choose one ability score for which the target has disadvantage on checks and saves; the target has disadvantage on attack rolls against you; the target must succeed on a WIS save each turn or waste its action; or your attacks and spells deal an extra 1d8 necrotic damage to the target.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_blink',
    category: 'spell',
    name: 'Blink',
    summary:
        'Roll a d20 at end of each turn: on 11+, vanish into the Ethereal Plane, reappearing at start of next turn.',
    data: {
      'level': 3,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S',
      'duration': '1 minute',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'Roll a d20 at the end of each of your turns for the duration of the spell. On a roll of 11 or higher, you vanish from your current plane of existence and appear in the Ethereal Plane. At the start of your next turn, you return to an unoccupied space of your choice that you can see within 10 feet of the space you vanished from.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_call_lightning',
    category: 'spell',
    name: 'Call Lightning',
    summary:
        'Storm cloud appears overhead; call down lightning bolts dealing 3d10 lightning damage (DEX save half).',
    data: {
      'level': 3,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['druid'],
      'description':
          'A storm cloud appears in the shape of a cylinder that is 10 feet tall with a 60-foot radius. When you cast the spell, and as an action on each turn until the spell ends, you can call down a bolt of lightning to a point within range beneath the cloud. Each creature within 5 feet of that point must make a Dexterity saving throw, taking 3d10 lightning damage on a failed save, or half as much on a successful one.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_counterspell',
    category: 'spell',
    name: 'Counterspell',
    summary:
        'Reaction: Interrupt a creature casting a spell. If 3rd level or lower, spell fails; if higher, make ability check.',
    data: {
      'level': 3,
      'school': 'Abjuration',
      'castingTime': '1 reaction',
      'range': '60 feet',
      'components': 'S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'warlock', 'wizard'],
      'description':
          'You attempt to interrupt a creature in the process of casting a spell. If the creature is casting a spell of 3rd level or lower, its spell fails and has no effect. If it is casting a spell of 4th level or higher, make an ability check using your spellcasting ability (DC 10 + spell\'s level). On a success, the creature\'s spell fails and has no effect.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_daylight',
    category: 'spell',
    name: 'Daylight',
    summary:
        'A 60-foot-radius sphere of bright light sheds light and dispels darkness spells of 3rd level or lower.',
    data: {
      'level': 3,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': '1 hour',
      'classes': ['cleric', 'druid', 'paladin', 'ranger', 'sorcerer'],
      'description':
          'A 60-foot-radius sphere of light spreads out from a point you choose within range. The sphere is bright light and sheds dim light for an additional 60 feet. If any of this spell\'s area overlaps with an area of darkness created by a spell of 3rd level or lower, the spell that created the darkness is dispelled.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_dispel_magic',
    category: 'spell',
    name: 'Dispel Magic',
    summary:
        'End any spell of 3rd level or lower on target. For higher level spells, make an ability check (DC 10 + spell level).',
    data: {
      'level': 3,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': [
        'bard',
        'cleric',
        'druid',
        'paladin',
        'sorcerer',
        'warlock',
        'wizard',
      ],
      'description':
          'Choose one creature, object, or magical effect within range. Any spell of 3rd level or lower on the target ends. For each spell of 4th level or higher on the target, make an ability check using your spellcasting ability. The DC equals 10 + the spell\'s level. On a successful check, the spell ends.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_fear',
    category: 'spell',
    name: 'Fear',
    summary:
        'Project phantasmal image in a 30-foot cone: creatures drop items and flee while frightened on failed WIS save.',
    data: {
      'level': 3,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': 'Self (30-foot cone)',
      'components': 'V, S, M (a white feather or the heart of a hen)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You project a phantasmal image of a creature\'s worst fears. Each creature in a 30-foot cone must succeed on a Wisdom saving throw or drop whatever it is holding and become frightened for the duration. While frightened by this spell, a creature must take the Dash action and move away from you by the safest available route on each of its turns.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_fireball',
    category: 'spell',
    name: 'Fireball',
    summary:
        'A bright streak flashes to a point within 150 ft, blossoming into a 20-ft radius sphere dealing 8d6 fire damage (DEX save half).',
    data: {
      'level': 3,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '150 feet',
      'components': 'V, S, M (a tiny ball of bat guano and sulfur)',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'A bright streak flashes from your pointing finger to a point you choose within range and then blossoms with a low roar into an explosion of flame. Each creature in a 20-foot-radius sphere centered on that point must make a Dexterity saving throw. A target takes 8d6 fire damage on a failed save, or half as much damage on a successful one.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_fly',
    category: 'spell',
    name: 'Fly',
    summary:
        'Touch a willing creature to grant it a flying speed of 60 feet for up to 10 minutes.',
    data: {
      'level': 3,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (a wing feather from any bird)',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['sorcerer', 'warlock', 'wizard'],
      'description':
          'You touch a willing creature. The target gains a flying speed of 60 feet for the duration. When the spell ends, the target falls if it is still aloft, unless it can stop the fall.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_gaseous_form',
    category: 'spell',
    name: 'Gaseous Form',
    summary:
        'Transform a willing creature into a misty cloud: resistance to nonmagical damage, fly speed 10 ft, pass through small cracks.',
    data: {
      'level': 3,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (a bit of gauze and a wisp of smoke)',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['sorcerer', 'warlock', 'wizard'],
      'description':
          'You transform a willing creature you touch, along with everything it\'s wearing and carrying, into a misty cloud for the duration. While in this form, the target\'s only method of movement is a flying speed of 10 feet. The target has resistance to nonmagical damage and advantage on Strength, Dexterity, and Constitution saving throws. It can pass through small holes and narrow openings.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_haste',
    category: 'spell',
    name: 'Haste',
    summary:
        'Choose willing creature: speed doubled, +2 AC, advantage on DEX saves, and an extra action each turn.',
    data: {
      'level': 3,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S, M (a shaving of licorice root)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'Choose a willing creature that you can see within range. Until the spell ends, the target\'s speed is doubled, it gains a +2 bonus to AC, it has advantage on Dexterity saving throws, and it gains an additional action on each of its turns. That action can be used only to take the Attack (one weapon attack only), Dash, Disengage, Hide, or Use an Object action. When the spell ends, the target can\'t move or take actions until after its next turn.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_hypnotic_pattern',
    category: 'spell',
    name: 'Hypnotic Pattern',
    summary:
        'Swirling pattern of colors in a 30-ft cube incapacitates and charms creatures on failed WIS save.',
    data: {
      'level': 3,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': '120 feet',
      'components':
          'S, M (a glowing stick of incense or a crystal vial filled with phosphorescent material)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You create a twisting pattern of colors that weaves through the air inside a 30-foot cube within range. Each creature in the area who sees the pattern must make a Wisdom saving throw. On a failed save, the creature becomes charmed for the duration. While charmed by this spell, the creature is incapacitated and has a speed of 0.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_lightning_bolt',
    category: 'spell',
    name: 'Lightning Bolt',
    summary:
        'A stroke of lightning 100 feet long and 5 feet wide deals 8d10 lightning damage (DEX save half).',
    data: {
      'level': 3,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Self (100-foot line)',
      'components':
          'V, S, M (a bit of fur and a rod of amber, crystal, or glass)',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'A stroke of lightning forming a line 100 feet long and 5 feet wide blasts out from you in a direction you choose. Each creature in the line must make a Dexterity saving throw. A creature takes 8d10 lightning damage on a failed save, or half as much damage on a successful one.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_mass_healing_word',
    category: 'spell',
    name: 'Mass Healing Word',
    summary:
        'Bonus action: Up to six creatures within 60 ft regain hit points equal to 1d4 + spellcasting modifier.',
    data: {
      'level': 3,
      'school': 'Evocation',
      'castingTime': '1 bonus action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['cleric'],
      'description':
          'As you call out words of restoration, up to six creatures of your choice that you can see within range regain hit points equal to 1d4 + your spellcasting ability modifier. This spell has no effect on undead or constructs.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_remove_curse',
    category: 'spell',
    name: 'Remove Curse',
    summary:
        'Touch a creature or object: all curses affecting it end, or breaks attunement to a cursed magic item.',
    data: {
      'level': 3,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['cleric', 'paladin', 'warlock', 'wizard'],
      'description':
          'At your touch, all curses affecting one creature or object end. If the object is a cursed magic item, its curse remains, but the spell breaks its owner\'s attunement to the object so it can be removed or discarded.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_revivify',
    category: 'spell',
    name: 'Revivify',
    summary:
        'Touch a creature that has died within the last minute: it returns to life with 1 hit point.',
    data: {
      'level': 3,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (diamonds worth 300 gp, which the spell consumes)',
      'duration': 'Instantaneous',
      'classes': ['cleric', 'paladin'],
      'description':
          'You touch a creature that has died within the last minute. That creature returns to life with 1 hit point. This spell can\'t return to life a creature that has died of old age, nor can it restore any missing body parts.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_slow',
    category: 'spell',
    name: 'Slow',
    summary:
        'Alter time for up to 6 creatures in 40-ft cube: halved speed, -2 AC, no reactions, limited to 1 attack/action (WIS save negates).',
    data: {
      'level': 3,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S, M (a drop of molasses)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You alter time around up to six creatures of your choice in a 40-foot cube within range. Each target must succeed on a Wisdom saving throw or be affected by this spell for the duration. An affected target\'s speed is halved, it takes a -2 penalty to AC and Dexterity saving throws, and it can\'t use reactions. On its turn, it can use either an action or a bonus action, not both. Regardless of the creature\'s abilities or magic items, it can\'t make more than one melee or ranged attack during its turn.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_spirit_guardians',
    category: 'spell',
    name: 'Spirit Guardians',
    summary:
        'Protective spirits surround you within 15 ft: area is difficult terrain; foes take 3d8 radiant or necrotic damage (WIS save half).',
    data: {
      'level': 3,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': 'Self (15-foot radius)',
      'components': 'V, S, M (a holy symbol)',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['cleric'],
      'description':
          'You call forth spirits to protect you. They flit around you to a distance of 15 feet for the duration. An affected creature\'s speed is halved in the area, and when the creature enters the area for the first time on a turn or starts its turn there, it must make a Wisdom saving throw. On a failed save, the creature takes 3d8 radiant damage (if you are good or neutral) or 3d8 necrotic damage (if you are evil). On a successful save, the creature takes half damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_tongues',
    category: 'spell',
    name: 'Tongues',
    summary:
        'Touch a creature to grant it the ability to understand and speak all spoken languages for 1 hour.',
    data: {
      'level': 3,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, M (a small clay model of a ziggurat)',
      'duration': '1 hour',
      'classes': ['bard', 'cleric', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'This spell grants the creature you touch the ability to understand any spoken language it hears. Moreover, when the target speaks, any creature that knows at least one language and can hear the target understands what it says.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_water_breathing',
    category: 'spell',
    name: 'Water Breathing',
    summary:
        'Up to ten willing creatures gain the ability to breathe underwater for 24 hours. Ritual.',
    data: {
      'level': 3,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S, M (a short reed or piece of straw)',
      'duration': '24 hours',
      'ritual': true,
      'classes': ['druid', 'ranger', 'sorcerer', 'wizard'],
      'description':
          'This spell grants up to ten willing creatures you can see within range the ability to breathe underwater until the spell ends. Affected creatures also retain their normal mode of respiration.',
    },
  ),
];

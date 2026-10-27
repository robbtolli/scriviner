import '../../models/compendium_entry.dart';

/// SRD 5.1 1st-Level Spells
final List<CompendiumEntry> srdSpellsLevel1 = [
  CompendiumEntry(
    id: 'srd_spell_alarm',
    category: 'spell',
    name: 'Alarm',
    summary:
        'Set an audible or mental ward against unwanted intrusion in a 20-foot cube.',
    data: {
      'level': 1,
      'school': 'Abjuration',
      'castingTime': '1 minute',
      'range': '30 feet',
      'components': 'V, S, M (a tiny bell and a piece of fine silver wire)',
      'duration': '8 hours',
      'ritual': true,
      'classes': ['ranger', 'wizard'],
      'description':
          'You set an alarm against unwanted intrusion. Choose a door, a window, or an area within range that is no larger than a 20-foot cube. Until the spell ends, an alarm alerts you whenever a Tiny or larger creature touches or enters the warded area.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_animal_friendship',
    category: 'spell',
    name: 'Animal Friendship',
    summary:
        'Convince a beast that you mean it no harm. Target makes a WIS save or is charmed.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S, M (a morsel of food)',
      'duration': '24 hours',
      'classes': ['bard', 'druid', 'ranger'],
      'description':
          'This spell lets you convince a beast that you mean it no harm. Choose a beast that you can see within range. It must see and hear you. If the beast\'s Intelligence is 4 or higher, the spell fails. Otherwise, the beast must succeed on a Wisdom saving throw or be charmed by you for the spell\'s duration.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_bane',
    category: 'spell',
    name: 'Bane',
    summary:
        'Up to three targets must subtract 1d4 from attack rolls and saving throws on failed CHA save.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S, M (a drop of blood)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'cleric'],
      'description':
          'Up to three creatures of your choice that you can see within range must make Charisma saving throws. Whenever a target that fails this saving throw makes an attack roll or a saving throw before the spell ends, the target must roll a d4 and subtract the number rolled from the attack roll or saving throw.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_bless',
    category: 'spell',
    name: 'Bless',
    summary:
        'Bless up to three creatures: whenever they make an attack roll or save, add 1d4 to the roll.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S, M (a sprinkling of holy water)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['cleric', 'paladin'],
      'description':
          'You bless up to three creatures of your choice within range. Whenever a target makes an attack roll or a saving throw before the spell ends, the target can roll a d4 and add the number rolled to the attack roll or saving throw.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_burning_hands',
    category: 'spell',
    name: 'Burning Hands',
    summary:
        'Thin sheet of flame dealing 3d6 fire damage in a 15-foot cone (DEX save half).',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Self (15-foot cone)',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'As you hold your hands with thumbs touching and fingers spread, a thin sheet of flames shoots forth from your outstretched fingertips. Each creature in a 15-foot cone must make a Dexterity saving throw. A creature takes 3d6 fire damage on a failed save, or half as much damage on a successful one.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_charm_person',
    category: 'spell',
    name: 'Charm Person',
    summary:
        'Charm a humanoid who regards you as a friendly acquaintance on a failed WIS save.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S',
      'duration': '1 hour',
      'classes': ['bard', 'druid', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You attempt to charm a humanoid you can see within range. It must make a Wisdom saving throw, and does so with advantage if you or your companions are fighting it. If it fails the saving throw, it is charmed by you until the spell ends or until you or your companions do anything harmful to it.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_color_spray',
    category: 'spell',
    name: 'Color Spray',
    summary:
        'Dazzling array of flashing colored light blinds 6d10 hit points of creatures in a 15-foot cone.',
    data: {
      'level': 1,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': 'Self (15-foot cone)',
      'components':
          'V, S, M (a pinch of powder or sand that is colored red, yellow, and blue)',
      'duration': '1 round',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'A dazzling array of flashing, colored light springs from your hand. Roll 6d10; the total is how many hit points of creatures this spell can affect. Creatures in a 15-foot cone originating from you are affected in ascending order of their current hit points, becoming blinded until the end of your next turn.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_command',
    category: 'spell',
    name: 'Command',
    summary:
        'Speak a one-word command (Approach, Drop, Flee, Grovel, Halt) target must follow on WIS save fail.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V',
      'duration': '1 round',
      'classes': ['cleric', 'paladin'],
      'description':
          'You speak a one-word command to a creature you can see within range. The target must succeed on a Wisdom saving throw or follow the command on its next turn: Approach, Drop, Flee, Grovel, or Halt.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_comprehend_languages',
    category: 'spell',
    name: 'Comprehend Languages',
    summary:
        'Understand the literal meaning of any spoken language you hear or written text you touch.',
    data: {
      'level': 1,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S, M (a pinch of soot and salt)',
      'duration': '1 hour',
      'ritual': true,
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'For the duration, you understand the literal meaning of any spoken language that you hear. You also understand any written language that you see, but you must be touching the surface on which the words are written.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_create_or_destroy_water',
    category: 'spell',
    name: 'Create or Destroy Water',
    summary:
        'Create up to 10 gallons of clean water, create rain, or destroy up to 10 gallons of water or fog.',
    data: {
      'level': 1,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '30 feet',
      'components':
          'V, S, M (a drop of water if creating, or a few grains of sand if destroying)',
      'duration': 'Instantaneous',
      'classes': ['cleric', 'druid'],
      'description':
          'You either create or destroy water. Create Water: You create up to 10 gallons of clean water in an open container, or cause rain in a 30-foot cube. Destroy Water: You destroy up to 10 gallons of water in an open container, or destroy fog in a 30-foot cube.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_cure_wounds',
    category: 'spell',
    name: 'Cure Wounds',
    summary:
        'A creature you touch regains 1d8 + spellcasting modifier hit points.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['bard', 'cleric', 'druid', 'paladin', 'ranger'],
      'description':
          'A creature you touch regains a number of hit points equal to 1d8 + your spellcasting ability modifier. This spell has no effect on undead or constructs.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_detect_evil_and_good',
    category: 'spell',
    name: 'Detect Evil and Good',
    summary:
        'Sense if there is an aberration, celestial, elemental, fey, fiend, or undead within 30 feet.',
    data: {
      'level': 1,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['cleric', 'paladin'],
      'description':
          'For the duration, you know if there is an aberration, celestial, elemental, fey, fiend, or undead within 30 feet of you, as well as where the creature is located. Similarly, you know if there is a place or object within 30 feet of you that has been magically consecrated or desecrated.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_detect_magic',
    category: 'spell',
    name: 'Detect Magic',
    summary:
        'Sense the presence and school of magic within 30 feet. Can be cast as a ritual.',
    data: {
      'level': 1,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S',
      'duration': 'Concentration, up to 10 minutes',
      'ritual': true,
      'classes': [
        'bard',
        'cleric',
        'druid',
        'paladin',
        'ranger',
        'sorcerer',
        'wizard',
      ],
      'description':
          'For the duration, you sense the presence of magic within 30 feet of you. If you sense magic in this way, you can use your action to see a faint aura around any visible creature or object in the area that bears magic, and you learn its school of magic, if any.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_detect_poison_and_disease',
    category: 'spell',
    name: 'Detect Poison and Disease',
    summary:
        'Sense the presence and location of poisons, poisonous creatures, and diseases within 30 feet.',
    data: {
      'level': 1,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S, M (a yew leaf)',
      'duration': 'Concentration, up to 10 minutes',
      'ritual': true,
      'classes': ['cleric', 'druid', 'paladin', 'ranger'],
      'description':
          'For the duration, you can sense the presence and location of poisons, poisonous creatures, and diseases within 30 feet of you. You also identify the kind of poison, poisonous creature, or disease in each case.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_disguise_self',
    category: 'spell',
    name: 'Disguise Self',
    summary:
        'Make yourself look different (including clothing, armor, and weapons) for up to 1 hour.',
    data: {
      'level': 1,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S',
      'duration': '1 hour',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'You make yourself—including your clothing, armor, weapons, and other belongings on your person—look different until the spell ends or until you use your action to dismiss it. You can seem 1 foot shorter or taller and can appear thin, fat, or in between.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_dissonant_whispers',
    category: 'spell',
    name: 'Dissonant Whispers',
    summary:
        'Discordant whispers deal 3d6 psychic damage and force target to immediately flee on failed WIS save.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['bard'],
      'description':
          'You whisper a discordant melody that only one creature of your choice within range can hear. The target must make a Wisdom saving throw. On a failed save, it takes 3d6 psychic damage and must immediately use its reaction, if available, to move as far as its speed allows away from you.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_divine_favor',
    category: 'spell',
    name: 'Divine Favor',
    summary:
        'Bonus action: Your weapon attacks deal an extra 1d4 radiant damage on a hit for 1 minute.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 bonus action',
      'range': 'Self',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['paladin'],
      'description':
          'Your prayer empowers you with divine radiance. Until the spell ends, your weapon attacks deal an extra 1d4 radiant damage on a hit.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_entangle',
    category: 'spell',
    name: 'Entangle',
    summary:
        'Grasping plants turn a 20-ft square into difficult terrain and restrain creatures on failed STR save.',
    data: {
      'level': 1,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '90 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['druid'],
      'description':
          'Grasping weeds and vines sprout from the ground in a 20-foot square starting from a point within range. For the duration, these plants turn the ground in the area into difficult terrain. A creature in the area when you cast the spell must succeed on a Strength saving throw or be restrained.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_expeditious_retreat',
    category: 'spell',
    name: 'Expeditious Retreat',
    summary:
        'Bonus action: Take the Dash action immediately and as a bonus action on each of your turns.',
    data: {
      'level': 1,
      'school': 'Transmutation',
      'castingTime': '1 bonus action',
      'range': 'Self',
      'components': 'V, S',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['sorcerer', 'warlock', 'wizard'],
      'description':
          'This spell allows you to move at an incredible pace. When you cast this spell, and then as a bonus action on each of your turns until the spell ends, you can take the Dash action.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_faerie_fire',
    category: 'spell',
    name: 'Faerie Fire',
    summary:
        'Objects and creatures in a 20-ft cube glow; attack rolls against affected targets have advantage.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'druid'],
      'description':
          'Each object in a 20-foot cube within range is outlined in blue, green, or violet light. Any creature in the area when the spell is cast is also outlined if it fails a Dexterity saving throw. For the duration, attack rolls against affected creatures or objects have advantage if the attacker can see them, and they can\'t benefit from being invisible.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_false_life',
    category: 'spell',
    name: 'False Life',
    summary:
        'Bolster yourself with a necromantic facsimile of life, gaining 1d4 + 4 temporary hit points.',
    data: {
      'level': 1,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S, M (a small amount of alcohol or distilled spirits)',
      'duration': '1 hour',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'Bolstering yourself with a necromantic facsimile of life, you gain 1d4 + 4 temporary hit points for the duration. Casting at higher levels grants 5 additional temporary hit points for each slot level above 1st.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_feather_fall',
    category: 'spell',
    name: 'Feather Fall',
    summary:
        'Reaction: Slow the rate of descent of up to 5 falling creatures to 60 ft/round, taking no damage.',
    data: {
      'level': 1,
      'school': 'Transmutation',
      'castingTime': '1 reaction',
      'range': '60 feet',
      'components': 'V, M (a small feather or piece of down)',
      'duration': '1 minute',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'Choose up to five falling creatures within range. A falling creature\'s rate of descent slows to 60 feet per round until the spell ends. If the creature lands before the spell ends, it takes no falling damage and can land on its feet.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_fog_cloud',
    category: 'spell',
    name: 'Fog Cloud',
    summary:
        'Create a 20-foot-radius sphere of fog that heavily obscures the area.',
    data: {
      'level': 1,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['druid', 'ranger', 'sorcerer', 'wizard'],
      'description':
          'You create a 20-foot-radius sphere of fog centered on a point within range. The sphere spreads around corners, and its area is heavily obscured. It lasts for the duration or until a wind of moderate or greater speed (at least 10 mph) disperses it.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_goodberry',
    category: 'spell',
    name: 'Goodberry',
    summary:
        'Infuse up to 10 berries with magic: eating one restores 1 HP and provides nourishment for a day.',
    data: {
      'level': 1,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (a sprig of mistletoe)',
      'duration': '24 hours',
      'classes': ['druid', 'ranger'],
      'description':
          'Up to ten berries appear in your hand and are infused with magic for the duration. A creature can use its action to eat one berry. Eating a berry restores 1 hit point, and the berry provides enough nourishment to sustain a creature for one day.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_grease',
    category: 'spell',
    name: 'Grease',
    summary:
        'Slick grease covers a 10-ft square; creatures that enter or start turns there must make DEX save or fall prone.',
    data: {
      'level': 1,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a bit of pork rind or butter)',
      'duration': '1 minute',
      'classes': ['wizard'],
      'description':
          'Slick grease covers the ground in a 10-foot square centered on a point within range and turns it into difficult terrain for the duration. When the grease appears, each creature standing in its area must succeed on a Dexterity saving throw or fall prone.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_guiding_bolt',
    category: 'spell',
    name: 'Guiding Bolt',
    summary:
        'Flash of light deals 4d6 radiant damage and grants advantage on the next attack roll against target.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': '1 round',
      'classes': ['cleric'],
      'description':
          'A flash of light streaks toward a creature of your choice within range. Make a ranged spell attack against the target. On a hit, the target takes 4d6 radiant damage, and the next attack roll made against this target before the end of your next turn has advantage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_healing_word',
    category: 'spell',
    name: 'Healing Word',
    summary:
        'Bonus action: A creature of your choice within 60 ft regains 1d4 + spellcasting modifier HP.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 bonus action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['bard', 'cleric', 'druid'],
      'description':
          'A creature of your choice that you can see within range regains hit points equal to 1d4 + your spellcasting ability modifier. This spell has no effect on undead or constructs.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_hellish_rebuke',
    category: 'spell',
    name: 'Hellish Rebuke',
    summary:
        'Reaction: Creature that damaged you is engulfed in flames, taking 2d10 fire damage (DEX save half).',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 reaction',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['warlock'],
      'description':
          'You point your finger, and the creature that damaged you is momentarily surrounded by hellish flames. The creature must make a Dexterity saving throw. It takes 2d10 fire damage on a failed save, or half as much damage on a successful one.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_heroism',
    category: 'spell',
    name: 'Heroism',
    summary:
        'A willing creature is immune to being frightened and gains spellcasting mod temp HP each turn.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'paladin'],
      'description':
          'A willing creature you touch is imbued with bravery. Until the spell ends, the creature is immune to being frightened and gains temporary hit points equal to your spellcasting ability modifier at the start of each of its turns.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_hideous_laughter',
    category: 'spell',
    name: 'Hideous Laughter',
    summary:
        'A creature perceives everything as hilarious, falling prone and incapacitated on a failed WIS save.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S, M (tiny tarts and a feather)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'wizard'],
      'description':
          'A creature of your choice that you can see within range perceives everything as humorously hilarious. The target must succeed on a Wisdom saving throw or fall prone, becoming incapacitated and unable to stand up for the duration.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_hunters_mark',
    category: 'spell',
    name: 'Hunter\'s Mark',
    summary:
        'Bonus action: Deal +1d6 damage to quarry on weapon hits and gain advantage to track it.',
    data: {
      'level': 1,
      'school': 'Divination',
      'castingTime': '1 bonus action',
      'range': '90 feet',
      'components': 'V',
      'duration': 'Concentration, up to 1 hour',
      'classes': ['ranger'],
      'description':
          'You choose a creature you can see within range and mystically mark it as your quarry. Until the spell ends, you deal an extra 1d6 damage to the target whenever you hit it with a weapon attack, and you have advantage on any Wisdom (Perception) or Wisdom (Survival) check you make to find it.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_identify',
    category: 'spell',
    name: 'Identify',
    summary:
        'Learn the properties, charges, and magic of an item or spell affecting a creature. Ritual.',
    data: {
      'level': 1,
      'school': 'Divination',
      'castingTime': '1 minute',
      'range': 'Touch',
      'components':
          'V, S, M (a pearl worth at least 100 gp and an owl feather)',
      'duration': 'Instantaneous',
      'ritual': true,
      'classes': ['bard', 'wizard'],
      'description':
          'You choose one object that you must touch throughout the casting of the spell. If it is a magic item or some other magic-imbued object, you learn its properties and how to use them, whether it requires attunement to use, and how many charges it has, if any.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_inflict_wounds',
    category: 'spell',
    name: 'Inflict Wounds',
    summary: 'Make a melee spell attack dealing 3d10 necrotic damage on a hit.',
    data: {
      'level': 1,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['cleric'],
      'description':
          'Make a melee spell attack against a creature you can reach. On a hit, the target takes 3d10 necrotic damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_jump',
    category: 'spell',
    name: 'Jump',
    summary: 'Touch a creature to triple its jump distance for 1 minute.',
    data: {
      'level': 1,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (a grasshopper\'s hind leg)',
      'duration': '1 minute',
      'classes': ['druid', 'ranger', 'sorcerer', 'wizard'],
      'description':
          'You touch a creature. The creature\'s jump distance is tripled until the spell ends.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_longstrider',
    category: 'spell',
    name: 'Longstrider',
    summary: 'Touch a creature to increase its speed by 10 feet for 1 hour.',
    data: {
      'level': 1,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (a pinch of dirt)',
      'duration': '1 hour',
      'classes': ['bard', 'druid', 'ranger', 'wizard'],
      'description':
          'You touch a creature. The target\'s speed increases by 10 feet until the spell ends.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_mage_armor',
    category: 'spell',
    name: 'Mage Armor',
    summary:
        'Touch an unarmored creature to set its base AC to 13 + Dexterity modifier for 8 hours.',
    data: {
      'level': 1,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (a piece of cured leather)',
      'duration': '8 hours',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You touch a willing creature who isn\'t wearing armor, and a protective magical force surrounds it until the spell ends. The target\'s base AC becomes 13 + its Dexterity modifier. The spell ends if the target dons armor or if you dismiss the spell as an action.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_magic_missile',
    category: 'spell',
    name: 'Magic Missile',
    summary:
        'Creates 3 glowing darts that unerringly hit for 1d4 + 1 force damage each.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You create three glowing darts of magical force. Each dart hits a creature of your choice that you can see within range. A dart deals 1d4 + 1 force damage to its target. The darts all strike simultaneously, and you can direct them to hit one creature or several.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_protection_from_evil_and_good',
    category: 'spell',
    name: 'Protection from Evil and Good',
    summary:
        'Wards a willing creature: aberrations, celestials, elementals, fey, fiends, and undead have disadv on attacks against it.',
    data: {
      'level': 1,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (holy water or powdered silver and iron)',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['cleric', 'paladin', 'warlock', 'wizard'],
      'description':
          'Until the spell ends, one willing creature you touch is protected against aberrations, celestials, elementals, fey, fiends, and undead. Attack rolls against the target by these creatures have disadvantage, and the target cannot be charmed, frightened, or possessed by them.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_purify_food_and_drink',
    category: 'spell',
    name: 'Purify Food and Drink',
    summary:
        'All nonmagical food and drink within a 5-foot sphere is purified and freed of poison and disease. Ritual.',
    data: {
      'level': 1,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '10 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'ritual': true,
      'classes': ['cleric', 'druid', 'paladin'],
      'description':
          'All nonmagical food and drink within a 5-foot-radius sphere centered on a point of your choice within range is purified and freed of poison and disease.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_sanctuary',
    category: 'spell',
    name: 'Sanctuary',
    summary:
        'Bonus action: Ward a creature. Enemies attempting to attack or harm it must pass a WIS save or choose new target.',
    data: {
      'level': 1,
      'school': 'Abjuration',
      'castingTime': '1 bonus action',
      'range': '30 feet',
      'components': 'V, S, M (a small silver mirror)',
      'duration': '1 minute',
      'classes': ['cleric'],
      'description':
          'You ward a creature within range against attack. Until the spell ends, any creature who targets the warded creature with an attack or a harmful spell must first make a Wisdom saving throw. On a failed save, the creature must choose a new target or lose the attack or spell.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_shield',
    category: 'spell',
    name: 'Shield',
    summary:
        'Reaction: +5 bonus to AC until start of your next turn and take no damage from Magic Missile.',
    data: {
      'level': 1,
      'school': 'Abjuration',
      'castingTime': '1 reaction',
      'range': 'Self',
      'components': 'V, S',
      'duration': '1 round',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'An invisible barrier of magical force appears and protects you. Until the start of your next turn, you have a +5 bonus to AC, including against the triggering attack, and you take no damage from magic missile.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_shield_of_faith',
    category: 'spell',
    name: 'Shield of Faith',
    summary:
        'Bonus action: A shimmering field grants a chosen creature within 60 ft a +2 bonus to AC for 10 minutes.',
    data: {
      'level': 1,
      'school': 'Abjuration',
      'castingTime': '1 bonus action',
      'range': '60 feet',
      'components':
          'V, S, M (a small parchment with a bit of holy text written on it)',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['cleric', 'paladin'],
      'description':
          'A shimmering field appears and surrounds a creature of your choice within range, granting it a +2 bonus to AC for the duration.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_silent_image',
    category: 'spell',
    name: 'Silent Image',
    summary:
        'Create an image of an object, creature, or visible phenomenon up to a 15-foot cube. Purely visual.',
    data: {
      'level': 1,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a bit of fleece)',
      'duration': 'Concentration, up to 10 minutes',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'You create the image of an object, a creature, or some other visible phenomenon that is no larger than a 15-foot cube. The image seems completely real, but it produces no sound, smell, or other sensory effects.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_sleep',
    category: 'spell',
    name: 'Sleep',
    summary:
        'Send 5d8 hit points of creatures into a magical slumber for 1 minute in a 20-foot radius.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '90 feet',
      'components':
          'V, S, M (a pinch of fine sand, sweet rose petals, or a cricket)',
      'duration': '1 minute',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'This spell sends creatures into a magical slumber. Roll 5d8; the total is how many hit points of creatures this spell can affect. Creatures within 20 feet of a point you choose are affected in ascending order of their current hit points. Undead and creatures immune to being charmed are unaffected.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_speak_with_animals',
    category: 'spell',
    name: 'Speak with Animals',
    summary:
        'Gain the ability to comprehend and verbally communicate with beasts for 10 minutes. Ritual.',
    data: {
      'level': 1,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S',
      'duration': '10 minutes',
      'ritual': true,
      'classes': ['bard', 'druid', 'ranger'],
      'description':
          'You gain the ability to comprehend and verbally communicate with beasts for the duration. The knowledge and awareness of many beasts is limited by their intelligence, but at minimum, beasts can give you information about nearby locations and monsters.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_thunderwave',
    category: 'spell',
    name: 'Thunderwave',
    summary:
        'Wave of thunderous force deals 2d8 thunder damage and pushes creatures 10 ft (CON save half).',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Self (15-foot cube)',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['bard', 'druid', 'sorcerer', 'wizard'],
      'description':
          'A wave of thunderous force sweeps out from you. Each creature in a 15-foot cube originating from you must make a Constitution saving throw. On a failed save, a creature takes 2d8 thunder damage and is pushed 10 feet away from you. On a successful save, the creature takes half as much damage and isn\'t pushed.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_unseen_servant',
    category: 'spell',
    name: 'Unseen Servant',
    summary:
        'Creates an invisible, mindless, shapeless force that performs simple tasks at your command. Ritual.',
    data: {
      'level': 1,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S, M (a piece of string and a bit of wood)',
      'duration': '1 hour',
      'ritual': true,
      'classes': ['bard', 'warlock', 'wizard'],
      'description':
          'This spell creates an invisible, mindless, shapeless, Medium force that performs simple tasks at your command until the spell ends. The servant springs into existence in an unoccupied space on the ground within range. It has AC 10, 1 hit point, and a Strength of 2.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_wrathful_smite',
    category: 'spell',
    name: 'Wrathful Smite',
    summary:
        'Bonus action: Next melee weapon hit deals +1d6 psychic damage and target must make WIS save or be frightened.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 bonus action',
      'range': 'Self',
      'components': 'V',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['paladin'],
      'description':
          'The next time you hit with a melee weapon attack during this spell\'s duration, your attack deals an extra 1d6 psychic damage. Additionally, if the target is a creature, it must make a Wisdom saving throw or be frightened of you until the spell ends.',
    },
  ),
];

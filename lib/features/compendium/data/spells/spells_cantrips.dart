import '../../models/compendium_entry.dart';

/// SRD 5.1 Cantrips (Level 0)
final List<CompendiumEntry> srdCantrips = [
  CompendiumEntry(
    id: 'srd_spell_acid_splash',
    category: 'spell',
    name: 'Acid Splash',
    summary:
        'Hurls an acid bubble targeting one creature or two within 5 feet. 1d6 acid damage on failed DEX save.',
    data: {
      'level': 0,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You hurl a bubble of acid. Choose one creature within range, or choose two creatures within range that are within 5 feet of each other. A target must succeed on a Dexterity saving throw or take 1d6 acid damage. The damage increases by 1d6 at 5th, 11th, and 17th level.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_blade_ward',
    category: 'spell',
    name: 'Blade Ward',
    summary:
        'Gain resistance against bludgeoning, piercing, and slashing damage until end of next turn.',
    data: {
      'level': 0,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S',
      'duration': '1 round',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You extend your hand and trace a sigil of warding in the air. Until the end of your next turn, you have resistance against bludgeoning, piercing, and slashing damage dealt by weapon attacks.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_chill_touch',
    category: 'spell',
    name: 'Chill Touch',
    summary:
        'Ranged spell attack deals 1d8 necrotic damage and prevents target from healing until your next turn.',
    data: {
      'level': 0,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': '1 round',
      'classes': ['sorcerer', 'warlock', 'wizard'],
      'description':
          'You create a ghostly, skeletal hand in the space of a creature within range. Make a ranged spell attack. On a hit, the target takes 1d8 necrotic damage, and it can\'t regain hit points until the start of your next turn. If the target is undead, it also has disadvantage on attack rolls against you until then.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_dancing_lights',
    category: 'spell',
    name: 'Dancing Lights',
    summary:
        'Create up to four torch-like lights that illuminate a 10-foot radius and move as a bonus action.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S, M (a bit of phosphorus or witchwood, or a glowworm)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'You create up to four torch-sized lights within range, making them appear as torches, lanterns, or glowing orbs. Each light sheds dim light in a 10-foot radius. As a bonus action on your turn, you can move the lights up to 60 feet.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_druidcraft',
    category: 'spell',
    name: 'Druidcraft',
    summary:
        'Whisper to nature to predict the weather, bloom a flower, or create minor sensory effects.',
    data: {
      'level': 0,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['druid'],
      'description':
          'Whispering to the spirits of nature, you create one of several minor effects: predict weather for the next 24 hours, make a flower blossom or seed pod open, create an instantaneous harmless sensory effect, or light/snuff a small flame.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_eldritch_blast',
    category: 'spell',
    name: 'Eldritch Blast',
    summary:
        'Beam of crackling energy deals 1d10 force damage on ranged spell hit.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['warlock'],
      'description':
          'A beam of crackling energy streaks toward a creature within range. Make a ranged spell attack against the target. On a hit, the target takes 1d10 force damage. The spell creates more beams at higher levels: two at 5th, three at 11th, and four at 17th level.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_fire_bolt',
    category: 'spell',
    name: 'Fire Bolt',
    summary:
        'Ranged spell attack dealing 1d10 fire damage. Ignites flammable objects.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'You hurl a mote of fire at a creature or object within range. Make a ranged spell attack against the target. On a hit, the target takes 1d10 fire damage. Flammable objects hit by this spell ignite if not being worn or carried.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_friends',
    category: 'spell',
    name: 'Friends',
    summary:
        'Gain advantage on all Charisma checks directed at one non-hostile creature for up to 1 minute.',
    data: {
      'level': 0,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': 'Self',
      'components':
          'S, M (a small amount of makeup applied to the face as this spell is cast)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'For the duration, you have advantage on all Charisma checks directed at one creature of your choice that isn\'t hostile toward you. When the spell ends, the creature realizes that you used magic to influence its mood and becomes hostile toward you.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_guidance',
    category: 'spell',
    name: 'Guidance',
    summary:
        'Touch a willing creature to add +1d4 to one ability check of its choice.',
    data: {
      'level': 0,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['cleric', 'druid'],
      'description':
          'You touch one willing creature. Once before the spell ends, the target can roll a d4 and add the number rolled to one ability check of its choice. It can roll the die before or after making the ability check.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_light',
    category: 'spell',
    name: 'Light',
    summary:
        'Touch an object to shed bright light in a 20-foot radius and dim light for an additional 20 feet for 1 hour.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, M (a firefly or phosphorescent moss)',
      'duration': '1 hour',
      'classes': ['bard', 'cleric', 'sorcerer', 'wizard'],
      'description':
          'You touch one object that is no larger than 10 feet in any dimension. Until the spell ends, the object sheds bright light in a 20-foot radius and dim light for an additional 20 feet. The light can be colored as you like.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_mage_hand',
    category: 'spell',
    name: 'Mage Hand',
    summary:
        'Creates a spectral floating hand to manipulate objects up to 10 lbs at range.',
    data: {
      'level': 0,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S',
      'duration': '1 minute',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'A spectral, floating hand appears at a point you choose within range. The hand lasts for the duration or until you dismiss it as an action. You can use your action to control the hand to manipulate an object, open an unlocked door, or pour out a vial.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_mending',
    category: 'spell',
    name: 'Mending',
    summary:
        'Repairs a single break or tear in an object, such as a broken chain link or torn cloak.',
    data: {
      'level': 0,
      'school': 'Transmutation',
      'castingTime': '1 minute',
      'range': 'Touch',
      'components': 'V, S, M (two lodestones)',
      'duration': 'Instantaneous',
      'classes': ['bard', 'cleric', 'druid', 'sorcerer', 'wizard'],
      'description':
          'This spell repairs a single break or tear in an object you touch, such as a broken chain link, two halves of a broken key, a torn cloak, or a leaking wineskin. As long as the break or tear is no larger than 1 foot in any dimension, you mend it.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_message',
    category: 'spell',
    name: 'Message',
    summary:
        'Whisper a message to a creature within 120 feet that can reply in a whisper only you hear.',
    data: {
      'level': 0,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S, M (a short piece of copper wire)',
      'duration': '1 round',
      'classes': ['bard', 'sorcerer', 'wizard'],
      'description':
          'You point your finger toward a creature within range and whisper a message. The target (and only the target) hears the message and can reply in a whisper that only you can hear. It can pass through most magical barriers and walls up to 1 foot of stone.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_minor_illusion',
    category: 'spell',
    name: 'Minor Illusion',
    summary:
        'Creates a sound or an image of an object within range for up to 1 minute.',
    data: {
      'level': 0,
      'school': 'Illusion',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'S, M (a bit of fleece)',
      'duration': '1 minute',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You create a sound or an image of an object within range that lasts for the duration. The illusion also ends if you dismiss it as an action or cast this spell again. If you create an image, it must no larger than a 5-foot cube and cannot create sound or smell.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_poison_spray',
    category: 'spell',
    name: 'Poison Spray',
    summary:
        'Project a puff of noxious gas dealing 1d12 poison damage on a failed CON save.',
    data: {
      'level': 0,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '10 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['druid', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You extend your hand toward a creature you can see within range and project a puff of noxious gas. The creature must succeed on a Constitution saving throw or take 1d12 poison damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_prestidigitation',
    category: 'spell',
    name: 'Prestidigitation',
    summary:
        'Perform minor magical tricks, light/snuff candles, clean/soil objects, or chill/warm food.',
    data: {
      'level': 0,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '10 feet',
      'components': 'V, S',
      'duration': 'Up to 1 hour',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'This spell is a minor magical trick that novice spellcasters use for practice. You create an instantaneous sensory effect, light or snuff a candle, clean or soil an object, chill/warm/flavor up to 1 cubic foot of nonliving material, make a small mark appear, or create a trinket.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_produce_flame',
    category: 'spell',
    name: 'Produce Flame',
    summary:
        'Flickering flame in hand sheds bright light in 10-ft radius, or hurl it for 1d8 fire damage.',
    data: {
      'level': 0,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': 'Self (30 feet throw)',
      'components': 'V, S',
      'duration': '10 minutes',
      'classes': ['druid'],
      'description':
          'A flickering flame appears in your hand. The flame sheds bright light in a 10-foot radius and dim light for an additional 10 feet. When you cast this spell, or as an action on a later turn, you can hurl the flame at a creature within 30 feet of you. Make a ranged spell attack dealing 1d8 fire damage on hit.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_ray_of_frost',
    category: 'spell',
    name: 'Ray of Frost',
    summary:
        'Frigid beam deals 1d8 cold damage and reduces target speed by 10 ft.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'A frigid beam of blue-white light streaks toward a creature within range. Make a ranged spell attack against the target. On a hit, it takes 1d8 cold damage, and its speed is reduced by 10 feet until the start of your next turn.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_resistance',
    category: 'spell',
    name: 'Resistance',
    summary:
        'Touch a willing creature to add +1d4 to one saving throw of its choice.',
    data: {
      'level': 0,
      'school': 'Abjuration',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S, M (a miniature cloak)',
      'duration': 'Concentration, up to 1 minute',
      'classes': ['cleric', 'druid'],
      'description':
          'You touch one willing creature. Once before the spell ends, the target can roll a d4 and add the number rolled to one saving throw of its choice. It can roll the die before or after making the saving throw.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_sacred_flame',
    category: 'spell',
    name: 'Sacred Flame',
    summary:
        'Radiant flame descends on target, dealing 1d8 radiant damage on failed DEX save.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['cleric'],
      'description':
          'Flame-like radiance descends on a creature that you can see within range. The target must succeed on a Dexterity saving throw or take 1d8 radiant damage. The target gains no benefit from cover for this saving throw.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_shillelagh',
    category: 'spell',
    name: 'Shillelagh',
    summary:
        'Imbue wooden club or quarterstaff to use spellcasting ability for attacks and deal 1d8 damage.',
    data: {
      'level': 0,
      'school': 'Transmutation',
      'castingTime': '1 bonus action',
      'range': 'Touch',
      'components':
          'V, S, M (mistletoe, a shamrock leaf, and a club or quarterstaff)',
      'duration': '1 minute',
      'classes': ['druid'],
      'description':
          'The wood of a club or quarterstaff you are holding is imbued with nature\'s power. For the duration, you can use your spellcasting ability instead of Strength for the attack and damage rolls of melee attacks using that weapon, and the weapon\'s damage die becomes a d8. The weapon also becomes magical.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_shocking_grasp',
    category: 'spell',
    name: 'Shocking Grasp',
    summary:
        'Lightning springs from your hand dealing 1d8 lightning damage; target cannot take reactions.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['sorcerer', 'wizard'],
      'description':
          'Lightning springs from your hand to deliver a shock to a creature you try to touch. Make a melee spell attack against the target. You have advantage on the attack roll if the target is wearing armor made of metal. On a hit, the target takes 1d8 lightning damage, and it can\'t take reactions until the start of its next turn.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_spare_the_dying',
    category: 'spell',
    name: 'Spare the Dying',
    summary:
        'Touch a living creature that has 0 hit points to immediately stabilize it.',
    data: {
      'level': 0,
      'school': 'Necromancy',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'classes': ['cleric'],
      'description':
          'You touch a living creature that has 0 hit points. The creature becomes stable. This spell has no effect on undead or constructs.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_thaumaturgy',
    category: 'spell',
    name: 'Thaumaturgy',
    summary:
        'Manifest minor wonder: boom voice, flicker flames, tremor ground, or unlock doors.',
    data: {
      'level': 0,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V',
      'duration': 'Up to 1 minute',
      'classes': ['cleric'],
      'description':
          'You manifest a minor wonder, a sign of supernatural power, within range: your voice booms up to three times as loud for 1 minute, you cause flames to flicker or brighten, you cause harmless tremors in the ground, you cause sound effects, or you cause an unlocked door or window to fly open or slam shut.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_thorn_whip',
    category: 'spell',
    name: 'Thorn Whip',
    summary:
        'Vine-like whip deals 1d6 piercing damage and pulls Large or smaller target up to 10 ft closer.',
    data: {
      'level': 0,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S, M (the stem of a plant with thorns)',
      'duration': 'Instantaneous',
      'classes': ['druid'],
      'description':
          'You create a long, vine-like whip covered in thorns that lashes out at your command toward a creature in range. Make a melee spell attack. On a hit, the creature takes 1d6 piercing damage, and if the creature is Large or smaller, you pull the creature up to 10 feet closer to you.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_true_strike',
    category: 'spell',
    name: 'True Strike',
    summary:
        'Point at a target to gain advantage on your first attack roll against it on your next turn.',
    data: {
      'level': 0,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'S',
      'duration': 'Concentration, up to 1 round',
      'classes': ['bard', 'sorcerer', 'warlock', 'wizard'],
      'description':
          'You extend your hand and point a finger at a target in range. Your magic grants you a brief insight into the target\'s defenses. On your next turn, you gain advantage on your first attack roll against the target, provided the spell hasn\'t ended.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_vicious_mockery',
    category: 'spell',
    name: 'Vicious Mockery',
    summary:
        'Insults dealing 1d4 psychic damage and disadvantage on the next attack roll.',
    data: {
      'level': 0,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'classes': ['bard'],
      'description':
          'You unleash a string of insults laced with subtle enchantments at a creature you can see within range. If the target can hear you, it must succeed on a Wisdom saving throw or take 1d4 psychic damage and have disadvantage on the next attack roll it makes before the end of its next turn.',
    },
  ),
];

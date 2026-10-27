import 'dart:convert';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/compendium_entry.dart';

/// Bundled SRD 5.1 dataset for instant offline search and sheet importing.
final List<CompendiumEntry> bundledSrdEntries = [
  // --- Cantrips ---
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
      'description':
          'You hurl a mote of fire at a creature or object within range. Make a ranged spell attack against the target. On a hit, the target takes 1d10 fire damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_mage_hand',
    category: 'spell',
    name: 'Mage Hand',
    summary: 'Creates a spectral floating hand to manipulate objects at range.',
    data: {
      'level': 0,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S',
      'duration': '1 minute',
      'description':
          'A spectral, floating hand appears at a point you choose within range. The hand lasts for the duration or until you dismiss it as an action.',
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
      'description':
          'You touch one willing creature. Once before the spell ends, the target can roll a d4 and add the number rolled to one ability check of its choice.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_eldritch_blast',
    category: 'spell',
    name: 'Eldritch Blast',
    summary: 'Beam of crackling energy deals 1d10 force damage on hit.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'description':
          'A beam of crackling energy streaks toward a creature within range. Make a ranged spell attack against the target. On a hit, the target takes 1d10 force damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_sacred_flame',
    category: 'spell',
    name: 'Sacred Flame',
    summary:
        'Flame-like radiance descends on a creature, dealing 1d8 radiant damage on DEX save fail.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'description':
          'Flame-like radiance descends on a creature that you can see within range. The target must succeed on a Dexterity saving throw or take 1d8 radiant damage.',
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
      'description':
          'You unleash a string of insults laced with subtle enchantments at a creature you can see within range. If the target can hear you, it must succeed on a Wisdom saving throw or take 1d4 psychic damage and have disadvantage on the next attack roll it makes before the end of its next turn.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_druidcraft',
    category: 'spell',
    name: 'Druidcraft',
    summary:
        'Whisper to nature to predict the weather, bloom a flower, or create sensory effects.',
    data: {
      'level': 0,
      'school': 'Transmutation',
      'castingTime': '1 action',
      'range': '30 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'description':
          'Whispering to the spirits of nature, you create one of several minor effects: predict weather for the next 24 hours, make a flower blossom or seed pod open, create an instantaneous harmless sensory effect, or light/snuff a small flame.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_ray_of_frost',
    category: 'spell',
    name: 'Ray of Frost',
    summary:
        'A frigid beam dealing 1d8 cold damage and reducing target speed by 10 ft.',
    data: {
      'level': 0,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'description':
          'A frigid beam of blue-white light streaks toward a creature within range. Make a ranged spell attack against the target. On a hit, it takes 1d8 cold damage, and its speed is reduced by 10 feet until the start of your next turn.',
    },
  ),

  // --- 1st Level Spells ---
  CompendiumEntry(
    id: 'srd_spell_cure_wounds',
    category: 'spell',
    name: 'Cure Wounds',
    summary: 'A creature you touch regains 1d8 + spellcasting modifier HP.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Touch',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'description':
          'A creature you touch regains a number of hit points equal to 1d8 + your spellcasting ability modifier.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_healing_word',
    category: 'spell',
    name: 'Healing Word',
    summary:
        'A creature of your choice within 60 ft regains 1d4 + spellcasting modifier HP as a bonus action.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 bonus action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'description':
          'A creature of your choice that you can see within range regains hit points equal to 1d4 + your spellcasting ability modifier.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_thunderwave',
    category: 'spell',
    name: 'Thunderwave',
    summary:
        'Wave of thunderous force deals 2d8 thunder damage and pushes creatures 10 ft.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': 'Self (15-foot cube)',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'description':
          'A wave of thunderous force sweeps out from you. Each creature in a 15-foot cube originating from you must make a Constitution saving throw. On a failed save, a creature takes 2d8 thunder damage and is pushed 10 feet away from you. On a successful save, the creature takes half as much damage and isn\'t pushed.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_entangle',
    category: 'spell',
    name: 'Entangle',
    summary:
        'Grasping weeds and vines sprout in a 20-ft square, restraining creatures.',
    data: {
      'level': 1,
      'school': 'Conjuration',
      'castingTime': '1 action',
      'range': '90 feet',
      'components': 'V, S',
      'duration': 'Concentration, up to 1 minute',
      'description':
          'Grasping weeds and vines sprout from the ground in a 20-foot square starting from a point within range. For the duration, these plants turn the ground in the area into difficult terrain. A creature in the area when you cast the spell must succeed on a Strength saving throw or be restrained.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_dissonant_whispers',
    category: 'spell',
    name: 'Dissonant Whispers',
    summary:
        'Whispers deal 3d6 psychic damage and force target to immediately flee.',
    data: {
      'level': 1,
      'school': 'Enchantment',
      'castingTime': '1 action',
      'range': '60 feet',
      'components': 'V',
      'duration': 'Instantaneous',
      'description':
          'You whisper a discordant melody that only one creature of your choice within range can hear. The target must make a Wisdom saving throw. On a failed save, it takes 3d6 psychic damage and must immediately use its reaction, if available, to move as far as its speed allows away from you.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_hunters_mark',
    category: 'spell',
    name: 'Hunter\'s Mark',
    summary:
        'Mark a quarry to deal +1d6 damage on weapon hits and gain advantage to track it.',
    data: {
      'level': 1,
      'school': 'Divination',
      'castingTime': '1 bonus action',
      'range': '90 feet',
      'components': 'V',
      'duration': 'Concentration, up to 1 hour',
      'description':
          'You choose a creature you can see within range and mystically mark it as your quarry. Until the spell ends, you deal an extra 1d6 damage to the target whenever you hit it with a weapon attack, and you have advantage on any Wisdom (Perception) or Wisdom (Survival) check you make to find it.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_magic_missile',
    category: 'spell',
    name: 'Magic Missile',
    summary:
        'Creates 3 glowing darts that automatically hit for 1d4 + 1 force damage each.',
    data: {
      'level': 1,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'description':
          'You create three glowing darts of magical force. Each dart hits a creature of your choice that you can see within range. A dart deals 1d4 + 1 force damage.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_shield',
    category: 'spell',
    name: 'Shield',
    summary:
        'Reaction: +5 bonus to AC until the start of your next turn and take no damage from magic missile.',
    data: {
      'level': 1,
      'school': 'Abjuration',
      'castingTime': '1 reaction',
      'range': 'Self',
      'components': 'V, S',
      'duration': '1 round',
      'description':
          'An invisible barrier of magical force appears and protects you. Until the start of your next turn, you have a +5 bonus to AC, including against the triggering attack, and you take no damage from magic missile.',
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
      'description':
          'You bless up to three creatures of your choice within range. Whenever a target makes an attack roll or a saving throw before the spell ends, the target can roll a d4 and add the number rolled to the attack roll or saving throw.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_detect_magic',
    category: 'spell',
    name: 'Detect Magic',
    summary:
        'Senses the presence of magic within 30 feet. Can be cast as a ritual.',
    data: {
      'level': 1,
      'school': 'Divination',
      'castingTime': '1 action',
      'range': 'Self',
      'components': 'V, S',
      'duration': 'Concentration, up to 10 minutes',
      'ritual': true,
      'description':
          'For the duration, you sense the presence of magic within 30 feet of you. If you sense magic in this way, you can use your action to see a faint aura around any visible creature or object.',
    },
  ),

  // --- 2nd Level Spells ---
  CompendiumEntry(
    id: 'srd_spell_misty_step',
    category: 'spell',
    name: 'Misty Step',
    summary:
        'Bonus action: Teleport up to 30 feet to an unoccupied space you can see.',
    data: {
      'level': 2,
      'school': 'Conjuration',
      'castingTime': '1 bonus action',
      'range': 'Self',
      'components': 'V',
      'duration': 'Instantaneous',
      'description':
          'Briefly surrounded by silvery mist, you teleport up to 30 feet to an unoccupied space that you can see.',
    },
  ),
  CompendiumEntry(
    id: 'srd_spell_scorching_ray',
    category: 'spell',
    name: 'Scorching Ray',
    summary:
        'Hurls 3 rays of fire: make a ranged spell attack for each ray dealing 2d6 fire damage on hit.',
    data: {
      'level': 2,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '120 feet',
      'components': 'V, S',
      'duration': 'Instantaneous',
      'description':
          'You create three rays of fire and hurl them at targets within range. You can hurl them at one target or several. Make a ranged spell attack for each ray. On a hit, the target takes 2d6 fire damage.',
    },
  ),

  // --- 3rd Level Spells ---
  CompendiumEntry(
    id: 'srd_spell_fireball',
    category: 'spell',
    name: 'Fireball',
    summary:
        'A bright streak flashes to a point within 150 ft, blossoming into a 20-ft radius sphere dealing 8d6 fire damage.',
    data: {
      'level': 3,
      'school': 'Evocation',
      'castingTime': '1 action',
      'range': '150 feet',
      'components': 'V, S, M (a tiny ball of bat guano and sulfur)',
      'duration': 'Instantaneous',
      'description':
          'Each creature in a 20-foot-radius sphere centered on that point must make a Dexterity saving throw. A target takes 8d6 fire damage on a failed save, or half as much damage on a successful one.',
    },
  ),

  // --- Armor ---
  CompendiumEntry(
    id: 'srd_armor_chain_mail',
    category: 'equipment',
    name: 'Chain Mail',
    summary:
        'Heavy armor made of interlocking metal rings. AC 16. Disadvantage on Stealth.',
    data: {
      'isArmor': true,
      'armorClass': 16,
      'category': 'Heavy Armor',
      'weight': 55.0,
      'cost': '75 gp',
      'stealthDisadvantage': true,
      'strengthRequirement': 13,
      'description':
          'Made of interlocking metal rings, chain mail includes a layer of quilted fabric worn underneath the mail to prevent chafing and to cushion the impact of blows.',
    },
  ),
  CompendiumEntry(
    id: 'srd_armor_shield',
    category: 'equipment',
    name: 'Shield',
    summary: 'Carried in one hand. Increases Armor Class by +2.',
    data: {
      'isArmor': true,
      'isShield': true,
      'armorClass': 2,
      'weight': 6.0,
      'cost': '10 gp',
      'description':
          'A shield is made from wood or metal and is carried in one hand. Wielding a shield increases your Armor Class by 2.',
    },
  ),
  CompendiumEntry(
    id: 'srd_armor_leather',
    category: 'equipment',
    name: 'Leather Armor',
    summary: 'Light armor made of boiled leather. AC 11 + DEX modifier.',
    data: {
      'isArmor': true,
      'armorClass': 11,
      'category': 'Light Armor',
      'weight': 10.0,
      'cost': '10 gp',
      'description':
          'The breastplate and shoulder protectors of this armor are made of leather that has been stiffened by being boiled in oil.',
    },
  ),
  CompendiumEntry(
    id: 'srd_armor_plate',
    category: 'equipment',
    name: 'Plate Armor',
    summary:
        'Full suit of interlocking metal plates. AC 18. Disadvantage on Stealth.',
    data: {
      'isArmor': true,
      'armorClass': 18,
      'category': 'Heavy Armor',
      'weight': 65.0,
      'cost': '1,500 gp',
      'stealthDisadvantage': true,
      'strengthRequirement': 15,
      'description':
          'Plate consists of shaped, interlocking metal plates to cover the entire body. A suit of plate includes gauntlets, heavy leather boots, a visored helmet, and thick layers of padding.',
    },
  ),

  // --- Weapons ---
  CompendiumEntry(
    id: 'srd_weapon_battleaxe',
    category: 'equipment',
    name: 'Battleaxe',
    summary: 'Versatile martial melee weapon. 1d8 slashing (1d10 two-handed).',
    data: {
      'isWeapon': true,
      'damage': '1d8 Slashing',
      'properties': 'Versatile (1d10)',
      'weight': 4.0,
      'cost': '10 gp',
      'description':
          'A sturdy double- or single-bladed axe balanced for deadly chops in melee combat.',
    },
  ),
  CompendiumEntry(
    id: 'srd_weapon_longsword',
    category: 'equipment',
    name: 'Longsword',
    summary: 'Versatile martial melee weapon. 1d8 slashing (1d10 two-handed).',
    data: {
      'isWeapon': true,
      'damage': '1d8 Slashing',
      'properties': 'Versatile (1d10)',
      'weight': 3.0,
      'cost': '15 gp',
      'description':
          'The classic adventurer sidearm, with a straight double-edged blade and crossguard.',
    },
  ),
  CompendiumEntry(
    id: 'srd_weapon_shortbow',
    category: 'equipment',
    name: 'Shortbow',
    summary: 'Simple ranged weapon. 1d6 piercing damage. Range 80/320.',
    data: {
      'isWeapon': true,
      'damage': '1d6 Piercing',
      'properties': 'Ammunition (range 80/320), two-handed',
      'weight': 2.0,
      'cost': '25 gp',
      'description': 'A small wooden bow easily fired from horseback or foot.',
    },
  ),
  CompendiumEntry(
    id: 'srd_weapon_dagger',
    category: 'equipment',
    name: 'Dagger',
    summary:
        'Simple melee weapon with finesse, light, thrown (range 20/60). 1d4 piercing.',
    data: {
      'isWeapon': true,
      'damage': '1d4 Piercing',
      'properties': 'Finesse, light, thrown (range 20/60)',
      'weight': 1.0,
      'cost': '2 gp',
      'description':
          'A small, concealable bladed weapon ideal for quick thrusts or throwing.',
    },
  ),

  // --- Adventuring Gear & Items ---
  CompendiumEntry(
    id: 'srd_item_potion_of_healing',
    category: 'equipment',
    name: 'Potion of Healing',
    summary:
        'Magical red potion. Drinking it or administering it restores 2d4 + 2 HP.',
    data: {
      'weight': 0.5,
      'cost': '50 gp',
      'description':
          'You regain 2d4 + 2 hit points when you drink this potion. The potion\'s red liquid glimmers when agitated.',
    },
  ),
  CompendiumEntry(
    id: 'srd_item_backpack',
    category: 'equipment',
    name: 'Backpack',
    summary: 'Can hold 1 cubic foot or 30 pounds of gear.',
    data: {
      'weight': 5.0,
      'cost': '2 gp',
      'description':
          'A sturdy leather pack worn over both shoulders for carrying gear.',
    },
  ),
  CompendiumEntry(
    id: 'srd_item_rope_hempen',
    category: 'equipment',
    name: 'Rope, Hempen (50 feet)',
    summary: 'Has 2 HP and can be burst with a DC 17 Strength check.',
    data: {
      'weight': 10.0,
      'cost': '1 gp',
      'description': '50 feet of sturdy braided hemp rope.',
    },
  ),

  // --- Features & Traits ---
  CompendiumEntry(
    id: 'srd_feature_action_surge',
    category: 'feature',
    name: 'Action Surge',
    summary:
        'Fighter 2nd level: Take one additional action on your turn (1/Short Rest).',
    data: {
      'source': 'Fighter (Level 2)',
      'recharge': 'Short or Long Rest',
      'usesMax': 1,
      'description':
          'You can push yourself beyond your normal limits for a moment. On your turn, you can take one additional action on top of your regular action and a possible bonus action.',
    },
  ),
  CompendiumEntry(
    id: 'srd_feature_second_wind',
    category: 'feature',
    name: 'Second Wind',
    summary:
        'Fighter 1st level: Use a bonus action to regain 1d10 + Fighter level HP (1/Short Rest).',
    data: {
      'source': 'Fighter (Level 1)',
      'recharge': 'Short or Long Rest',
      'usesMax': 1,
      'description':
          'You have a limited well of stamina that you can draw on to protect yourself from harm. On your turn, you can use a bonus action to regain hit points equal to 1d10 + your fighter level.',
    },
  ),
  CompendiumEntry(
    id: 'srd_feature_rage',
    category: 'feature',
    name: 'Rage',
    summary:
        'Barbarian 1st level: Advantage on STR checks/saves, bonus melee damage, resistance to bludgeoning, piercing, and slashing.',
    data: {
      'source': 'Barbarian (Level 1)',
      'recharge': 'Long Rest',
      'usesMax': 2,
      'description':
          'In battle, you fight with primal ferocity. On your turn, you can enter a rage as a bonus action.',
    },
  ),
  CompendiumEntry(
    id: 'srd_feature_sneak_attack',
    category: 'feature',
    name: 'Sneak Attack',
    summary:
        'Rogue 1st level: Deal extra damage to one creature you hit with an attack if you have advantage or an ally is adjacent.',
    data: {
      'source': 'Rogue (Level 1)',
      'recharge': 'At-Will (1/turn)',
      'description':
          'Once per turn, you can deal an extra 1d6 damage to one creature you hit with an attack if you have advantage on the attack roll.',
    },
  ),
  CompendiumEntry(
    id: 'srd_feature_bardic_inspiration',
    category: 'feature',
    name: 'Bardic Inspiration',
    summary:
        'Bard 1st level: Use a bonus action to give an ally an inspiration die (1d6) to add to one d20 roll.',
    data: {
      'source': 'Bard (Level 1)',
      'recharge': 'Long Rest',
      'usesMax': 3,
      'description':
          'You can inspire others through stirring words or music. As a bonus action on your turn, choose one other creature within 60 feet who can hear you. That creature gains one Bardic Inspiration die (1d6). Once within the next 10 minutes, the creature can roll the die and add the number rolled to one ability check, attack roll, or saving throw.',
    },
  ),
  CompendiumEntry(
    id: 'srd_feature_druidic',
    category: 'feature',
    name: 'Druidic',
    summary:
        'Druid 1st level: Speak and leave secret messages in the hidden language of druids.',
    data: {
      'source': 'Druid (Level 1)',
      'recharge': 'Passive',
      'description':
          'You know Druidic, the secret language of druids. You can speak the language and use it to leave hidden messages. Others who know this language automatically notice such a message.',
    },
  ),
  CompendiumEntry(
    id: 'srd_feature_wild_shape',
    category: 'feature',
    name: 'Wild Shape',
    summary:
        'Druid 2nd level: Use an action to magically assume the shape of a beast you have seen (2/Short Rest).',
    data: {
      'source': 'Druid (Level 2)',
      'recharge': 'Short or Long Rest',
      'usesMax': 2,
      'description':
          'You can use your action to magically assume the shape of a beast that you have seen before. You can use this feature twice, and regain expended uses when you finish a short or long rest.',
    },
  ),
  CompendiumEntry(
    id: 'srd_feature_natural_explorer',
    category: 'feature',
    name: 'Natural Explorer',
    summary:
        'Ranger 1st level: Expert navigation and survival benefits in chosen favored terrain.',
    data: {
      'source': 'Ranger (Level 1)',
      'recharge': 'Passive',
      'description':
          'You are particularly familiar with one type of natural environment and are adept at traveling and surviving in such regions. Difficult terrain doesn\'t slow your group\'s travel, and you remain alert to danger even when engaged in another activity while traveling.',
    },
  ),
  CompendiumEntry(
    id: 'srd_feature_sorcerous_origin',
    category: 'feature',
    name: 'Sorcerous Origin',
    summary:
        'Sorcerer 1st level: Magical power derived from draconic ancestry or wild chaos magic.',
    data: {
      'source': 'Sorcerer (Level 1)',
      'recharge': 'Passive',
      'description':
          'Choose a sorcerous origin which describes the source of your innate magical power, such as Draconic Bloodline or Wild Magic.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_healing_hands',
    category: 'feature',
    name: 'Healing Hands',
    summary:
        'Aasimar: As an action, touch a creature to restore hit points equal to your level (1/Long Rest).',
    data: {
      'source': 'Aasimar Racial Trait',
      'recharge': 'Long Rest',
      'usesMax': 1,
      'description':
          'As an action, you can touch a creature and cause it to regain a number of hit points equal to your level. Once you use this trait, you can\'t use it again until you finish a long rest.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_stones_endurance',
    category: 'feature',
    name: 'Stone\'s Endurance',
    summary:
        'Goliath: As a reaction when taking damage, roll 1d12 + CON modifier to reduce damage taken (1/Short Rest).',
    data: {
      'source': 'Goliath Racial Trait',
      'recharge': 'Short or Long Rest',
      'usesMax': 1,
      'description':
          'You can focus yourself to occasionally shrug off injury. When you take damage, you can use your reaction to roll a d12. Add your Constitution modifier to the number rolled, and reduce the damage by that total.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_adrenaline_rush',
    category: 'feature',
    name: 'Adrenaline Rush',
    summary:
        'Orc: Dash as a bonus action, gaining temporary hit points equal to your proficiency bonus.',
    data: {
      'source': 'Orc Racial Trait',
      'recharge': 'Short or Long Rest',
      'usesMax': 2,
      'description':
          'You can take the Dash action as a bonus action. When you do so, you gain a number of temporary hit points equal to your proficiency bonus.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_feline_agility',
    category: 'feature',
    name: 'Feline Agility',
    summary:
        'Tabaxi: Double your walking speed for one turn. Recharges when you spend a turn without moving.',
    data: {
      'source': 'Tabaxi Racial Trait',
      'recharge': 'Special',
      'description':
          'Your reflexes and agility allow you to move with a burst of speed. When you move on your turn in combat, you can double your speed until the end of the turn. Once you use this trait, you can\'t use it again until you move 0 feet on one of your turns.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_tortle_natural_armor',
    category: 'feature',
    name: 'Tortle Natural Armor',
    summary:
        'Tortle: Your shell provides you a base AC of 17. You gain no benefit from wearing armor.',
    data: {
      'source': 'Tortle Racial Trait',
      'recharge': 'Passive',
      'description':
          'Your shell provides you a base AC of 17 (your Dexterity modifier doesn\'t affect this number). You can\'t wear light, medium, or heavy armor, but if you are using a shield, you can apply the shield\'s bonus as normal.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_hidden_step',
    category: 'feature',
    name: 'Hidden Step',
    summary:
        'Firbolg: As a bonus action, turn magically invisible until the start of your next turn (1/Short Rest).',
    data: {
      'source': 'Firbolg Racial Trait',
      'recharge': 'Short or Long Rest',
      'usesMax': 1,
      'description':
          'As a bonus action, you can magically turn invisible until the start of your next turn or until you attack, make a damage roll, or force someone to make a saving throw.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_shapechanger',
    category: 'feature',
    name: 'Shapechanger',
    summary:
        'Changeling: As an action, change your appearance and voice to any humanoid you have seen.',
    data: {
      'source': 'Changeling Racial Trait',
      'recharge': 'At-Will',
      'description':
          'As an action, you can change your appearance and your voice. You determine the specifics of the changes, including your coloration, hair length, and sex. You can also adjust your height and weight, but not your basic humanoid shape.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_fury_of_the_small',
    category: 'feature',
    name: 'Fury of the Small',
    summary:
        'Goblin: When damaging a creature of larger size, deal extra damage equal to your level (1/Short Rest).',
    data: {
      'source': 'Goblin Racial Trait',
      'recharge': 'Short or Long Rest',
      'usesMax': 1,
      'description':
          'When you damage a creature with an attack or a spell and the creature\'s size is larger than yours, you can cause the attack or spell to deal extra damage to the creature. The extra damage equals your level.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_draconic_cry',
    category: 'feature',
    name: 'Draconic Cry',
    summary:
        'Kobold: As a bonus action, let out a cry to grant you and your allies advantage on attack rolls against nearby enemies.',
    data: {
      'source': 'Kobold Racial Trait',
      'recharge': 'Long Rest',
      'usesMax': 2,
      'description':
          'As a bonus action, you let out a cry at your enemies within 10 feet of you. Until the start of your next turn, you and your allies have advantage on attack rolls against any of those enemies who could hear you.',
    },
  ),
];

/// Seeds the bundled SRD 5.1 entries into the Drift compendium database if empty.
Future<void> seedSrdCompendium(AppDatabase db) async {
  final existing = await db.searchCompendium('dnd5e', query: '');
  if (existing.isNotEmpty) return;

  final companions = bundledSrdEntries.map((e) {
    return CompendiumTableCompanion.insert(
      id: e.id,
      systemId: e.systemId,
      category: e.category,
      name: e.name,
      summary: Value(e.summary),
      fullDataJson: Value(jsonEncode(e.data)),
    );
  }).toList();

  await db.insertCompendiumEntries(companions);
}

import 'dart:convert';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../models/compendium_entry.dart';
import 'spells/all_srd_spells.dart';

/// Bundled SRD 5.1 dataset for instant offline search and sheet importing.
final List<CompendiumEntry> bundledSrdEntries = [
  // --- All SRD 5.1 Spells (Cantrips through 9th Level) ---
  ...allSrdSpells,

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
  CompendiumEntry(
    id: 'srd_trait_child_of_the_sea',
    category: 'feature',
    name: 'Child of the Sea',
    summary:
        'Sea Elf: You have a swimming speed of 30 feet, and you can breathe both air and water.',
    data: {
      'source': 'Sea Elf Racial Trait',
      'recharge': 'Passive',
      'description':
          'You have a swimming speed of 30 feet, and you can breathe both air and water.',
    },
  ),
  CompendiumEntry(
    id: 'srd_trait_friend_of_the_sea',
    category: 'feature',
    name: 'Friend of the Sea',
    summary:
        'Sea Elf: Using gestures and sounds, you can communicate simple ideas to beasts that have a swimming speed.',
    data: {
      'source': 'Sea Elf Racial Trait',
      'recharge': 'Passive',
      'description':
          'Using gestures and sounds, you can communicate simple ideas with any beast that has an inborn swimming speed.',
    },
  ),
];

/// Seeds the bundled SRD 5.1 entries into the Drift compendium database if empty or incomplete.
Future<void> seedSrdCompendium(AppDatabase db) async {
  final count = await (db.select(
    db.compendiumTable,
  )..where((t) => t.systemId.equals('dnd5e'))).get().then((l) => l.length);
  if (count >= bundledSrdEntries.length) return;

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

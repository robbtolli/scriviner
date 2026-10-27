/// Core D&D 5.1 SRD starter definitions for Level 1 character creation.
library;

enum PlaystyleArchetype {
  warrior(
    'Frontline Warrior',
    'High health, heavy armor, weapons, and endurance.',
  ),
  skirmisher(
    'Stealth & Skill Expert',
    'Agility, precision strikes, traps, and utility.',
  ),
  divine(
    'Divine & Nature Guardian',
    'Healing, buffs, protection, and elemental magic.',
  ),
  arcane(
    'Arcane Spellcaster',
    'Devastating spells, crowd control, and mystical secrets.',
  );

  final String title;
  final String description;
  const PlaystyleArchetype(this.title, this.description);
}

class SubraceDefinition {
  final String id;
  final String name;
  final Map<String, int> abilityBonuses;
  final List<String> traits;
  final int? speed;
  final String description;

  const SubraceDefinition({
    required this.id,
    required this.name,
    this.abilityBonuses = const {},
    this.traits = const [],
    this.speed,
    required this.description,
  });
}

class RaceDefinition {
  final String id;
  final String name;
  final int speed;
  final Map<String, int> abilityBonuses;
  final List<String> traits;
  final String description;
  final List<SubraceDefinition> subraces;
  final bool isExpanded;

  const RaceDefinition({
    required this.id,
    required this.name,
    required this.speed,
    required this.abilityBonuses,
    required this.traits,
    required this.description,
    this.subraces = const [],
    this.isExpanded = false,
  });
}

class ClassDefinition {
  final String id;
  final String name;
  final PlaystyleArchetype archetype;
  final int hitDie;
  final String primaryAbility;
  final List<String> savingThrows;
  final int skillCount;
  final List<String> availableSkills;
  final List<String> startingFeatures;
  final int cantripsKnown;
  final int firstLevelSpellsKnown;
  final bool isSpellcaster;
  final String description;

  const ClassDefinition({
    required this.id,
    required this.name,
    required this.archetype,
    required this.hitDie,
    required this.primaryAbility,
    required this.savingThrows,
    required this.skillCount,
    required this.availableSkills,
    required this.startingFeatures,
    this.cantripsKnown = 0,
    this.firstLevelSpellsKnown = 0,
    this.isSpellcaster = false,
    required this.description,
  });
}

class BackgroundDefinition {
  final String id;
  final String name;
  final List<String> grantedSkills;
  final String featureName;
  final String featureDescription;

  const BackgroundDefinition({
    required this.id,
    required this.name,
    required this.grantedSkills,
    required this.featureName,
    required this.featureDescription,
  });
}

class SpellDefinition {
  final String id;
  final String name;
  final int level; // 0 = Cantrip
  final String school;
  final String castingTime;
  final String range;
  final String description;
  final List<String> classes;

  const SpellDefinition({
    required this.id,
    required this.name,
    required this.level,
    required this.school,
    required this.castingTime,
    required this.range,
    required this.description,
    required this.classes,
  });
}

class SrdStarterData {
  static const List<RaceDefinition> races = [
    RaceDefinition(
      id: 'dwarf',
      name: 'Dwarf',
      speed: 25,
      abilityBonuses: {'CON': 2},
      traits: ['Darkvision 60ft', 'Dwarven Resilience (Adv vs Poison)'],
      description:
          'Sturdy and resilient warriors who resist poison and thrive in tough battles.',
      subraces: [
        SubraceDefinition(
          id: 'hill_dwarf',
          name: 'Hill Dwarf',
          abilityBonuses: {'WIS': 1},
          traits: ['Dwarven Toughness (+1 Max HP per level)'],
          description:
              'Deeply intuitive, stalwart defenders with incredible resilience and vitality.',
        ),
        SubraceDefinition(
          id: 'mountain_dwarf',
          name: 'Mountain Dwarf',
          abilityBonuses: {'STR': 2},
          traits: ['Dwarven Armor Training (Light & Medium Armor)'],
          description:
              'Strong and rugged highlanders accustomed to harsh mountain terrain.',
        ),
      ],
    ),
    RaceDefinition(
      id: 'elf',
      name: 'Elf',
      speed: 30,
      abilityBonuses: {'DEX': 2},
      traits: ['Darkvision 60ft', 'Keen Senses', 'Fey Ancestry (Adv vs Charm)'],
      description:
          'Graceful, long-lived masters of archery, stealth, and ancient magic.',
      subraces: [
        SubraceDefinition(
          id: 'high_elf',
          name: 'High Elf',
          abilityBonuses: {'INT': 1},
          traits: [
            'Elf Weapon Training',
            'High Elf Cantrip (Wizard)',
            'Extra Language',
          ],
          description:
              'Haughty and contemplative, possessing a keen mind and mastery of basic magic.',
        ),
        SubraceDefinition(
          id: 'wood_elf',
          name: 'Wood Elf',
          abilityBonuses: {'WIS': 1},
          speed: 35,
          traits: [
            'Elf Weapon Training',
            'Fleet of Foot (35 ft speed)',
            'Mask of the Wild',
          ],
          description:
              'Fleet-footed hunters and scouts at one with the primeval wilderness.',
        ),
        SubraceDefinition(
          id: 'drow',
          name: 'Drow (Dark Elf)',
          abilityBonuses: {'CHA': 1},
          traits: [
            'Superior Darkvision 120ft',
            'Drow Magic (Dancing Lights)',
            'Drow Weapon Training',
            'Sunlight Sensitivity',
          ],
          description:
              'Descendants of an ancient subterranean divergence with heightened darkvision and innate fey magic.',
        ),
      ],
    ),
    RaceDefinition(
      id: 'halfling',
      name: 'Halfling',
      speed: 25,
      abilityBonuses: {'DEX': 2},
      traits: [
        'Lucky (Reroll 1s on d20)',
        'Brave (Adv vs Frightened)',
        'Nimble',
      ],
      description:
          'Small and nimble adventurers known for extraordinary luck and bravery.',
      subraces: [
        SubraceDefinition(
          id: 'lightfoot_halfling',
          name: 'Lightfoot Halfling',
          abilityBonuses: {'CHA': 1},
          traits: ['Naturally Stealthy (Hide behind larger creatures)'],
          description:
              'Graceful, stealthy wanderers able to easily slip away unnoticed.',
        ),
        SubraceDefinition(
          id: 'stout_halfling',
          name: 'Stout Halfling',
          abilityBonuses: {'CON': 1},
          traits: ['Stout Resilience (Poison resistance & save advantage)'],
          description:
              'Hardy folk with dwarven ancestry granting exceptional poison endurance.',
        ),
      ],
    ),
    RaceDefinition(
      id: 'human',
      name: 'Human',
      speed: 30,
      abilityBonuses: {
        'STR': 1,
        'DEX': 1,
        'CON': 1,
        'INT': 1,
        'WIS': 1,
        'CHA': 1,
      },
      traits: ['Versatile (+1 to all Ability Scores)'],
      description:
          'Adaptable and ambitious travelers excelling in every discipline.',
    ),
    RaceDefinition(
      id: 'dragonborn',
      name: 'Dragonborn',
      speed: 30,
      abilityBonuses: {'STR': 2, 'CHA': 1},
      traits: ['Draconic Ancestry', 'Breath Weapon', 'Damage Resistance'],
      description:
          'Proud draconic warriors capable of unleashing devastating elemental breath.',
    ),
    RaceDefinition(
      id: 'gnome',
      name: 'Gnome',
      speed: 25,
      abilityBonuses: {'INT': 2},
      traits: ['Darkvision 60ft', 'Gnome Cunning (Adv vs Magic Saves)'],
      description:
          'Curious, inventive tinkers and spellcasters with innate magical protection.',
      subraces: [
        SubraceDefinition(
          id: 'forest_gnome',
          name: 'Forest Gnome',
          abilityBonuses: {'DEX': 1},
          traits: [
            'Natural Illusionist (Minor Illusion)',
            'Speak with Small Beasts',
          ],
          description:
              'Stealthy, agile forest dwellers who weave natural illusions.',
        ),
        SubraceDefinition(
          id: 'rock_gnome',
          name: 'Rock Gnome',
          abilityBonuses: {'CON': 1},
          traits: ['Artificer\'s Lore', 'Tinker (Craft clockwork devices)'],
          description:
              'Inventive craftspeople renowned for creating clockwork gadgets.',
        ),
      ],
    ),
    RaceDefinition(
      id: 'half_elf',
      name: 'Half-Elf',
      speed: 30,
      abilityBonuses: {'CHA': 2, 'DEX': 1, 'CON': 1},
      traits: [
        'Darkvision 60ft',
        'Fey Ancestry',
        'Skill Versatility (2 free skills)',
      ],
      description:
          'Charismatic diplomats combining elven elegance with human ingenuity.',
    ),
    RaceDefinition(
      id: 'half_orc',
      name: 'Half-Orc',
      speed: 30,
      abilityBonuses: {'STR': 2, 'CON': 1},
      traits: [
        'Darkvision 60ft',
        'Relentless Endurance (Survive at 1 HP)',
        'Savage Attacks',
      ],
      description:
          'Fierce combatants driven by endurance, unmatched ferocity, and raw power.',
    ),
    RaceDefinition(
      id: 'tiefling',
      name: 'Tiefling',
      speed: 30,
      abilityBonuses: {'CHA': 2, 'INT': 1},
      traits: [
        'Darkvision 60ft',
        'Hellish Resistance (Fire)',
        'Infernal Legacy',
      ],
      description:
          'Infused with otherworldly heritage, wielding fire resistance and dark magic.',
    ),

    // --- Tier 1: Core 2024 Additions ---
    RaceDefinition(
      id: 'aasimar',
      name: 'Aasimar',
      speed: 30,
      abilityBonuses: {'CHA': 2},
      traits: [
        'Darkvision 60ft',
        'Celestial Resistance (Necrotic & Radiant)',
        'Healing Hands',
        'Light Bearer (Light cantrip)',
      ],
      description:
          'Mortals bearing the spark of the Upper Planes, blessed with celestial radiance and healing touch.',
      subraces: [
        SubraceDefinition(
          id: 'protector_aasimar',
          name: 'Protector Aasimar',
          abilityBonuses: {'WIS': 1},
          traits: ['Radiant Soul (Grows angelic wings & flight speed)'],
          description:
              'Protectors guided by celestial duty, soaring on luminous angelic wings.',
        ),
        SubraceDefinition(
          id: 'scourge_aasimar',
          name: 'Scourge Aasimar',
          abilityBonuses: {'CON': 1},
          traits: ['Radiant Consumption (Burns with searing holy fire)'],
          description:
              'Fierce zealots who unleash intense inner divine radiance to purge evil.',
        ),
        SubraceDefinition(
          id: 'fallen_aasimar',
          name: 'Fallen Aasimar',
          abilityBonuses: {'STR': 1},
          traits: ['Necrotic Shroud (Skeletal wings & frightful presence)'],
          description:
              'A celestial touched by dark power in youth or through a tragic fall from grace.',
        ),
      ],
    ),
    RaceDefinition(
      id: 'goliath',
      name: 'Goliath',
      speed: 30,
      abilityBonuses: {'STR': 2, 'CON': 1},
      traits: [
        'Stone\'s Endurance (Damage reduction reaction 1d12+CON)',
        'Mountain Born (Cold Resistance & altitude acclimation)',
        'Powerful Build (Count as size larger for carrying)',
      ],
      description:
          'Towering mountain nomads possessing the strength of stone and enduring punishing cold.',
    ),
    RaceDefinition(
      id: 'orc',
      name: 'Orc',
      speed: 30,
      abilityBonuses: {'STR': 2, 'CON': 1},
      traits: [
        'Darkvision 120ft',
        'Adrenaline Rush (Bonus action Dash + Temp HP)',
        'Relentless Endurance (Survive at 1 HP)',
        'Powerful Build',
      ],
      description:
          'Tenacious champions blessed with relentless stamina, explosive charges, and formidable endurance.',
    ),

    // --- Tier 2: Expanded Races ---
    RaceDefinition(
      id: 'tabaxi',
      name: 'Tabaxi',
      speed: 30,
      isExpanded: true,
      abilityBonuses: {'DEX': 2, 'CHA': 1},
      traits: [
        'Feline Agility (Double speed for 1 turn)',
        'Cat\'s Claws (Climbing speed 20ft & 1d4 unarmed slashing)',
        'Darkvision 60ft',
        'Cat\'s Talent (Proficiency in Perception & Stealth)',
      ],
      description:
          'Curious, nimble catfolk motivated by wanderlust, ancient secrets, and rare treasures.',
    ),
    RaceDefinition(
      id: 'genasi',
      name: 'Genasi',
      speed: 30,
      isExpanded: true,
      abilityBonuses: {'CON': 2},
      traits: ['Elemental Heritage', 'Planar Resistance'],
      description:
          'Mortals touched by the raw primal power of the four elemental planes.',
      subraces: [
        SubraceDefinition(
          id: 'air_genasi',
          name: 'Air Genasi',
          abilityBonuses: {'DEX': 1},
          speed: 35,
          traits: ['Unending Breath', 'Mingle with the Wind (Levitate)'],
          description:
              'Breezy, mercurial beings carrying the wind of elemental air.',
        ),
        SubraceDefinition(
          id: 'earth_genasi',
          name: 'Earth Genasi',
          abilityBonuses: {'STR': 1},
          traits: ['Earth Walk', 'Merge with Stone (Pass Without Trace)'],
          description:
              'Patient, solid beings with the stoic resilience of elemental earth.',
        ),
        SubraceDefinition(
          id: 'fire_genasi',
          name: 'Fire Genasi',
          abilityBonuses: {'INT': 1},
          traits: [
            'Darkvision 60ft',
            'Fire Resistance',
            'Reach to the Blaze (Produce Flame)',
          ],
          description:
              'Fiery, passionate wanderers crackling with elemental heat.',
        ),
        SubraceDefinition(
          id: 'water_genasi',
          name: 'Water Genasi',
          abilityBonuses: {'WIS': 1},
          traits: [
            'Acid Resistance',
            'Amphibious (Breathe water)',
            'Swim Speed 30ft',
            'Call to the Wave',
          ],
          description:
              'Fluid and adaptable nomads at home in oceanic depths and running streams.',
        ),
      ],
    ),
    RaceDefinition(
      id: 'tortle',
      name: 'Tortle',
      speed: 30,
      isExpanded: true,
      abilityBonuses: {'STR': 2, 'WIS': 1},
      traits: [
        'Natural Armor (Base AC 17, cannot wear armor)',
        'Shell Defense (+4 AC withdrawn in shell)',
        'Claws (1d4 slashing)',
        'Nature\'s Intuition (Survival proficiency)',
      ],
      description:
          'Gentle, nomadic turtlefolk carrying their homes on their backs and thriving in nature.',
    ),
    RaceDefinition(
      id: 'firbolg',
      name: 'Firbolg',
      speed: 30,
      isExpanded: true,
      abilityBonuses: {'WIS': 2, 'STR': 1},
      traits: [
        'Firbolg Magic (Detect Magic & Disguise Self)',
        'Hidden Step (Bonus action turn invisible until next turn)',
        'Powerful Build',
        'Speech of Beast and Leaf',
      ],
      description:
          'Gentle forest giants and guardians of harmony who live in peaceful seclusion.',
    ),
    RaceDefinition(
      id: 'changeling',
      name: 'Changeling',
      speed: 30,
      isExpanded: true,
      abilityBonuses: {'CHA': 2, 'DEX': 1},
      traits: [
        'Shapechanger (Action change physical appearance and voice)',
        'Changeling Instincts (Two social skill proficiencies)',
        'Fey Ancestry (Adv vs Charm)',
      ],
      description:
          'Subtle folk blessed with the innate fey gift to alter their physical form and voice at will.',
    ),
    RaceDefinition(
      id: 'goblin',
      name: 'Goblin',
      speed: 30,
      isExpanded: true,
      abilityBonuses: {'DEX': 2, 'CON': 1},
      traits: [
        'Fury of the Small (Add level to damage against larger target 1/Rest)',
        'Nimble Escape (Bonus action Disengage or Hide)',
        'Darkvision 60ft',
      ],
      description:
          'Small, resilient crafters and scouts known for quick reflexes and fierce tenacity.',
    ),
    RaceDefinition(
      id: 'kobold',
      name: 'Kobold',
      speed: 30,
      isExpanded: true,
      abilityBonuses: {'DEX': 2},
      traits: [
        'Draconic Cry (Bonus action grant allies advantage on attacks)',
        'Kobold Legacy (Draconic Sorcery / Craftiness)',
        'Darkvision 60ft',
      ],
      description:
          'Clever, reptilian crafters who revere dragons and thrive in tight-knit subterranean warrens.',
    ),
  ];

  static const List<ClassDefinition> classes = [
    ClassDefinition(
      id: 'fighter',
      name: 'Fighter',
      archetype: PlaystyleArchetype.warrior,
      hitDie: 10,
      primaryAbility: 'STR',
      savingThrows: ['STR', 'CON'],
      skillCount: 2,
      availableSkills: [
        'Acrobatics',
        'Animal Handling',
        'Athletics',
        'History',
        'Insight',
        'Intimidation',
        'Perception',
        'Survival',
      ],
      startingFeatures: [
        'Fighting Style',
        'Second Wind (Bonus Action heal 1d10+1)',
      ],
      description: 'Master of weapons, armor, and physical combat tactics.',
    ),
    ClassDefinition(
      id: 'wizard',
      name: 'Wizard',
      archetype: PlaystyleArchetype.arcane,
      hitDie: 6,
      primaryAbility: 'INT',
      savingThrows: ['INT', 'WIS'],
      skillCount: 2,
      availableSkills: [
        'Arcana',
        'History',
        'Insight',
        'Investigation',
        'Medicine',
        'Religion',
      ],
      startingFeatures: ['Spellcasting', 'Arcane Recovery'],
      cantripsKnown: 3,
      firstLevelSpellsKnown: 6,
      isSpellcaster: true,
      description:
          'Scholarly magic-user manipulating reality through rigorous study.',
    ),
    ClassDefinition(
      id: 'rogue',
      name: 'Rogue',
      archetype: PlaystyleArchetype.skirmisher,
      hitDie: 8,
      primaryAbility: 'DEX',
      savingThrows: ['DEX', 'INT'],
      skillCount: 4,
      availableSkills: [
        'Acrobatics',
        'Athletics',
        'Deception',
        'Insight',
        'Intimidation',
        'Investigation',
        'Perception',
        'Performance',
        'Persuasion',
        'Sleight of Hand',
        'Stealth',
      ],
      startingFeatures: [
        'Expertise (Double proficiency)',
        'Sneak Attack (Extra 1d6 damage)',
        'Thieves Cant',
      ],
      description:
          'Cunning scoundrel specializing in stealth, agility, and precision strikes.',
    ),
    ClassDefinition(
      id: 'cleric',
      name: 'Cleric',
      archetype: PlaystyleArchetype.divine,
      hitDie: 8,
      primaryAbility: 'WIS',
      savingThrows: ['WIS', 'CHA'],
      skillCount: 2,
      availableSkills: [
        'History',
        'Insight',
        'Medicine',
        'Persuasion',
        'Religion',
      ],
      startingFeatures: ['Spellcasting', 'Divine Domain (Life Domain)'],
      cantripsKnown: 3,
      firstLevelSpellsKnown: 4,
      isSpellcaster: true,
      description:
          'Priestly champion wielding divine magic in service of a higher power.',
    ),
    ClassDefinition(
      id: 'barbarian',
      name: 'Barbarian',
      archetype: PlaystyleArchetype.warrior,
      hitDie: 12,
      primaryAbility: 'STR',
      savingThrows: ['STR', 'CON'],
      skillCount: 2,
      availableSkills: [
        'Animal Handling',
        'Athletics',
        'Intimidation',
        'Nature',
        'Perception',
        'Survival',
      ],
      startingFeatures: [
        'Rage (Bonus damage & resistance)',
        'Unarmored Defense (10 + DEX + CON)',
      ],
      description:
          'Fierce warrior who channels primal fury into relentless resilience.',
    ),
    ClassDefinition(
      id: 'paladin',
      name: 'Paladin',
      archetype: PlaystyleArchetype.warrior,
      hitDie: 10,
      primaryAbility: 'STR',
      savingThrows: ['WIS', 'CHA'],
      skillCount: 2,
      availableSkills: [
        'Athletics',
        'Insight',
        'Intimidation',
        'Medicine',
        'Persuasion',
        'Religion',
      ],
      startingFeatures: ['Divine Sense', 'Lay on Hands (Healing pool 5 HP)'],
      description:
          'Holy knight bound by a sacred oath to battle evil and heal allies.',
    ),
    ClassDefinition(
      id: 'bard',
      name: 'Bard',
      archetype: PlaystyleArchetype.skirmisher,
      hitDie: 8,
      primaryAbility: 'CHA',
      savingThrows: ['DEX', 'CHA'],
      skillCount: 3,
      availableSkills: [
        'Acrobatics',
        'Animal Handling',
        'Arcana',
        'Athletics',
        'Deception',
        'History',
        'Insight',
        'Intimidation',
        'Investigation',
        'Medicine',
        'Nature',
        'Perception',
        'Performance',
        'Persuasion',
        'Religion',
        'Sleight of Hand',
        'Stealth',
        'Survival',
      ],
      startingFeatures: ['Spellcasting', 'Bardic Inspiration (1d6)'],
      cantripsKnown: 2,
      firstLevelSpellsKnown: 4,
      isSpellcaster: true,
      description:
          'Inspiring magician who weaves music, wit, and versatility into powerful support and arcane charms.',
    ),
    ClassDefinition(
      id: 'ranger',
      name: 'Ranger',
      archetype: PlaystyleArchetype.skirmisher,
      hitDie: 10,
      primaryAbility: 'DEX',
      savingThrows: ['STR', 'DEX'],
      skillCount: 3,
      availableSkills: [
        'Animal Handling',
        'Athletics',
        'Insight',
        'Investigation',
        'Nature',
        'Perception',
        'Stealth',
        'Survival',
      ],
      startingFeatures: ['Favored Enemy', 'Natural Explorer'],
      cantripsKnown: 0,
      firstLevelSpellsKnown: 0,
      isSpellcaster: false,
      description:
          'Deadly hunter and wilderness tracker mastering archery, two-weapon combat, and primal survival.',
    ),
    ClassDefinition(
      id: 'sorcerer',
      name: 'Sorcerer',
      archetype: PlaystyleArchetype.arcane,
      hitDie: 6,
      primaryAbility: 'CHA',
      savingThrows: ['CON', 'CHA'],
      skillCount: 2,
      availableSkills: [
        'Arcana',
        'Deception',
        'Insight',
        'Intimidation',
        'Persuasion',
        'Religion',
      ],
      startingFeatures: [
        'Spellcasting',
        'Sorcerous Origin (Draconic Bloodline)',
      ],
      cantripsKnown: 4,
      firstLevelSpellsKnown: 2,
      isSpellcaster: true,
      description:
          'Natural spellcaster channeling raw arcane power inherited from an extraordinary bloodline or magical anomaly.',
    ),
    ClassDefinition(
      id: 'druid',
      name: 'Druid',
      archetype: PlaystyleArchetype.divine,
      hitDie: 8,
      primaryAbility: 'WIS',
      savingThrows: ['INT', 'WIS'],
      skillCount: 2,
      availableSkills: [
        'Animal Handling',
        'Arcana',
        'Insight',
        'Medicine',
        'Nature',
        'Perception',
        'Religion',
        'Survival',
      ],
      startingFeatures: ['Spellcasting', 'Druidic'],
      cantripsKnown: 2,
      firstLevelSpellsKnown: 4,
      isSpellcaster: true,
      description:
          'Priest of the primal forces of nature, channeling elemental wrath and adopting beast shapes.',
    ),
  ];

  static const List<BackgroundDefinition> backgrounds = [
    BackgroundDefinition(
      id: 'acolyte',
      name: 'Acolyte',
      grantedSkills: ['Insight', 'Religion'],
      featureName: 'Shelter of the Faithful',
      featureDescription:
          'You and companions can receive free healing and care at temples of your faith.',
    ),
    BackgroundDefinition(
      id: 'criminal',
      name: 'Criminal',
      grantedSkills: ['Deception', 'Stealth'],
      featureName: 'Criminal Contact',
      featureDescription:
          'You have a trustworthy contact who connects you to underground networks.',
    ),
    BackgroundDefinition(
      id: 'folk_hero',
      name: 'Folk Hero',
      grantedSkills: ['Animal Handling', 'Survival'],
      featureName: 'Rustic Hospitality',
      featureDescription:
          'Common folk will shelter and protect you from authorities.',
    ),
    BackgroundDefinition(
      id: 'noble',
      name: 'Noble',
      grantedSkills: ['History', 'Persuasion'],
      featureName: 'Position of Privilege',
      featureDescription:
          'People welcome you into high society and treat you with deference.',
    ),
    BackgroundDefinition(
      id: 'sage',
      name: 'Sage',
      grantedSkills: ['Arcana', 'History'],
      featureName: 'Researcher',
      featureDescription:
          'When seeking information, you often know where and from whom to find it.',
    ),
    BackgroundDefinition(
      id: 'soldier',
      name: 'Soldier',
      grantedSkills: ['Athletics', 'Intimidation'],
      featureName: 'Military Rank',
      featureDescription:
          'Soldiers loyal to your former military organization recognize your authority.',
    ),
  ];

  static const List<SpellDefinition> spells = [
    // Cantrips (Level 0)
    SpellDefinition(
      id: 'fire_bolt',
      name: 'Fire Bolt',
      level: 0,
      school: 'Evocation',
      castingTime: '1 Action',
      range: '120 ft',
      description:
          'Hurls a mote of fire. Make a ranged spell attack: deals 1d10 fire damage.',
      classes: ['sorcerer', 'wizard'],
    ),
    SpellDefinition(
      id: 'mage_hand',
      name: 'Mage Hand',
      level: 0,
      school: 'Conjuration',
      castingTime: '1 Action',
      range: '30 ft',
      description:
          'Creates a spectral hand to manipulate objects up to 10 pounds.',
      classes: ['bard', 'sorcerer', 'wizard'],
    ),
    SpellDefinition(
      id: 'light',
      name: 'Light',
      level: 0,
      school: 'Evocation',
      castingTime: '1 Action',
      range: 'Touch',
      description:
          'Touches an object to emit bright light in a 20-foot radius for 1 hour.',
      classes: ['bard', 'cleric', 'sorcerer', 'wizard'],
    ),
    SpellDefinition(
      id: 'sacred_flame',
      name: 'Sacred Flame',
      level: 0,
      school: 'Evocation',
      castingTime: '1 Action',
      range: '60 ft',
      description:
          'Flame-like radiance descends on a target. DEX save or take 1d8 radiant damage.',
      classes: ['cleric'],
    ),
    SpellDefinition(
      id: 'guidance',
      name: 'Guidance',
      level: 0,
      school: 'Divination',
      castingTime: '1 Action',
      range: 'Touch',
      description:
          'Touches one willing creature. Target adds 1d4 to one ability check of choice.',
      classes: ['cleric', 'druid'],
    ),
    SpellDefinition(
      id: 'vicious_mockery',
      name: 'Vicious Mockery',
      level: 0,
      school: 'Enchantment',
      castingTime: '1 Action',
      range: '60 ft',
      description:
          'Unleashes a string of insults. Target makes a WIS save or takes 1d4 psychic damage and has disadvantage on its next attack.',
      classes: ['bard'],
    ),
    SpellDefinition(
      id: 'druidcraft',
      name: 'Druidcraft',
      level: 0,
      school: 'Transmutation',
      castingTime: '1 Action',
      range: '30 ft',
      description:
          'Whispers to the spirits of nature to create a minor natural sensory effect or predict the weather.',
      classes: ['druid'],
    ),
    SpellDefinition(
      id: 'ray_of_frost',
      name: 'Ray of Frost',
      level: 0,
      school: 'Evocation',
      castingTime: '1 Action',
      range: '60 ft',
      description:
          'A frigid beam of blue-white light strikes a creature. Make a ranged spell attack: deals 1d8 cold damage and reduces speed by 10 ft.',
      classes: ['sorcerer', 'wizard'],
    ),

    // Level 1 Spells
    SpellDefinition(
      id: 'magic_missile',
      name: 'Magic Missile',
      level: 1,
      school: 'Evocation',
      castingTime: '1 Action',
      range: '120 ft',
      description:
          'Creates three glowing darts of magical force. Each unerringly deals 1d4+1 force damage.',
      classes: ['sorcerer', 'wizard'],
    ),
    SpellDefinition(
      id: 'shield',
      name: 'Shield',
      level: 1,
      school: 'Abjuration',
      castingTime: '1 Reaction',
      range: 'Self',
      description:
          'Grants +5 to Armor Class until the start of your next turn and negates Magic Missile.',
      classes: ['sorcerer', 'wizard'],
    ),
    SpellDefinition(
      id: 'cure_wounds',
      name: 'Cure Wounds',
      level: 1,
      school: 'Evocation',
      castingTime: '1 Action',
      range: 'Touch',
      description:
          'A creature you touch regains hit points equal to 1d8 + your spellcasting modifier.',
      classes: ['bard', 'cleric', 'druid', 'ranger'],
    ),
    SpellDefinition(
      id: 'bless',
      name: 'Bless',
      level: 1,
      school: 'Enchantment',
      castingTime: '1 Action',
      range: '30 ft',
      description:
          'Blesses up to three creatures. Targets add 1d4 to attack rolls and saving throws.',
      classes: ['cleric'],
    ),
    SpellDefinition(
      id: 'healing_word',
      name: 'Healing Word',
      level: 1,
      school: 'Evocation',
      castingTime: '1 Bonus Action',
      range: '60 ft',
      description:
          'A creature of your choice regains 1d4 + your spellcasting ability modifier.',
      classes: ['bard', 'cleric', 'druid'],
    ),
    SpellDefinition(
      id: 'thunderwave',
      name: 'Thunderwave',
      level: 1,
      school: 'Evocation',
      castingTime: '1 Action',
      range: 'Self (15-ft cube)',
      description:
          'A wave of thunderous force sweeps out. Creatures make a CON save or take 2d8 thunder damage and are pushed 10 ft away.',
      classes: ['bard', 'druid', 'sorcerer', 'wizard'],
    ),
    SpellDefinition(
      id: 'entangle',
      name: 'Entangle',
      level: 1,
      school: 'Conjuration',
      castingTime: '1 Action',
      range: '90 ft',
      description:
          'Grasping weeds and vines sprout in a 20-ft square. Creatures make a STR save or become restrained.',
      classes: ['druid'],
    ),
    SpellDefinition(
      id: 'dissonant_whispers',
      name: 'Dissonant Whispers',
      level: 1,
      school: 'Enchantment',
      castingTime: '1 Action',
      range: '60 ft',
      description:
          'Whispers a discordant melody. Target makes a WIS save or takes 3d6 psychic damage and must immediately use its reaction to flee.',
      classes: ['bard'],
    ),
    SpellDefinition(
      id: 'hunters_mark',
      name: 'Hunter\'s Mark',
      level: 1,
      school: 'Divination',
      castingTime: '1 Bonus Action',
      range: '90 ft',
      description:
          'Choose a creature within range. You deal an extra 1d6 damage to the target whenever you hit it with a weapon attack, and gain advantage on tracking it.',
      classes: ['ranger'],
    ),
  ];
}

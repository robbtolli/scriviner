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

class RaceDefinition {
  final String id;
  final String name;
  final int speed;
  final Map<String, int> abilityBonuses;
  final List<String> traits;
  final String description;

  const RaceDefinition({
    required this.id,
    required this.name,
    required this.speed,
    required this.abilityBonuses,
    required this.traits,
    required this.description,
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
    ),
    RaceDefinition(
      id: 'elf',
      name: 'Elf',
      speed: 30,
      abilityBonuses: {'DEX': 2},
      traits: ['Darkvision 60ft', 'Keen Senses', 'Fey Ancestry (Adv vs Charm)'],
      description:
          'Graceful, long-lived masters of archery, stealth, and ancient magic.',
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
      classes: ['wizard'],
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
      classes: ['wizard'],
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
      classes: ['cleric', 'wizard'],
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
      classes: ['cleric'],
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
      classes: ['wizard'],
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
      classes: ['wizard'],
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
      classes: ['cleric'],
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
      classes: ['cleric'],
    ),
  ];
}

import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

/// Streams the list of recent characters ordered by lastPlayedAt descending.
final recentCharactersStreamProvider =
    StreamProvider<List<CharactersTableData>>((ref) {
      final db = ref.watch(databaseProvider);
      return db.watchRecentCharacters(limit: 20);
    });

/// Current search query string entered in the Home Hub.
class CharacterSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final characterSearchQueryProvider =
    NotifierProvider<CharacterSearchQueryNotifier, String>(
      CharacterSearchQueryNotifier.new,
    );

/// Filtered list of recent characters matching the current search query.
final filteredCharactersProvider =
    Provider<AsyncValue<List<CharactersTableData>>>((ref) {
      final recentsAsync = ref.watch(recentCharactersStreamProvider);
      final query = ref
          .watch(characterSearchQueryProvider)
          .trim()
          .toLowerCase();

      return recentsAsync.whenData((characters) {
        if (query.isEmpty) return characters;

        return characters.where((c) {
          final matchesName = c.name.toLowerCase().contains(query);
          final matchesSystem = c.systemId.toLowerCase().contains(query);
          return matchesName || matchesSystem;
        }).toList();
      });
    });

/// Seeds sample level 3 characters into the database for immediate testing, play, and documentation.
Future<void> seedSampleCharacters(AppDatabase db) async {
  final now = DateTime.now();

  final fighterProps = {
    'level': 3,
    'class': 'Fighter',
    'classId': 'fighter',
    'subclass': 'Champion',
    'race': 'Mountain Dwarf',
    'background': 'Soldier',
    'hp': {'current': 28, 'max': 31, 'temp': 5},
    'armorClass': 18,
    'speed': 25,
    'proficiencyBonus': 2,
    'abilities': {
      'str': {'score': 16, 'mod': 3},
      'dex': {'score': 12, 'mod': 1},
      'con': {'score': 16, 'mod': 3},
      'int': {'score': 10, 'mod': 0},
      'wis': {'score': 13, 'mod': 1},
      'cha': {'score': 8, 'mod': -1},
    },
    'savingThrows': ['str', 'con'],
    'skills': ['athletics', 'intimidation', 'survival', 'perception'],
    'skillProficiencies': {
      'athletics': 1,
      'intimidation': 1,
      'survival': 1,
      'perception': 1,
    },
    'hitDice': {'total': 3, 'spent': 1, 'die': '1d10'},
    'currency': {'cp': 15, 'sp': 24, 'ep': 0, 'gp': 120, 'pp': 2},
    'featuresList': [
      {
        'name': 'Second Wind',
        'source': 'Fighter Level 1',
        'description':
            'Regain 1d10 + fighter level hit points as a bonus action once per short rest.',
      },
      {
        'name': 'Action Surge',
        'source': 'Fighter Level 2',
        'description':
            'Take one additional action on your turn once per short rest.',
      },
      {
        'name': 'Improved Critical',
        'source': 'Champion Level 3',
        'description':
            'Your weapon attacks score a critical hit on a roll of 19 or 20.',
      },
    ],
    'deathSaves': {'successes': 0, 'failures': 0},
  };

  final wizardProps = {
    'level': 3,
    'class': 'Wizard',
    'classId': 'wizard',
    'subclass': 'School of Evocation',
    'race': 'High Elf',
    'background': 'Sage',
    'hp': {'current': 20, 'max': 20, 'temp': 0},
    'armorClass': 15,
    'speed': 30,
    'proficiencyBonus': 2,
    'abilities': {
      'str': {'score': 8, 'mod': -1},
      'dex': {'score': 14, 'mod': 2},
      'con': {'score': 14, 'mod': 2},
      'int': {'score': 17, 'mod': 3},
      'wis': {'score': 12, 'mod': 1},
      'cha': {'score': 10, 'mod': 0},
    },
    'savingThrows': ['int', 'wis'],
    'skills': ['arcana', 'history', 'investigation', 'insight'],
    'skillProficiencies': {
      'arcana': 1,
      'history': 1,
      'investigation': 1,
      'insight': 1,
    },
    'hitDice': {'total': 3, 'spent': 0, 'die': '1d6'},
    'spellSlots': {
      '1': {'total': 4, 'spent': 1},
      '2': {'total': 2, 'spent': 0},
    },
    'spells': [
      {
        'name': 'Fire Bolt',
        'level': 0,
        'school': 'Evocation',
        'castingTime': '1 action',
        'range': '120 feet',
        'damage': '1d10 Fire',
        'description': 'Hurls a mote of fire dealing 1d10 fire damage.',
      },
      {
        'name': 'Magic Missile',
        'level': 1,
        'school': 'Evocation',
        'castingTime': '1 action',
        'range': '120 feet',
        'damage': '3d4 + 3 Force',
        'description':
            'Launches 3 glowing darts of magical force that unfailingly strike targets.',
      },
      {
        'name': 'Misty Step',
        'level': 2,
        'school': 'Conjuration',
        'castingTime': '1 bonus action',
        'range': 'Self',
        'description':
            'Briefly surrounded by silvery mist, you teleport up to 30 feet to an unoccupied space you can see.',
      },
      {
        'name': 'Scorching Ray',
        'level': 2,
        'school': 'Evocation',
        'castingTime': '1 action',
        'range': '120 feet',
        'damage': '2d6 Fire per ray',
        'description':
            'Creates three rays of fire and hurls them at targets within range.',
      },
    ],
    'featuresList': [
      {
        'name': 'Arcane Recovery',
        'source': 'Wizard Level 1',
        'description':
            'Once per day during a short rest, recover expended spell slots up to half your wizard level.',
      },
      {
        'name': 'Sculpt Spells',
        'source': 'Evocation Level 2',
        'description':
            'Create pockets of relative safety within the effects of your evocation spells.',
      },
    ],
    'currency': {'cp': 0, 'sp': 18, 'ep': 0, 'gp': 85, 'pp': 5},
    'deathSaves': {'successes': 0, 'failures': 0},
  };

  final rogueProps = {
    'level': 3,
    'class': 'Rogue',
    'classId': 'rogue',
    'subclass': 'Thief',
    'race': 'Lightfoot Halfling',
    'background': 'Criminal',
    'hp': {'current': 21, 'max': 21, 'temp': 0},
    'armorClass': 15,
    'speed': 25,
    'proficiencyBonus': 2,
    'abilities': {
      'str': {'score': 8, 'mod': -1},
      'dex': {'score': 16, 'mod': 3},
      'con': {'score': 14, 'mod': 2},
      'int': {'score': 12, 'mod': 1},
      'wis': {'score': 12, 'mod': 1},
      'cha': {'score': 14, 'mod': 2},
    },
    'savingThrows': ['dex', 'int'],
    'skills': ['stealth', 'sleightOfHand', 'acrobatics', 'deception'],
    'skillProficiencies': {
      'stealth': 2,
      'sleightOfHand': 2,
      'acrobatics': 1,
      'deception': 1,
    },
    'hitDice': {'total': 3, 'spent': 0, 'die': '1d8'},
    'currency': {'cp': 30, 'sp': 45, 'ep': 0, 'gp': 195, 'pp': 0},
    'featuresList': [
      {
        'name': 'Sneak Attack',
        'source': 'Rogue Level 1',
        'description':
            'Deal an extra 2d6 damage to one creature you hit with an attack if you have advantage on the roll.',
      },
      {
        'name': 'Cunning Action',
        'source': 'Rogue Level 2',
        'description':
            'Take a bonus action on each of your turns to Dash, Disengage, or Hide.',
      },
    ],
    'deathSaves': {'successes': 0, 'failures': 0},
  };

  // Upsert characters
  await db.upsertCharacter(
    CharactersTableCompanion.insert(
      id: 'sample-thorin',
      name: 'Thorin Ironforge',
      systemId: const Value('dnd5e'),
      createdAt: now.subtract(const Duration(hours: 3)),
      lastPlayedAt: now.subtract(const Duration(minutes: 15)),
      rawPropertiesJson: jsonEncode(fighterProps),
      notes: const Value(
        'Stalwart dwarven warrior armed with shield and mastercrafted warhammer.',
      ),
    ),
  );

  await db.upsertCharacter(
    CharactersTableCompanion.insert(
      id: 'sample-lyra',
      name: 'Lyra Moonsong',
      systemId: const Value('dnd5e'),
      createdAt: now.subtract(const Duration(days: 1)),
      lastPlayedAt: now.subtract(const Duration(hours: 2)),
      rawPropertiesJson: jsonEncode(wizardProps),
      notes: const Value(
        'Elven scholar of evocation and ancient arcane runes.',
      ),
    ),
  );

  await db.upsertCharacter(
    CharactersTableCompanion.insert(
      id: 'sample-shadow',
      name: 'Shadow Shadowstep',
      systemId: const Value('dnd5e'),
      createdAt: now.subtract(const Duration(days: 2)),
      lastPlayedAt: now.subtract(const Duration(hours: 6)),
      rawPropertiesJson: jsonEncode(rogueProps),
      notes: const Value(
        'Quick-witted halfling scout with an eye for ancient treasure.',
      ),
    ),
  );

  // Seed sample inventory items
  await db.upsertInventoryItem(
    InventoryTableCompanion.insert(
      id: 'item-warhammer',
      characterId: 'sample-thorin',
      name: 'Dwarven Warhammer',
      quantity: const Value(1),
      weight: const Value(2.0),
      isEquipped: const Value(true),
      containerName: const Value('Main Hand'),
      itemDataJson: const Value(
        '{"damage": "1d8+3 Bludgeoning", "type": "Martial Weapon"}',
      ),
    ),
  );

  await db.upsertInventoryItem(
    InventoryTableCompanion.insert(
      id: 'item-shield',
      characterId: 'sample-thorin',
      name: 'Steel Heater Shield',
      quantity: const Value(1),
      weight: const Value(6.0),
      isEquipped: const Value(true),
      containerName: const Value('Off Hand'),
      itemDataJson: const Value('{"acBonus": 2, "type": "Shield"}'),
    ),
  );

  await db.upsertInventoryItem(
    InventoryTableCompanion.insert(
      id: 'item-plate',
      characterId: 'sample-thorin',
      name: 'Plate Armor',
      quantity: const Value(1),
      weight: const Value(65.0),
      isEquipped: const Value(true),
      containerName: const Value('Body'),
      itemDataJson: const Value('{"ac": 18, "type": "Heavy Armor"}'),
    ),
  );

  // Seed conditions
  await db.addCondition(
    ConditionsTableCompanion.insert(
      id: 'cond-blessed',
      characterId: 'sample-thorin',
      conditionId: 'blessed',
      durationRounds: const Value(10),
      customNotes: const Value(
        'Blessed by dwarven ancestors (+1d4 to attack rolls and saves)',
      ),
    ),
  );
}

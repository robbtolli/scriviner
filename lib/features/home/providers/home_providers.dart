import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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
  final query = ref.watch(characterSearchQueryProvider).trim().toLowerCase();

  return recentsAsync.whenData((characters) {
    if (query.isEmpty) return characters;

    return characters.where((c) {
      final matchesName = c.name.toLowerCase().contains(query);
      final matchesSystem = c.systemId.toLowerCase().contains(query);
      return matchesName || matchesSystem;
    }).toList();
  });
});

/// Seeds sample level 1 characters into the database for immediate testing and play.
Future<void> seedSampleCharacters(AppDatabase db) async {
  final now = DateTime.now();

  final fighterProps = {
    'level': 1,
    'class': 'Fighter',
    'classId': 'fighter',
    'race': 'Dwarf',
    'hp': {'current': 13, 'max': 13, 'temp': 0},
    'armorClass': 18,
    'speed': 25,
    'abilities': {
      'str': {'score': 15, 'mod': 2},
      'dex': {'score': 13, 'mod': 1},
      'con': {'score': 16, 'mod': 3},
      'int': {'score': 8, 'mod': -1},
      'wis': {'score': 12, 'mod': 1},
      'cha': {'score': 10, 'mod': 0},
    },
  };

  final wizardProps = {
    'level': 1,
    'class': 'Wizard',
    'classId': 'wizard',
    'race': 'Elf',
    'hp': {'current': 8, 'max': 8, 'temp': 0},
    'armorClass': 15,
    'speed': 30,
    'abilities': {
      'str': {'score': 8, 'mod': -1},
      'dex': {'score': 15, 'mod': 2},
      'con': {'score': 14, 'mod': 2},
      'int': {'score': 16, 'mod': 3},
      'wis': {'score': 12, 'mod': 1},
      'cha': {'score': 10, 'mod': 0},
    },
  };

  final rogueProps = {
    'level': 1,
    'class': 'Rogue',
    'classId': 'rogue',
    'race': 'Halfling',
    'hp': {'current': 10, 'max': 10, 'temp': 0},
    'armorClass': 14,
    'speed': 25,
    'abilities': {
      'str': {'score': 8, 'mod': -1},
      'dex': {'score': 17, 'mod': 3},
      'con': {'score': 14, 'mod': 2},
      'int': {'score': 13, 'mod': 1},
      'wis': {'score': 12, 'mod': 1},
      'cha': {'score': 10, 'mod': 0},
    },
  };

  await db.upsertCharacter(CharactersTableCompanion.insert(
    id: const Uuid().v4(),
    name: 'Thorin Ironforge',
    systemId: const Value('dnd5e'),
    createdAt: now.subtract(const Duration(hours: 3)),
    lastPlayedAt: now.subtract(const Duration(minutes: 15)), // Most recent!
    rawPropertiesJson: jsonEncode(fighterProps),
    notes: const Value('Stalwart dwarven warrior armed with shield and battleaxe.'),
  ));

  await db.upsertCharacter(CharactersTableCompanion.insert(
    id: const Uuid().v4(),
    name: 'Lyra Moonsong',
    systemId: const Value('dnd5e'),
    createdAt: now.subtract(const Duration(days: 1)),
    lastPlayedAt: now.subtract(const Duration(hours: 2)),
    rawPropertiesJson: jsonEncode(wizardProps),
    notes: const Value('Elven scholar of evocation and ancient runes.'),
  ));

  await db.upsertCharacter(CharactersTableCompanion.insert(
    id: const Uuid().v4(),
    name: 'Shadow Shadowstep',
    systemId: const Value('dnd5e'),
    createdAt: now.subtract(const Duration(days: 2)),
    lastPlayedAt: now.subtract(const Duration(hours: 6)),
    rawPropertiesJson: jsonEncode(rogueProps),
    notes: const Value('Quick-witted halfling scout with an eye for treasure.'),
  ));
}

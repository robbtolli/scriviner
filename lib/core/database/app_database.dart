import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/characters_table.dart';
import 'tables/compendium_table.dart';
import 'tables/conditions_table.dart';
import 'tables/inventory_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [CharactersTable, ConditionsTable, InventoryTable, CompendiumTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
    : super(
        e ??
            driftDatabase(
              name: 'scrivener_db',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // Enable foreign keys in SQLite
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // --- Character Queries ---

  /// Watches recent characters ordered by last played descending.
  Stream<List<CharactersTableData>> watchRecentCharacters({int limit = 10}) {
    final query = select(charactersTable)
      ..orderBy([
        (t) =>
            OrderingTerm(expression: t.lastPlayedAt, mode: OrderingMode.desc),
      ])
      ..limit(limit);
    return query.watch();
  }

  /// Fetches recent characters once.
  Future<List<CharactersTableData>> getRecentCharacters({int limit = 10}) {
    final query = select(charactersTable)
      ..orderBy([
        (t) =>
            OrderingTerm(expression: t.lastPlayedAt, mode: OrderingMode.desc),
      ])
      ..limit(limit);
    return query.get();
  }

  /// Watches a single character by ID.
  Stream<CharactersTableData?> watchCharacter(String id) {
    return (select(
      charactersTable,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Retrieves a single character by ID.
  Future<CharactersTableData?> getCharacter(String id) {
    return (select(
      charactersTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Inserts or updates a character.
  Future<void> upsertCharacter(CharactersTableCompanion character) {
    return into(charactersTable).insertOnConflictUpdate(character);
  }

  /// Updates last played timestamp to now.
  Future<void> touchCharacterLastPlayed(String id) {
    return (update(charactersTable)..where((t) => t.id.equals(id))).write(
      CharactersTableCompanion(lastPlayedAt: Value(DateTime.now())),
    );
  }

  /// Deletes a character (cascades to conditions & inventory).
  Future<int> deleteCharacter(String id) {
    return (delete(charactersTable)..where((t) => t.id.equals(id))).go();
  }

  // --- Active Conditions Queries ---

  Stream<List<ConditionsTableData>> watchConditionsForCharacter(
    String characterId,
  ) {
    return (select(
      conditionsTable,
    )..where((t) => t.characterId.equals(characterId))).watch();
  }

  Future<List<ConditionsTableData>> getConditionsForCharacter(
    String characterId,
  ) {
    return (select(
      conditionsTable,
    )..where((t) => t.characterId.equals(characterId))).get();
  }

  Future<void> addCondition(ConditionsTableCompanion condition) {
    return into(conditionsTable).insert(condition);
  }

  Future<int> removeCondition(String id) {
    return (delete(conditionsTable)..where((t) => t.id.equals(id))).go();
  }

  // --- Inventory Queries ---

  Stream<List<InventoryTableData>> watchInventoryForCharacter(
    String characterId,
  ) {
    return (select(
      inventoryTable,
    )..where((t) => t.characterId.equals(characterId))).watch();
  }

  Future<List<InventoryTableData>> getInventoryForCharacter(
    String characterId,
  ) {
    return (select(
      inventoryTable,
    )..where((t) => t.characterId.equals(characterId))).get();
  }

  Future<void> upsertInventoryItem(InventoryTableCompanion item) {
    return into(inventoryTable).insertOnConflictUpdate(item);
  }

  Future<int> removeInventoryItem(String id) {
    return (delete(inventoryTable)..where((t) => t.id.equals(id))).go();
  }

  // --- Compendium Queries ---

  Future<List<CompendiumTableData>> searchCompendium(
    String systemId, {
    String? category,
    String? query,
  }) {
    final q = select(compendiumTable)
      ..where((t) => t.systemId.equals(systemId));

    if (category != null && category.isNotEmpty) {
      q.where((t) => t.category.equals(category));
    }

    if (query != null && query.trim().isNotEmpty) {
      q.where((t) => t.name.like('%$query%'));
    }

    return q.get();
  }

  Future<void> insertCompendiumEntries(
    List<CompendiumTableCompanion> entries,
  ) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(compendiumTable, entries);
    });
  }

  /// Removes compendium entries matching a given ID prefix (e.g. for plugin uninstall).
  Future<int> deleteCompendiumEntriesByPrefix(String idPrefix) {
    return (delete(
      compendiumTable,
    )..where((t) => t.id.like('$idPrefix%'))).go();
  }
}

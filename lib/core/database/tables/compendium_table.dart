import 'package:drift/drift.dart';

/// Table representing SRD and homebrew compendium entries (spells, items, feats, etc.).
class CompendiumTable extends Table {
  TextColumn get id => text()();
  TextColumn get systemId => text()();
  TextColumn get category => text()(); // 'spell', 'item', 'feat', 'monster', etc.
  TextColumn get name => text()();
  TextColumn get summary => text().withDefault(const Constant(''))();
  TextColumn get fullDataJson => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};

  List<Index> get indexes => [
        Index('idx_compendium_lookup', 'CREATE INDEX IF NOT EXISTS idx_compendium_lookup ON compendium_table (system_id, category, name)'),
      ];
}

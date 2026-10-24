import 'package:drift/drift.dart';

/// Table representing saved characters.
class CharactersTable extends Table {
  TextColumn get id => text()();
  TextColumn get systemId => text().withDefault(const Constant('dnd5e'))();
  TextColumn get name => text()();
  TextColumn get portraitUri => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastPlayedAt => dateTime()();
  TextColumn get rawPropertiesJson => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};

  List<Index> get indexes => [
        Index('idx_characters_last_played', 'CREATE INDEX IF NOT EXISTS idx_characters_last_played ON characters_table (last_played_at DESC)'),
      ];
}

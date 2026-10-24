import 'package:drift/drift.dart';
import 'characters_table.dart';

/// Table representing active conditions/buffs applied to a character.
class ConditionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get characterId => text().references(CharactersTable, #id,
      onDelete: KeyAction.cascade)();
  TextColumn get conditionId => text()();
  IntColumn get durationRounds => integer().nullable()();
  TextColumn get customNotes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

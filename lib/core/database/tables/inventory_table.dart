import 'package:drift/drift.dart';
import 'characters_table.dart';

/// Table representing items stored in a character's inventory.
class InventoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get characterId =>
      text().references(CharactersTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get weight => real().withDefault(const Constant(0.0))();
  BoolColumn get isEquipped => boolean().withDefault(const Constant(false))();
  BoolColumn get isAttuned => boolean().withDefault(const Constant(false))();
  TextColumn get containerName =>
      text().withDefault(const Constant('Backpack'))();
  TextColumn get itemDataJson => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

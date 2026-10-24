import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/compendium/data/srd_compendium_seed.dart';
import 'package:scrivener/features/compendium/models/compendium_entry.dart';
import 'package:scrivener/features/compendium/presentation/compendium_search_dialog.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('seedSrdCompendium seeds standard SRD entries into database', () async {
    await seedSrdCompendium(db);

    final spells = await db.searchCompendium('dnd5e', category: 'spell');
    expect(spells.length, greaterThanOrEqualTo(10));
    expect(spells.any((s) => s.name == 'Fireball'), isTrue);
    expect(spells.any((s) => s.name == 'Cure Wounds'), isTrue);

    final equipment = await db.searchCompendium('dnd5e', category: 'equipment');
    expect(equipment.length, greaterThanOrEqualTo(8));
    expect(equipment.any((e) => e.name == 'Chain Mail'), isTrue);
    expect(equipment.any((e) => e.name == 'Shield'), isTrue);

    final features = await db.searchCompendium('dnd5e', category: 'feature');
    expect(features.any((f) => f.name == 'Action Surge'), isTrue);
  });

  testWidgets('CompendiumSearchDialog allows search and category filtering', (tester) async {
    CompendiumEntry? addedEntry;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: CompendiumSearchDialog(
              onAddEntry: (entry) => addedEntry = entry,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Search input
    expect(find.text('SRD 5.1 COMPENDIUM'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Filter by Spells
    await tester.tap(find.text('Spells'));
    await tester.pumpAndSettle();

    // Type "Cure" into search bar
    await tester.enterText(find.byType(TextField), 'Cure');
    await tester.pumpAndSettle();

    // Cure Wounds should be in the list
    expect(find.text('Cure Wounds'), findsOneWidget);
    expect(find.text('ADD'), findsOneWidget);

    // Tap ADD button
    await tester.tap(find.text('ADD'));
    await tester.pumpAndSettle();

    expect(addedEntry, isNotNull);
    expect(addedEntry!.name, equals('Cure Wounds'));
    expect(addedEntry!.spellLevel, equals(1));
  });
}

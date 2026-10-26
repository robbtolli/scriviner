import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/character_sheet_screen.dart';
import 'package:scrivener/features/home/presentation/home_screen.dart';
import 'package:scrivener/features/home/presentation/widgets/new_character_modal.dart';

void main() {
  group('Freeform Character Creation Mode Tests', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets(
      'Selecting Freeform mode immediately creates blank character and opens sheet',
      (tester) async {
        tester.view.physicalSize = const Size(1000, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );
        await tester.pumpAndSettle();

        // Tap FAB to open NewCharacterModal
        expect(find.byType(FloatingActionButton), findsOneWidget);
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(find.byType(NewCharacterModal), findsOneWidget);

        // Tap Freeform / Smart Paper Sheet option
        expect(find.text('Freeform / Smart Paper Sheet'), findsOneWidget);
        await tester.tap(find.text('Freeform / Smart Paper Sheet'));
        await tester.pumpAndSettle();

        // Tap START CREATING
        await tester.tap(find.text('START CREATING'));
        await tester.pumpAndSettle();

        // Verify that character sheet is opened with 'New Adventurer'
        expect(find.byType(CharacterSheetScreen), findsOneWidget);
        expect(find.text('New Adventurer'), findsWidgets);

        // Verify character was saved into Drift SQLite
        final allChars = await db.getRecentCharacters();
        expect(allChars.length, equals(1));
        expect(allChars.first.name, equals('New Adventurer'));

        // Cleanly unmount and drain StreamQueryStore timers
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 50));
      },
    );
  });
}

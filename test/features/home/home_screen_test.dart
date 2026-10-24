import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/home/presentation/home_screen.dart';
import 'package:scrivener/features/home/presentation/widgets/empty_home_state.dart';
import 'package:scrivener/features/home/presentation/widgets/resume_hero_card.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildTestApp() {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  testWidgets('renders EmptyHomeState when no characters exist', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(EmptyHomeState), findsOneWidget);
    expect(find.text('Your Chronicle Begins Here'), findsOneWidget);
    expect(find.text('CREATE NEW CHARACTER'), findsOneWidget);
    expect(find.text('LOAD SAMPLE HEROES'), findsOneWidget);

    // Cleanly unmount and drain StreamQueryStore timers
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('renders ResumeHeroCard when characters exist', (tester) async {
    final now = DateTime.now();
    await db.upsertCharacter(CharactersTableCompanion.insert(
      id: 'char-thorin',
      name: 'Thorin Ironforge',
      systemId: const Value('dnd5e'),
      createdAt: now,
      lastPlayedAt: now,
      rawPropertiesJson: '{"level": 1, "class": "Fighter", "race": "Dwarf", "hp": {"current": 13, "max": 13}, "armorClass": 18}',
    ));

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(EmptyHomeState), findsNothing);
    expect(find.byType(ResumeHeroCard), findsOneWidget);
    expect(find.text('Thorin Ironforge'), findsOneWidget);
    expect(find.text('RESUME SESSION'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('loading sample heroes populates characters into view', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(EmptyHomeState), findsOneWidget);

    // Tap Load Sample Heroes
    await tester.tap(find.text('LOAD SAMPLE HEROES'));
    await tester.pumpAndSettle();

    expect(find.byType(EmptyHomeState), findsNothing);
    expect(find.byType(ResumeHeroCard), findsOneWidget);
    expect(find.text('Thorin Ironforge'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

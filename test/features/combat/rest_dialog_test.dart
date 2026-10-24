import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/combat/presentation/combat_dashboard_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedTestCharacter() async {
    final now = DateTime.now();
    final props = {
      'class': 'Fighter',
      'race': 'Mountain Dwarf',
      'level': 1,
      'hp': {
        'current': 4,
        'max': 12,
        'temp': 0,
      },
      'armorClass': 16,
      'speed': 25,
      'hitDice': {
        'total': 2,
        'spent': 0,
        'die': '1d10',
      },
      'spellSlots': {
        '1': {'total': 2, 'spent': 2},
      },
      'features': {
        'secondWind': false,
      },
    };

    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: 'char_thorin_rest',
        name: 'Thorin Rest Test',
        systemId: const Value('dnd5e'),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: jsonEncode(props),
      ),
    );
  }

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const MaterialApp(
        home: CombatDashboardScreen(characterId: 'char_thorin_rest'),
      ),
    );
  }

  testWidgets('short rest rolls hit dice and restores health', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedTestCharacter();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify initial HP is 4
    expect(find.text('4'), findsOneWidget);

    // Tap REST in AppBar
    await tester.tap(find.text('REST'));
    await tester.pumpAndSettle();

    // Verify Short Rest dialog is open
    expect(find.text('Short Rest (1 hr)'), findsOneWidget);
    expect(find.text('Available Hit Dice: 2 / 2'), findsOneWidget);

    // Tap ROLL HIT DIE (1d10)
    await tester.tap(find.text('ROLL HIT DIE (1d10)'));
    await tester.pumpAndSettle();

    // Hit dice available is now 1 / 2
    expect(find.text('Available Hit Dice: 1 / 2'), findsOneWidget);

    // Tap FINISH REST
    await tester.tap(find.text('FINISH REST'));
    await tester.pumpAndSettle();

    // Verify HP has increased from 4
    expect(find.text('4'), findsNothing);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('long rest fully recovers HP and resets spell slots', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedTestCharacter();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Initial spell slots: 0 / 2 (all 2 spent)
    expect(find.text('0 / 2'), findsOneWidget);

    // Tap REST in AppBar
    await tester.tap(find.text('REST'));
    await tester.pumpAndSettle();

    // Switch to Long Rest tab
    await tester.tap(find.text('Long Rest (8 hrs)'));
    await tester.pumpAndSettle();

    expect(find.text('Take an 8-Hour Long Rest'), findsOneWidget);

    // Tap CONFIRM REST
    await tester.tap(find.text('CONFIRM REST'));
    await tester.pumpAndSettle();

    // HP should be full: 12 / 12
    expect(find.text('12'), findsOneWidget);

    // Spell slots restored to 2 / 2
    expect(find.text('2 / 2'), findsOneWidget);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

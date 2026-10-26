import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/combat/presentation/combat_dashboard_screen.dart';
import 'package:scrivener/features/combat/presentation/widgets/hp_tracker_card.dart';

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
      'hp': {'current': 12, 'max': 12, 'temp': 0},
      'armorClass': 16,
      'speed': 25,
      'hitDice': {'total': 2, 'spent': 0, 'die': '1d10'},
      'abilities': {
        'str': {'score': 16, 'mod': 3},
        'dex': {'score': 12, 'mod': 1},
        'con': {'score': 16, 'mod': 3},
      },
      'spellSlots': {
        '1': {'total': 2, 'spent': 0},
      },
      'activeConditions': ['poisoned'],
      'features': {'secondWind': true},
    };

    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: 'char_thorin',
        name: 'Thorin Ironforge',
        systemId: const Value('dnd5e'),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: jsonEncode(props),
      ),
    );
  }

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(
        home: CombatDashboardScreen(characterId: 'char_thorin'),
      ),
    );
  }

  testWidgets(
    'renders combat dashboard with vital stats and active condition',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await seedTestCharacter();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify Name, Class, and Race
      expect(find.text('Thorin Ironforge'), findsOneWidget);
      expect(
        find.textContaining('Level 1 Fighter (Mountain Dwarf)'),
        findsOneWidget,
      );

      // Verify HP display
      expect(find.text('12'), findsOneWidget);
      expect(find.text(' / 12'), findsOneWidget);

      // Verify Vitals (AC 16, Speed 25, Hit Dice 2/2)
      expect(find.text('16'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);

      // Verify active condition chip 'Poisoned'
      expect(find.text('Poisoned'), findsOneWidget);

      // Verify Spell Slots section
      expect(find.text('Level 1'), findsOneWidget);
      expect(find.text('2 / 2'), findsOneWidget);

      // Clean teardown
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    },
  );

  testWidgets(
    'quick damage and custom damage reduce HP and trigger death saves at 0 HP',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await seedTestCharacter();
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap -5 quick damage pill
      final minusFiveButton = find.descendant(
        of: find.byType(HpTrackerCard),
        matching: find.text('-5'),
      );
      await tester.tap(minusFiveButton);
      await tester.pumpAndSettle();

      // HP should now be 7
      expect(find.text('7'), findsOneWidget);

      // Tap CUSTOM DAMAGE / HEAL
      await tester.tap(find.text('CUSTOM DAMAGE / HEAL'));
      await tester.pumpAndSettle();

      // Enter 10 in the damage field
      await tester.enterText(find.byType(TextField), '10');
      await tester.tap(find.text('DAMAGE'));
      await tester.pumpAndSettle();

      // Current HP drops to 0 (capped at 0)
      expect(find.text('0'), findsOneWidget);

      // Death Saves panel should now appear!
      expect(find.text('DEATH SAVING THROWS'), findsOneWidget);
      expect(find.text('ROLL DEATH SAVE (1d20)'), findsOneWidget);

      // Tap ROLL DEATH SAVE
      await tester.tap(find.text('ROLL DEATH SAVE (1d20)'));
      await tester.pumpAndSettle();

      // A success or failure pip should now be active, or Nat 20 restored 1 HP
      if (find.text('Reset').evaluate().isNotEmpty) {
        expect(find.text('Reset'), findsOneWidget);

        // Now heal +1
        final plusOneButton = find.descendant(
          of: find.byType(HpTrackerCard),
          matching: find.text('+1'),
        );
        await tester.tap(plusOneButton);
        await tester.pumpAndSettle();
      }

      // HP is now >= 1, and Death Saves panel is hidden
      expect(find.text('DEATH SAVING THROWS'), findsNothing);

      // Clean teardown
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    },
  );

  testWidgets('spell slot pips toggle spent and available', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedTestCharacter();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Level 1: 2 / 2 slots available
    expect(find.text('2 / 2'), findsOneWidget);

    // Tap the first slot pip
    final slotIcons = find.byIcon(Icons.circle);
    expect(slotIcons, findsNWidgets(2));
    await tester.tap(slotIcons.first);
    await tester.pumpAndSettle();

    // Now 1 / 2 available
    expect(find.text('1 / 2'), findsOneWidget);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

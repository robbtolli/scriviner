import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/character_sheet_screen.dart';
import 'package:scrivener/features/character_sheet/providers/character_sheet_provider.dart';
import 'package:scrivener/features/combat/providers/combat_session_provider.dart';
import 'package:scrivener/features/dice/presentation/dice_roller_drawer.dart';
import 'package:scrivener/features/home/presentation/home_screen.dart';

void main() {
  group('Title-Bar Dice Roller Tests', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    testWidgets('HomeScreen title bar has Dice Roller button and opens Quick Roll drawer', (tester) async {
      tester.view.physicalSize = const Size(1000, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the Dice Roller button on the HomeScreen AppBar by tooltip
      final diceBtn = find.byTooltip('Dice Roller (Quick Roll)');
      expect(diceBtn, findsOneWidget);

      // Tap Dice Roller button
      await tester.tap(diceBtn);
      await tester.pumpAndSettle();

      // Verify DiceRollerDrawer is visible
      expect(find.byType(DiceRollerDrawer), findsOneWidget);
      expect(find.text('DICE ROLLER'), findsOneWidget);
      expect(find.text('ROLL DICE (1d20)'), findsOneWidget);

      // Tap ROLL DICE
      await tester.tap(find.text('ROLL DICE (1d20)'));
      await tester.pumpAndSettle();

      // Verify roll result is displayed in SnackBar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Rolled'), findsOneWidget);

      // Cleanly unmount and drain StreamQueryStore timers
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('CharacterSheetScreen title bar opens Quick Roll and does NOT modify character attributes', (tester) async {
      tester.view.physicalSize = const Size(1000, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final now = DateTime.now();
      const initialHp = 15;
      const initialMaxHp = 15;

      final sampleProps = {
        'level': 2,
        'class': 'Paladin',
        'race': 'Human',
        'hp': {'current': initialHp, 'max': initialMaxHp, 'temp': 0},
        'armorClass': 16,
        'spellSlots': {'1': {'total': 2, 'spent': 0}},
        'abilities': {
          'str': {'score': 16, 'mod': 3},
          'dex': {'score': 10, 'mod': 0},
          'con': {'score': 14, 'mod': 2},
          'int': {'score': 10, 'mod': 0},
          'wis': {'score': 12, 'mod': 1},
          'cha': {'score': 14, 'mod': 2},
        },
      };

      await db.upsertCharacter(
        CharactersTableCompanion.insert(
          id: 'char-dice-test',
          name: 'Sir Gareth',
          systemId: const Value('dnd5e'),
          createdAt: now,
          lastPlayedAt: now,
          rawPropertiesJson: jsonEncode(sampleProps),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CharacterSheetScreen(characterId: 'char-dice-test'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial sheet state & combat session HP
      final beforeState = container.read(characterSheetProvider('char-dice-test'));
      expect(beforeState?.level, equals(2));
      expect(beforeState?.armorClass, equals(16));
      expect(beforeState?.abilityScores['str'], equals(16));

      final beforeCombat = container.read(combatSessionProvider('char-dice-test'));
      expect(beforeCombat?.currentHp, equals(initialHp));
      expect(beforeCombat?.maxHp, equals(initialMaxHp));

      // Tap Dice Roller icon button in CharacterSheet AppBar
      final sheetDiceBtn = find.byTooltip('Dice Roller (Quick Roll)');
      expect(sheetDiceBtn, findsOneWidget);
      await tester.tap(sheetDiceBtn);
      await tester.pumpAndSettle();

      // Verify DiceRollerDrawer is opened in Quick Roll mode
      expect(find.byType(DiceRollerDrawer), findsOneWidget);

      // Perform a roll
      await tester.tap(find.text('ROLL DICE (1d20)'));
      await tester.pumpAndSettle();

      // Verify roll result is displayed to the user
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Rolled'), findsOneWidget);

      // Verify that after the roll, character attributes remain UNTOUCHED
      final afterState = container.read(characterSheetProvider('char-dice-test'));
      expect(afterState?.level, equals(2));
      expect(afterState?.armorClass, equals(16));
      expect(afterState?.abilityScores['str'], equals(16));

      final afterCombat = container.read(combatSessionProvider('char-dice-test'));
      expect(afterCombat?.currentHp, equals(initialHp));
      expect(afterCombat?.maxHp, equals(initialMaxHp));

      // Cleanly unmount
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    });
  });
}

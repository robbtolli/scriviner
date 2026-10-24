import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/tabs/stats_tab.dart';
import 'package:scrivener/features/character_sheet/providers/character_sheet_provider.dart';
import 'package:scrivener/features/dice/providers/dice_drawer_provider.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedCharacter() async {
    final now = DateTime.now();
    final props = {
      'class': 'Fighter',
      'race': 'Dwarf',
      'level': 3,
      'abilities': {
        'str': {'score': 16, 'mod': 3},
        'dex': {'score': 12, 'mod': 1},
        'con': {'score': 16, 'mod': 3},
        'int': {'score': 10, 'mod': 0},
        'wis': {'score': 14, 'mod': 2},
        'cha': {'score': 8, 'mod': -1},
      },
      'savingThrows': ['str', 'con'],
      'skillProficiencies': {
        'Athletics': 1,
        'Perception': 1,
      },
      'armorClass': 18,
    };

    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: 'char_test',
        name: 'Bruenor',
        systemId: const Value('dnd5e'),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: jsonEncode(props),
      ),
    );
  }

  Widget createWidgetUnderTest(WidgetRef? Function(WidgetRef)? onRef) {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) {
              if (onRef != null) onRef(ref);
              final sheet = ref.watch(characterSheetProvider('char_test'));
              final notifier = ref.read(characterSheetProvider('char_test').notifier);
              if (sheet == null) return const CircularProgressIndicator();
              return StatsTab(state: sheet, notifier: notifier);
            },
          ),
        ),
      ),
    );
  }

  testWidgets('displays all 6 ability scores, modifiers, and passive scores', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedCharacter();
    await tester.pumpWidget(createWidgetUnderTest(null));
    await tester.pumpAndSettle();

    // Verify Overview banner
    expect(find.text('PROFICIENCY'), findsOneWidget);
    expect(find.text('+2'), findsWidgets); // Proficiency is +2 and WIS mod is +2
    expect(find.text('PASSIVE PERC'), findsOneWidget);
    // WIS mod is +2, Perception prof is +2 => 10 + 4 = 14
    expect(find.text('14'), findsOneWidget);

    // Verify 6 Abilities
    expect(find.text('STRENGTH'), findsOneWidget);
    expect(find.text('DEXTERITY'), findsOneWidget);
    expect(find.text('CONSTITUTION'), findsOneWidget);
    expect(find.text('INTELLIGENCE'), findsOneWidget);
    expect(find.text('WISDOM'), findsOneWidget);
    expect(find.text('CHARISMA'), findsOneWidget);

    // Check STR modifier (+3) and score (16)
    expect(find.text('Score: 16'), findsNWidgets(2)); // STR and CON both 16
    expect(find.text('+3'), findsWidgets);

    // Check CHA modifier (-1) and score (8)
    expect(find.text('Score: 8'), findsOneWidget);
    expect(find.text('-1'), findsWidgets);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('tapping check roll populates dice context', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedCharacter();
    WidgetRef? capturedRef;

    await tester.pumpWidget(createWidgetUnderTest((ref) {
      capturedRef = ref;
      return ref;
    }));
    await tester.pumpAndSettle();

    // Find and tap STR Check button
    final checkButton = find.widgetWithText(ElevatedButton, 'CHECK (+3)').first;
    await tester.tap(checkButton);
    await tester.pumpAndSettle();

    // Verify dice drawer state was populated
    final diceState = capturedRef!.read(diceDrawerProvider);
    expect(diceState.contextTitle, 'Bruenor: Strength Check');
    expect(diceState.flatModifier, 3);
    expect(diceState.diceCounts[20], 1);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('toggling saving throw updates proficiency and bonus', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedCharacter();
    WidgetRef? capturedRef;

    await tester.pumpWidget(createWidgetUnderTest((ref) {
      capturedRef = ref;
      return ref;
    }));
    await tester.pumpAndSettle();

    // In initial seed, STR and CON are proficient saves
    final charStateBefore = capturedRef!.read(characterSheetProvider('char_test'))!;
    expect(charStateBefore.savingThrowProficiencies.contains('str'), isTrue);
    expect(charStateBefore.savingThrowProficiencies.contains('dex'), isFalse);

    // Tap DEX Save star/label to toggle
    final dexCard = find.ancestor(
      of: find.text('DEXTERITY'),
      matching: find.byType(Container),
    ).first;

    final dexSaveToggle = find.descendant(
      of: dexCard,
      matching: find.text('SAVE'),
    );
    await tester.tap(dexSaveToggle);
    await tester.pumpAndSettle();

    final charStateAfter = capturedRef!.read(characterSheetProvider('char_test'))!;
    expect(charStateAfter.savingThrowProficiencies.contains('dex'), isTrue);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('editing ability score updates score and modifier', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedCharacter();
    WidgetRef? capturedRef;

    await tester.pumpWidget(createWidgetUnderTest((ref) {
      capturedRef = ref;
      return ref;
    }));
    await tester.pumpAndSettle();

    // Tap edit icon on STR card
    final editIcons = find.byIcon(Icons.edit_outlined);
    await tester.tap(editIcons.first);
    await tester.pumpAndSettle();

    expect(find.text('Edit Strength Score'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);

    // Tap plus icon twice to increase 16 -> 18
    final addIcon = find.byIcon(Icons.add);
    await tester.tap(addIcon);
    await tester.pumpAndSettle();
    await tester.tap(addIcon);
    await tester.pumpAndSettle();

    expect(find.text('18'), findsOneWidget);
    expect(find.text('Modifier: +4'), findsOneWidget);

    // Save via dialog button
    await tester.tap(find.widgetWithText(ElevatedButton, 'SAVE'));
    await tester.pumpAndSettle();

    final updated = capturedRef!.read(characterSheetProvider('char_test'))!;
    expect(updated.getAbilityScore('str'), 18);
    expect(updated.getAbilityModifier('str'), 4);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

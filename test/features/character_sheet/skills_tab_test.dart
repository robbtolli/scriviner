import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/tabs/skills_tab.dart';
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
      'class': 'Rogue',
      'race': 'Elf',
      'level': 1,
      'abilities': {
        'str': {'score': 10, 'mod': 0},
        'dex': {'score': 16, 'mod': 3},
        'con': {'score': 12, 'mod': 1},
        'int': {'score': 14, 'mod': 2},
        'wis': {'score': 12, 'mod': 1},
        'cha': {'score': 10, 'mod': 0},
      },
      'skillProficiencies': {
        'Stealth': 2,      // Expertise: +3 (DEX) + 2 * 2 (Prof) = +7
        'Acrobatics': 1,   // Proficient: +3 (DEX) + 2 (Prof) = +5
        'Athletics': 0,    // Normal: +0 (STR)
      },
    };

    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: 'char_rogue',
        name: 'Shadow',
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
              final sheet = ref.watch(characterSheetProvider('char_rogue'));
              final notifier = ref.read(characterSheetProvider('char_rogue').notifier);
              if (sheet == null) return const CircularProgressIndicator();
              return SkillsTab(state: sheet, notifier: notifier);
            },
          ),
        ),
      ),
    );
  }

  testWidgets('renders skills with accurate bonuses and expertise', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedCharacter();
    await tester.pumpWidget(createWidgetUnderTest(null));
    await tester.pumpAndSettle();

    // Verify skills are present
    expect(find.text('Stealth'), findsOneWidget);
    expect(find.text('Acrobatics'), findsOneWidget);
    expect(find.text('Athletics'), findsOneWidget);

    // Verify Stealth bonus (+7 due to Expertise)
    expect(find.text('+7'), findsOneWidget);

    // Verify Acrobatics bonus (+5 due to Proficiency)
    expect(find.text('+5'), findsOneWidget);

    // Verify Athletics bonus (+0)
    expect(find.text('+0'), findsWidgets);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('filters skills by search and ability chip', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedCharacter();
    await tester.pumpWidget(createWidgetUnderTest(null));
    await tester.pumpAndSettle();

    // Tap STR filter chip
    await tester.tap(find.widgetWithText(FilterChip, 'STR'));
    await tester.pumpAndSettle();

    // Only Athletics should be shown
    expect(find.text('Athletics'), findsOneWidget);
    expect(find.text('Stealth'), findsNothing);
    expect(find.text('Perception'), findsNothing);

    // Reset to ALL
    await tester.tap(find.widgetWithText(FilterChip, 'ALL'));
    await tester.pumpAndSettle();

    // Search for "perc"
    await tester.enterText(find.byType(TextField), 'perc');
    await tester.pumpAndSettle();

    expect(find.text('Perception'), findsOneWidget);
    expect(find.text('Athletics'), findsNothing);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('cycling proficiency toggles None -> Proficient -> Expertise', (tester) async {
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

    // Athletics starts at 0
    final charBefore = capturedRef!.read(characterSheetProvider('char_rogue'))!;
    expect(charBefore.skillProficiencies['Athletics'] ?? 0, 0);

    // Find cycle button next to Athletics
    final athleticsRow = find.ancestor(
      of: find.text('Athletics'),
      matching: find.byType(Container),
    ).first;

    final cycleButton = find.descendant(
      of: athleticsRow,
      matching: find.byType(IconButton),
    );

    // Tap to cycle to Proficient (1)
    await tester.tap(cycleButton);
    await tester.pumpAndSettle();

    final charAfterProf = capturedRef!.read(characterSheetProvider('char_rogue'))!;
    expect(charAfterProf.skillProficiencies['Athletics'], 1);

    // Tap to cycle to Expertise (2)
    await tester.tap(cycleButton);
    await tester.pumpAndSettle();

    final charAfterExp = capturedRef!.read(characterSheetProvider('char_rogue'))!;
    expect(charAfterExp.skillProficiencies['Athletics'], 2);

    // Tap to cycle back to None (0)
    await tester.tap(cycleButton);
    await tester.pumpAndSettle();

    final charAfterReset = capturedRef!.read(characterSheetProvider('char_rogue'))!;
    expect(charAfterReset.skillProficiencies['Athletics'] ?? 0, 0);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('tapping roll skill check configures dice drawer', (tester) async {
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

    // Find Stealth row and tap its ROLL button
    final stealthRow = find.ancestor(
      of: find.text('Stealth'),
      matching: find.byType(Container),
    ).first;

    final rollButton = find.descendant(
      of: stealthRow,
      matching: find.widgetWithText(ElevatedButton, 'ROLL'),
    );

    await tester.tap(rollButton);
    await tester.pumpAndSettle();

    // Verify dice drawer state
    final diceState = capturedRef!.read(diceDrawerProvider);
    expect(diceState.contextTitle, 'Shadow: Stealth Check');
    expect(diceState.flatModifier, 7);
    expect(diceState.diceCounts[20], 1);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

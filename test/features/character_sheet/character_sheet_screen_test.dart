import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/character_sheet_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedFullCharacter() async {
    final now = DateTime.now();
    final props = {
      'class': 'Paladin',
      'race': 'Human',
      'level': 2,
      'abilities': {
        'str': {'score': 16, 'mod': 3},
        'dex': {'score': 10, 'mod': 0},
        'con': {'score': 14, 'mod': 2},
        'cha': {'score': 14, 'mod': 2},
      },
      'hp': {'current': 18, 'max': 18, 'temp': 0},
      'armorClass': 18,
      'speed': 30,
      'spellSlots': {
        '1': {'total': 2, 'spent': 0},
      },
      'spells': [
        {
          'id': 'spell_bless',
          'name': 'Bless',
          'level': 1,
          'school': 'Enchantment',
          'isPrepared': true,
        },
      ],
      'bio': {
        'traits': 'Honorable and upright.',
        'ideals': 'Justice for all.',
        'bonds': 'My oath binds me.',
        'flaws': 'Too trusting of others.',
        'backstory': 'Knight from the northern realm.',
        'sessionNotes': 'Session 1: Traveled to the Sunken Citadel.',
      },
    };

    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: 'char_paladin',
        name: 'Sir Gareth',
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
        home: CharacterSheetScreen(characterId: 'char_paladin'),
      ),
    );
  }

  testWidgets('renders all 7 tabs and allows switching between them', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedFullCharacter();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('Sir Gareth'), findsOneWidget);
    expect(find.textContaining('Level 2 Paladin (Human)'), findsOneWidget);

    // Verify 7 Tabs exist in TabBar
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Skills'), findsOneWidget);
    expect(find.text('Combat'), findsOneWidget);
    expect(find.text('Spells'), findsOneWidget);
    expect(find.text('Features'), findsOneWidget);
    expect(find.text('Gear'), findsOneWidget);
    expect(find.text('Bio & Notes'), findsOneWidget);

    // On Stats tab initially: verify Ability Scores & Proficiency
    expect(find.text('ABILITY SCORES & SAVING THROWS'), findsOneWidget);
    expect(find.text('STRENGTH'), findsOneWidget);
    expect(find.text('PROFICIENCY'), findsOneWidget);

    // Switch to Skills tab
    await tester.tap(find.text('Skills'));
    await tester.pumpAndSettle();

    expect(find.text('Athletics'), findsOneWidget);
    expect(find.text('Perception'), findsOneWidget);
    expect(find.text('TAP ICON TO CYCLE:'), findsOneWidget);

    // Switch to Combat tab
    await tester.tap(find.text('Combat'));
    await tester.pumpAndSettle();

    // On Combat tab: verify HP display (18 / 18)
    expect(find.text('18'), findsWidgets);

    // Switch to Spells tab
    await tester.tap(find.text('Spells'));
    await tester.pumpAndSettle();

    expect(find.text('Bless'), findsOneWidget);
    expect(find.text('SPELL SAVE DC'), findsOneWidget);

    // Switch to Gear tab
    await tester.tap(find.text('Gear'));
    await tester.pumpAndSettle();

    expect(find.text('CURRENCY WALLET'), findsOneWidget);
    expect(find.text('WEIGHT & CAPACITY'), findsOneWidget);

    // Switch to Bio & Notes tab
    await tester.tap(find.text('Bio & Notes'));
    await tester.pumpAndSettle();

    expect(find.text('ROLEPLAYING TRAITS & NOTES'), findsOneWidget);
    expect(find.text('Honorable and upright.'), findsOneWidget);
    expect(find.text('SAVE'), findsOneWidget);

    // Tap SAVE button
    await tester.tap(find.text('SAVE'));
    await tester.pumpAndSettle();

    expect(find.text('Notes and Biography saved!'), findsOneWidget);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('allows editing character name inline with check and cancel buttons', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedFullCharacter();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify initial character name and pencil edit icon
    expect(find.text('Sir Gareth'), findsOneWidget);
    final editNameBtn = find.byTooltip('Edit character name');
    expect(editNameBtn, findsOneWidget);

    // 1. Tap pencil edit button to enter edit mode
    await tester.tap(editNameBtn);
    await tester.pumpAndSettle();

    // Verify pencil button is hidden and check / cancel buttons appear
    expect(find.byTooltip('Edit character name'), findsNothing);
    expect(find.byTooltip('Confirm new name'), findsOneWidget);
    expect(find.byTooltip('Cancel edit'), findsOneWidget);

    // Verify TextField has current name
    final nameField = find.byType(TextField);
    expect(nameField, findsOneWidget);
    expect(tester.widget<TextField>(nameField).controller?.text, 'Sir Gareth');

    // 2. Test Cancel button
    await tester.enterText(nameField, 'Sir Lancelot');
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Cancel edit'));
    await tester.pumpAndSettle();

    // Verify canceled: original name preserved and pencil button restored
    expect(find.text('Sir Gareth'), findsOneWidget);
    expect(find.text('Sir Lancelot'), findsNothing);
    expect(find.byTooltip('Edit character name'), findsOneWidget);
    expect(find.byTooltip('Confirm new name'), findsNothing);

    // 3. Test Confirm button
    await tester.tap(find.byTooltip('Edit character name'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Sir Gareth the Brave');
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Confirm new name'));
    await tester.pumpAndSettle();

    // Verify confirmed: new name is displayed and SnackBar appeared
    expect(find.text('Sir Gareth the Brave'), findsOneWidget);
    expect(find.byTooltip('Edit character name'), findsOneWidget);
    expect(find.textContaining('Character name updated to "Sir Gareth the Brave"!'), findsOneWidget);

    // Verify updated in SQLite database
    final dbChar = await db.getCharacter('char_paladin');
    expect(dbChar?.name, 'Sir Gareth the Brave');

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

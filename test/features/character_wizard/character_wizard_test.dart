import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_wizard/presentation/character_wizard_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildWizardApp({void Function(String)? onCreated}) {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CharacterWizardScreen(onCharacterCreated: onCreated),
                    ),
                  );
                },
                child: const Text('LAUNCH WIZARD'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('walks through character wizard, saves character, and resets for next character', (tester) async {
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    String? createdCharId;
    await tester.pumpWidget(buildWizardApp(onCreated: (id) => createdCharId = id));
    await tester.pumpAndSettle();

    // 1. Launch Wizard First Time
    await tester.tap(find.text('LAUNCH WIZARD'));
    await tester.pumpAndSettle();

    // Step 1: Concept & Name
    expect(find.text('Step 1: Character Concept & Identity'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Eldrin Stargazer');
    await tester.pumpAndSettle();

    await tester.tap(find.text('NEXT STEP'));
    await tester.pumpAndSettle();

    // Step 2: Race
    expect(find.text('Step 2: Choose Race & Lineage'), findsOneWidget);
    final elfFinder = find.text('Elf').first;
    await tester.ensureVisible(elfFinder);
    await tester.tap(elfFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('NEXT STEP'));
    await tester.pumpAndSettle();

    // Step 3: Class
    expect(find.text('Step 3: Choose Class'), findsOneWidget);
    final wizardFinder = find.text('Wizard').first;
    await tester.ensureVisible(wizardFinder);
    await tester.tap(wizardFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('NEXT STEP'));
    await tester.pumpAndSettle();

    // Step 4: Ability Scores
    expect(find.text('Step 4: Ability Scores'), findsOneWidget);
    await tester.tap(find.text('NEXT STEP'));
    await tester.pumpAndSettle();

    // Step 5: Background & Skills
    expect(find.text('Step 5: Background & Skills'), findsOneWidget);
    final sageFinder = find.text('Sage').first;
    await tester.ensureVisible(sageFinder);
    await tester.tap(sageFinder);
    await tester.pumpAndSettle();

    final investFinder = find.text('Investigation').first;
    await tester.ensureVisible(investFinder);
    await tester.tap(investFinder);
    await tester.pumpAndSettle();

    final religionFinder = find.text('Religion').first;
    await tester.ensureVisible(religionFinder);
    await tester.tap(religionFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('NEXT STEP'));
    await tester.pumpAndSettle();

    // Step 6: Equipment & Spells
    expect(find.text('Step 6: Equipment & Magic'), findsOneWidget);
    final fireBoltFinder = find.text('Fire Bolt').first;
    await tester.ensureVisible(fireBoltFinder);
    await tester.tap(fireBoltFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('NEXT STEP'));
    await tester.pumpAndSettle();

    // Step 7: Review & Embark
    expect(find.text('Step 7: Review & Embark'), findsOneWidget);
    final embarkFinder = find.text('EMBARK ON ADVENTURE');
    expect(embarkFinder, findsOneWidget);
    await tester.ensureVisible(embarkFinder);
    await tester.tap(embarkFinder);
    await tester.pumpAndSettle();

    // 2. Verify Character Was Saved to Database
    expect(createdCharId, isNotNull);
    final savedChar = await db.getCharacter(createdCharId!);
    expect(savedChar, isNotNull);
    expect(savedChar!.name, equals('Eldrin Stargazer'));
    expect(savedChar.systemId, equals('dnd5e'));

    // We should be back on the launcher screen
    expect(find.text('LAUNCH WIZARD'), findsOneWidget);

    // 3. Launch Wizard a Second Time (User Issue Reproduction & Fix Verification)
    await tester.tap(find.text('LAUNCH WIZARD'));
    await tester.pumpAndSettle();

    // Verify it starts fresh on Step 1, NOT on Step 7 of the previous character!
    expect(find.text('Step 1: Character Concept & Identity'), findsOneWidget);
    expect(find.text('Step 7: Review & Embark'), findsNothing);

    // Verify the name input is empty
    final textField = tester.widget<TextField>(find.byType(TextField).first);
    expect(textField.controller?.text ?? '', isEmpty);

    // Clean unmount
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('generates male, female, or random names based on gender selection', (tester) async {
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildWizardApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('LAUNCH WIZARD'));
    await tester.pumpAndSettle();

    // 1. By default, Blank / Any is selected. Generate a name.
    await tester.tap(find.text('RANDOM'));
    await tester.pumpAndSettle();
    var textField = tester.widget<TextField>(find.byType(TextField).first);
    expect(textField.controller?.text ?? '', isNotEmpty);

    // 2. Select Male
    await tester.tap(find.text('Male'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('RANDOM'));
    await tester.pumpAndSettle();
    textField = tester.widget<TextField>(find.byType(TextField).first);
    final maleName = textField.controller?.text ?? '';
    expect(maleName, isNotEmpty);

    // 3. Select Female
    await tester.tap(find.text('Female'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('RANDOM'));
    await tester.pumpAndSettle();
    textField = tester.widget<TextField>(find.byType(TextField).first);
    final femaleName = textField.controller?.text ?? '';
    expect(femaleName, isNotEmpty);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

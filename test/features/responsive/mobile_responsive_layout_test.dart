import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/widgets/level_up_wizard_dialog.dart';
import 'package:scrivener/features/character_sheet/providers/character_sheet_provider.dart';
import 'package:scrivener/features/character_wizard/presentation/character_wizard_screen.dart';
import 'package:scrivener/features/character_wizard/presentation/steps/step_1_concept.dart';
import 'package:scrivener/features/character_wizard/presentation/steps/step_4_abilities.dart';
import 'package:scrivener/features/home/presentation/home_screen.dart';
import 'package:scrivener/features/home/presentation/widgets/new_character_modal.dart';
import 'package:scrivener/features/home/presentation/widgets/resume_hero_card.dart';

void main() {
  group('Mobile & Narrow Screen Layout Tests', () {
    testWidgets(
      'HomeScreen title bar does not overflow on 360px phone width and omits + New Hero',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(() => db.close());

        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: const MaterialApp(home: HomeScreen()),
          ),
        );
        await tester.pumpAndSettle();

        // Verify SCRIVENER title and action icons exist
        expect(find.text('SCRIVENER'), findsOneWidget);
        expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
        expect(find.byIcon(Icons.extension_outlined), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);

        // Verify "+ New Hero" / "NEW HERO" is absent from AppBar
        expect(find.widgetWithText(ElevatedButton, 'NEW HERO'), findsNothing);
        expect(find.widgetWithText(ElevatedButton, 'New Hero'), findsNothing);

        // FAB is present
        expect(find.byType(FloatingActionButton), findsOneWidget);

        // Tap FAB to open NewCharacterModal
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(find.byType(NewCharacterModal), findsOneWidget);

        // Dismiss dialog
        Navigator.of(tester.element(find.byType(NewCharacterModal))).pop();
        await tester.pumpAndSettle();

        // Cleanly unmount and drain StreamQueryStore timers
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 50));
      },
    );

    testWidgets(
      'NewCharacterModal titles wrap and bottom buttons wrap on narrow phone (340px width)',
      (tester) async {
        tester.view.physicalSize = const Size(340, 700);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NewCharacterModal(
                onStartCreation: (systemId, mode) {},
                onImportCharacter: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Titles and badges render without exception
        expect(find.text('Dungeons & Dragons 5e / 2024'), findsOneWidget);
        expect(find.text('Guided Step-by-Step Wizard'), findsOneWidget);
        expect(find.text('RECOMMENDED'), findsOneWidget);

        // Verify bottom action buttons: IMPORT JSON, Cancel, START CREATING
        expect(find.text('IMPORT JSON'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('START CREATING'), findsOneWidget);

        // Ensure no RenderFlex overflow occurred
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'NewCharacterModal scrolls in landscape mode (640x360) without overflow',
      (tester) async {
        // Landscape phone orientation
        tester.view.physicalSize = const Size(640, 360);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NewCharacterModal(
                onStartCreation: (systemId, mode) {},
                onImportCharacter: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Ensure the modal scroll view handles short viewport
        expect(find.byType(SingleChildScrollView), findsWidgets);
        expect(find.text('Create New Character'), findsOneWidget);

        // Scroll to bottom
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        expect(find.text('START CREATING'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Step 1 Concept gender selector has only Male and Female (no Blank/Any) on narrow screen',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: Scaffold(body: Step1Concept())),
          ),
        );
        await tester.pumpAndSettle();

        // Verify Male and Female segments exist
        expect(find.text('Male'), findsOneWidget);
        expect(find.text('Female'), findsOneWidget);

        // Verify Blank / Any is removed
        expect(find.text('Blank / Any'), findsNothing);
        expect(find.text('Any / Blank'), findsNothing);

        // Tap Female and generate random name
        await tester.tap(find.text('Female'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('RANDOM'));
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(
          find.byType(TextField).first,
        );
        expect(textField.controller?.text, isNotEmpty);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('CharacterWizardScreen bottom bar is wrapped in SafeArea', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: CharacterWizardScreen())),
      );
      await tester.pumpAndSettle();

      // Find the SafeArea in the bottom navigation bar
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.bottomNavigationBar, isNotNull);

      expect(find.widgetWithText(ElevatedButton, 'NEXT STEP'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SafeArea),
          matching: find.text('NEXT STEP'),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'Step 4 Abilities selector and auto-assign banner do not overflow on 320px width',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: Scaffold(body: Step4Abilities())),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Standard Array'), findsOneWidget);
        expect(find.text('Point Buy'), findsOneWidget);
        expect(find.text('Roll 4d6'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'ResumeHeroCard renders stat pills and continue button cleanly on 320px phone',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final char = CharactersTableData(
          id: 'hero_1',
          name: 'Sir Gareth of the Northern High Steppes',
          systemId: 'dnd5e',
          createdAt: DateTime.now(),
          lastPlayedAt: DateTime.now(),
          notes: '',
          rawPropertiesJson: jsonEncode({
            'class': 'Paladin Oath of Devotion',
            'race': 'Mountain Dwarf',
            'level': 10,
            'hp': {'current': 95, 'max': 95},
            'armorClass': 20,
          }),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ResumeHeroCard(character: char, onResume: () {}),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('RESUME SESSION'), findsOneWidget);
        expect(find.text('CONTINUE'), findsOneWidget);
        expect(find.text('95 / 95'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('LevelUpWizardDialog fits within landscape screen (640x360)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(640, 360);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final charState = CharacterSheetState(
        characterId: 'char_test',
        name: 'Thorin',
        className: 'Fighter',
        raceName: 'Dwarf',
        level: 3,
        armorClass: 16,
        abilityScores: const {
          'str': 16,
          'dex': 12,
          'con': 16,
          'int': 10,
          'wis': 12,
          'cha': 8,
        },
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => LevelUpWizardDialog(
                          state: charState,
                          notifier: container.read(
                            characterSheetProvider('char_test').notifier,
                          ),
                        ),
                      );
                    },
                    child: const Text('OPEN LEVEL UP'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN LEVEL UP'));
      await tester.pumpAndSettle();

      expect(find.text('LEVEL UP WIZARD'), findsOneWidget);
      expect(find.textContaining('Level 3 to 4'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

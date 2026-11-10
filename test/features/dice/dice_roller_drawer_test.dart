import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/features/dice/models/dice_roll_record.dart';
import 'package:scrivener/features/dice/presentation/dice_roller_drawer.dart';
import 'package:scrivener/features/dice/presentation/widgets/floating_dice_fab.dart';

void main() {
  Widget createWidgetUnderTest({Widget? child}) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: child ?? const DiceRollerDrawer(isBottomSheet: true),
        ),
      ),
    );
  }

  testWidgets('renders dice roller drawer with all controls', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify Title & Default Formula (starts empty)
    expect(find.text('DICE ROLLER'), findsOneWidget);
    expect(find.text('Select dice'), findsOneWidget);

    // Verify Polyhedral dice buttons
    expect(find.text('d4'), findsOneWidget);
    expect(find.text('d6'), findsOneWidget);
    expect(find.text('d8'), findsOneWidget);
    expect(find.text('d10'), findsOneWidget);
    expect(find.text('d12'), findsOneWidget);
    expect(find.text('d20'), findsOneWidget);
    expect(find.text('d100'), findsOneWidget);

    // Verify Roll Types & label
    expect(find.text('ROLL TYPE (d20 ONLY)'), findsOneWidget);
    expect(find.text('Normal'), findsOneWidget);
    expect(find.text('Advantage'), findsOneWidget);
    expect(find.text('Disadvantage'), findsOneWidget);

    // Verify Situational Modifiers
    expect(find.text('+1d4 Bless'), findsOneWidget);
    expect(find.text('+1d6 Inspiration'), findsOneWidget);
  });

  testWidgets(
    'tapping polyhedral dice and modifiers updates formula dynamically',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap d6 button
      await tester.tap(find.text('d6'));
      await tester.pumpAndSettle();

      // Formula should now be "1d6"
      expect(find.text('1d6'), findsOneWidget);

      // Tap d20 button
      await tester.tap(find.text('d20'));
      await tester.pumpAndSettle();

      // Formula should now be "1d20 + 1d6"
      expect(find.text('1d20 + 1d6'), findsOneWidget);

      // Tap Advantage
      await tester.tap(find.text('Advantage'));
      await tester.pumpAndSettle();

      // Formula should now be "2d20kh1 + 1d6"
      expect(find.text('2d20kh1 + 1d6'), findsOneWidget);

      // Tap +1d4 Bless
      await tester.tap(find.text('+1d4 Bless'));
      await tester.pumpAndSettle();

      // Formula should now be "2d20kh1 + 1d6 + 1d4"
      expect(find.text('2d20kh1 + 1d6 + 1d4'), findsOneWidget);
    },
  );

  testWidgets(
    'Roll Type segmented button is disabled without d20 and enabled with d20',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final segmentedBtnFinder = find.byType(SegmentedButton<RollType>);
      expect(segmentedBtnFinder, findsOneWidget);

      // Without d20, onSelectionChanged is null (disabled)
      var segmentedBtn = tester.widget<SegmentedButton<RollType>>(
        segmentedBtnFinder,
      );
      expect(segmentedBtn.onSelectionChanged, isNull);

      // Tapping Advantage does nothing
      await tester.tap(find.text('Advantage'));
      await tester.pumpAndSettle();
      segmentedBtn = tester.widget<SegmentedButton<RollType>>(
        segmentedBtnFinder,
      );
      expect(segmentedBtn.selected, equals({RollType.normal}));

      // Add a d6 -> still no d20 -> still disabled
      await tester.tap(find.text('d6'));
      await tester.pumpAndSettle();
      segmentedBtn = tester.widget<SegmentedButton<RollType>>(
        segmentedBtnFinder,
      );
      expect(segmentedBtn.onSelectionChanged, isNull);

      // Add a d20 -> now enabled
      await tester.tap(find.text('d20'));
      await tester.pumpAndSettle();
      segmentedBtn = tester.widget<SegmentedButton<RollType>>(
        segmentedBtnFinder,
      );
      expect(segmentedBtn.onSelectionChanged, isNotNull);

      // Now tapping Advantage selects Advantage
      await tester.tap(find.text('Advantage'));
      await tester.pumpAndSettle();
      segmentedBtn = tester.widget<SegmentedButton<RollType>>(
        segmentedBtnFinder,
      );
      expect(segmentedBtn.selected, equals({RollType.advantage}));
      expect(find.text('2d20kh1 + 1d6'), findsOneWidget);

      // Clearing the d20 resets selection back to normal and disables the button
      await tester.tap(find.byKey(const ValueKey('clear_die_d20')));
      await tester.pumpAndSettle();
      segmentedBtn = tester.widget<SegmentedButton<RollType>>(
        segmentedBtnFinder,
      );
      expect(segmentedBtn.selected, equals({RollType.normal}));
      expect(segmentedBtn.onSelectionChanged, isNull);
    },
  );

  testWidgets(
    'active polyhedral dice show top-left x badge that removes that dice type on tap',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initially no clear_die_d6 badge is shown
      expect(find.byKey(const ValueKey('clear_die_d6')), findsNothing);
      expect(find.byKey(const ValueKey('clear_die_d8')), findsNothing);

      // Tap d6 three times -> 3d6, and d8 once -> 1d8
      await tester.tap(find.text('d6'));
      await tester.tap(find.text('d6'));
      await tester.tap(find.text('d6'));
      await tester.tap(find.text('d8'));
      await tester.pumpAndSettle();

      expect(find.text('1d8 + 3d6'), findsOneWidget);
      final clearD6Finder = find.byKey(const ValueKey('clear_die_d6'));
      expect(clearD6Finder, findsOneWidget);
      expect(find.byKey(const ValueKey('clear_die_d8')), findsOneWidget);

      // Verify the x badge is completely opaque (alpha == 255) and overhangs the top-left of the button
      final badgeContainer = tester.widget<Container>(
        find.descendant(of: clearD6Finder, matching: find.byType(Container)),
      );
      final badgeDecoration = badgeContainer.decoration as BoxDecoration;
      expect(badgeDecoration.color!.a, equals(1.0));

      final d6InkWellFinder = find.ancestor(
        of: find.text('d6'),
        matching: find.byType(InkWell),
      );
      final buttonRect = tester.getRect(d6InkWellFinder);
      final badgeRect = tester.getRect(clearD6Finder);
      expect(badgeRect.left, lessThan(buttonRect.left));
      expect(badgeRect.top, lessThan(buttonRect.top));

      // Tap the top-left 'x' on d6 to remove all d6s at once
      await tester.tap(clearD6Finder);
      await tester.pumpAndSettle();

      // d6 is completely removed from the formula and its 'x' badge is gone
      expect(find.byKey(const ValueKey('clear_die_d6')), findsNothing);
      expect(find.byKey(const ValueKey('clear_die_d8')), findsOneWidget);
      expect(find.text('1d8'), findsOneWidget);
    },
  );

  testWidgets('ROLL button is disabled when empty, rolls when dice selected', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap ROLL button while empty - should not roll
    await tester.tap(find.text('ROLL'));
    await tester.pumpAndSettle();
    expect(find.text('No rolls yet this session'), findsOneWidget);

    // Add a d20
    await tester.tap(find.text('d20'));
    await tester.pumpAndSettle();

    // Now tap ROLL button
    await tester.tap(find.text('ROLL'));
    await tester.pumpAndSettle();

    // History section should now have RECENT ROLLS (1)
    expect(find.text('RECENT ROLLS (1)'), findsOneWidget);
    expect(find.text('Quick Roll'), findsOneWidget);

    // Tap Clear
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    // History is now empty
    expect(find.text('No rolls yet this session'), findsOneWidget);
  });

  testWidgets(
    'ROLL button is a bottom floating action button where ROLL text disappears during 3D roll',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find the FloatingActionButton containing ROLL
      final rollFabFinder = find.ancestor(
        of: find.text('ROLL'),
        matching: find.byType(FloatingActionButton),
      );
      expect(rollFabFinder, findsOneWidget);

      final fab = tester.widget<FloatingActionButton>(rollFabFinder);
      expect(fab.backgroundColor, Colors.transparent);
      expect(fab.elevation, 0);
      expect(fab.splashColor, Colors.transparent);

      // Verify FAB is positioned near the bottom of the screen
      final fabCenter = tester.getCenter(rollFabFinder);
      expect(
        fabCenter.dy,
        greaterThan(1000),
      ); // Near bottom of 1200 height screen

      // Verify 1.5x size (84x84)
      expect(tester.getSize(rollFabFinder), const Size(84, 84));

      // Select d20
      await tester.tap(find.text('d20'));
      await tester.pumpAndSettle();

      // Tap ROLL button and pump mid-tumble animation (200ms)
      await tester.tap(rollFabFinder);
      await tester.pump(const Duration(milliseconds: 200));

      // The button is disabled while animating
      final fabDuringAnim = tester.widget<FloatingActionButton>(rollFabFinder);
      expect(fabDuringAnim.onPressed, isNull);

      // The word "ROLL" text is hidden (opacity 0) while die is tumbling
      final rollOpacityFinder = find
          .ancestor(of: find.text('ROLL'), matching: find.byType(Opacity))
          .first;
      final rollOpacity = tester.widget<Opacity>(rollOpacityFinder);
      expect(rollOpacity.opacity, 0.0);

      // Settle animation
      await tester.pumpAndSettle();

      // After settling, button is re-enabled and ROLL text is fully visible (opacity 1.0)
      final fabAfterAnim = tester.widget<FloatingActionButton>(rollFabFinder);
      expect(fabAfterAnim.onPressed, isNotNull);
      final settledOpacity = tester.widget<Opacity>(rollOpacityFinder);
      expect(settledOpacity.opacity, 1.0);
      expect(find.text('RECENT ROLLS (1)'), findsOneWidget);
    },
  );

  testWidgets(
    'Formula x clear button is always visible, clears formula, and hides dice result',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Header Reset button is replaced by the always-visible formula x button
      expect(find.text('Reset'), findsNothing);
      final clearBtnFinder = find.byKey(const ValueKey('clear_formula_button'));
      expect(clearBtnFinder, findsOneWidget);

      // Add d20 and roll
      await tester.tap(find.text('d20'));
      await tester.pumpAndSettle();
      expect(find.text('1d20'), findsOneWidget);

      await tester.tap(find.text('ROLL'));
      await tester.pumpAndSettle();

      // Tap formula 'x' button
      await tester.tap(clearBtnFinder);
      await tester.pumpAndSettle();

      // Formula is cleared back to empty and clear button remains visible
      final textField = tester.widget<TextField>(
        find.byKey(const ValueKey('formula_text_field')),
      );
      expect(textField.controller?.text, isEmpty);
      expect(clearBtnFinder, findsOneWidget);

      // Tapping ROLL does nothing because it's disabled
      await tester.tap(find.text('ROLL'));
      await tester.pumpAndSettle();
      // No new roll was added
      expect(find.text('RECENT ROLLS (1)'), findsOneWidget);
    },
  );

  testWidgets(
    'User can tap formula to type a custom formula with live validation and ROLL gating',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final formulaField = find.byKey(const ValueKey('formula_text_field'));
      final rollFabFinder = find.ancestor(
        of: find.text('ROLL'),
        matching: find.byType(FloatingActionButton),
      );
      final clearBtnFinder = find.byKey(const ValueKey('clear_formula_button'));

      // Initially ROLL is disabled
      expect(
        tester.widget<FloatingActionButton>(rollFabFinder).onPressed,
        isNull,
      );

      // Tap formula field and type an invalid formula
      await tester.tap(formulaField);
      await tester.enterText(formulaField, '2d6 + invalid');
      await tester.pumpAndSettle();

      expect(find.text('Invalid formula'), findsOneWidget);
      expect(
        tester.widget<FloatingActionButton>(rollFabFinder).onPressed,
        isNull,
      );
      // Clear 'x' button is still visible while editing
      expect(clearBtnFinder, findsOneWidget);

      // Now type a valid formula
      await tester.enterText(formulaField, '2d6 + 3');
      await tester.pumpAndSettle();

      expect(find.text('Invalid formula'), findsNothing);
      expect(
        tester.widget<FloatingActionButton>(rollFabFinder).onPressed,
        isNotNull,
      );
      // d6 button is synced and active (shows clear_die_d6 badge)
      expect(find.byKey(const ValueKey('clear_die_d6')), findsOneWidget);

      // Roll the typed formula
      await tester.tap(rollFabFinder);
      await tester.pumpAndSettle();
      expect(find.text('RECENT ROLLS (1)'), findsOneWidget);
    },
  );

  testWidgets('FloatingDiceFab opens dice roller bottom sheet on tap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      createWidgetUnderTest(
        child: const Stack(
          children: [
            Center(child: Text('Main Screen Content')),
            Positioned(bottom: 16, right: 16, child: FloatingDiceFab()),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap the FAB
    await tester.tap(find.byType(FloatingDiceFab));
    await tester.pumpAndSettle();

    // Verify Dice Roller drawer sheet opened
    expect(find.text('DICE ROLLER'), findsOneWidget);
    expect(find.text('ROLL'), findsOneWidget);
  });
}

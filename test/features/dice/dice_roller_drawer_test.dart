import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

    // Verify Title & Default Formula
    expect(find.text('DICE ROLLER'), findsOneWidget);
    expect(find.text('1d20'), findsOneWidget);

    // Verify Polyhedral dice buttons
    expect(find.text('d4'), findsOneWidget);
    expect(find.text('d6'), findsOneWidget);
    expect(find.text('d8'), findsOneWidget);
    expect(find.text('d10'), findsOneWidget);
    expect(find.text('d12'), findsOneWidget);
    expect(find.text('d20'), findsOneWidget);
    expect(find.text('d100'), findsOneWidget);

    // Verify Roll Types
    expect(find.text('Normal'), findsOneWidget);
    expect(find.text('Advantage'), findsOneWidget);
    expect(find.text('Disadvantage'), findsOneWidget);

    // Verify Situational Modifiers
    expect(find.text('+1d4 Bless'), findsOneWidget);
    expect(find.text('+1d6 Inspiration'), findsOneWidget);
  });

  testWidgets('tapping polyhedral dice and modifiers updates formula dynamically', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap d6 button
    await tester.tap(find.text('d6'));
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
  });

  testWidgets('ROLL DICE button executes roll and records to history', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap ROLL DICE button
    await tester.tap(find.textContaining('ROLL DICE'));
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

  testWidgets('FloatingDiceFab opens dice roller bottom sheet on tap', (tester) async {
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      createWidgetUnderTest(
        child: const Stack(
          children: [
            Center(child: Text('Main Screen Content')),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingDiceFab(),
            ),
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
    expect(find.textContaining('ROLL DICE'), findsOneWidget);
  });
}

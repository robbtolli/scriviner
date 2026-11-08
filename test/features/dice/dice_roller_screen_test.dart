import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/features/dice/presentation/dice_roller_drawer.dart';
import 'package:scrivener/features/dice/presentation/dice_roller_screen.dart';
import 'package:scrivener/features/dice/presentation/widgets/floating_dice_fab.dart';
import 'package:scrivener/features/dice/presentation/widgets/rolling_dice_stage.dart';

void main() {
  testWidgets(
    'DiceRollerScreen renders full-screen with AppBar and dice controls',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiceRollerScreen())),
      );
      await tester.pumpAndSettle();

      // Verify AppBar with title and reset action
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('DICE ROLLER'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);

      // Verify dice tray controls
      expect(find.text('d20'), findsOneWidget);
      expect(find.text('d12'), findsOneWidget);
      expect(find.text('d6'), findsOneWidget);
      expect(find.text('ROLL'), findsOneWidget);

      // Tap ROLL button
      await tester.tap(find.text('ROLL'));
      await tester.pumpAndSettle();

      // Verify stage renders
      expect(find.byType(RollingDiceStage), findsOneWidget);
    },
  );

  testWidgets(
    'FloatingDiceFab.openFullScreenDiceRoller launches DiceRollerScreen',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () =>
                      FloatingDiceFab.openFullScreenDiceRoller(context),
                  child: const Icon(Icons.casino),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap button to open full-screen dice roller
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify DiceRollerScreen is navigated to
      expect(find.byType(DiceRollerScreen), findsOneWidget);
      expect(find.text('DICE ROLLER'), findsOneWidget);
    },
  );

  testWidgets(
    'FloatingDiceFab.openDiceRoller opens bottom sheet instead of full screen',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () => FloatingDiceFab.openDiceRoller(context),
                  child: const Icon(Icons.casino),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap button to open bottom sheet dice roller
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify bottom sheet DiceRollerDrawer is shown, not full-screen DiceRollerScreen
      expect(find.byType(DiceRollerScreen), findsNothing);
      expect(find.byType(DiceRollerDrawer), findsOneWidget);
      final drawer = tester.widget<DiceRollerDrawer>(
        find.byType(DiceRollerDrawer),
      );
      expect(drawer.isBottomSheet, isTrue);
    },
  );
}

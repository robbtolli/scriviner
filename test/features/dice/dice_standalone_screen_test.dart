import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/theme/theme_selector_dialog.dart';
import 'package:scrivener/dice_app.dart';
import 'package:scrivener/features/dice/presentation/dice_roller_drawer.dart';
import 'package:scrivener/features/dice/presentation/dice_standalone_screen.dart';
import 'package:scrivener/features/dice/presentation/widgets/about_dice_caster_dialog.dart';
import 'package:scrivener/features/dice/presentation/widgets/rolling_dice_stage.dart';

void main() {
  group('Dice Caster Standalone App', () {
    testWidgets(
      'renders DiceCasterApp with AppBar, title, theme, and about action',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: DiceCasterApp()));
        await tester.pumpAndSettle();

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('DICE CASTER'), findsOneWidget);
        expect(
          find.image(
            const AssetImage('assets/icons/dice_caster_icon_transparent.png'),
          ),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
        expect(find.byType(DiceRollerDrawer), findsOneWidget);
      },
    );

    testWidgets('opens AboutDiceCasterDialog and displays info', (
      tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: DiceCasterApp()));
      await tester.pumpAndSettle();

      // Tap about button in AppBar
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      // Verify AboutDiceCasterDialog is shown
      expect(find.byType(AboutDiceCasterDialog), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AboutDiceCasterDialog),
          matching: find.image(
            const AssetImage('assets/icons/dice_caster_icon_transparent.png'),
          ),
        ),
        findsOneWidget,
      );
      expect(find.text('What is a Dice Caster?'), findsOneWidget);
      expect(find.text('Robert Tolliver (tollitech.com)'), findsOneWidget);
      expect(find.text('MPL 2.0'), findsOneWidget);

      // Tap CLOSE to dismiss
      await tester.tap(find.text('CLOSE'));
      await tester.pumpAndSettle();

      expect(find.byType(AboutDiceCasterDialog), findsNothing);
    });

    testWidgets('opens ThemeSelectorDialog and switches theme', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: DiceCasterApp()));
      await tester.pumpAndSettle();

      // Tap theme button in AppBar
      await tester.tap(find.byIcon(Icons.palette_outlined));
      await tester.pumpAndSettle();

      // Verify ThemeSelectorDialog is shown
      expect(find.byType(ThemeSelectorDialog), findsOneWidget);
      expect(find.text('SELECT APP THEME'), findsOneWidget);

      // Verify Scrivener theme choices are available
      expect(find.text('Midnight Arcana'), findsOneWidget);

      // Select a theme (applies live)
      await tester.tap(find.text('Midnight Arcana'));
      await tester.pumpAndSettle();

      // Tap DONE to dismiss dialog
      await tester.tap(find.text('DONE'));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.byType(ThemeSelectorDialog), findsNothing);
    });

    testWidgets('rolls dice successfully in standalone screen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DiceStandaloneScreen())),
      );
      await tester.pumpAndSettle();

      // Verify tray controls
      expect(find.text('d20'), findsOneWidget);
      expect(find.text('ROLL'), findsOneWidget);

      // Tap d20 and ROLL
      await tester.tap(find.text('d20'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ROLL'));
      await tester.pumpAndSettle();

      // Verify stage renders
      expect(find.byType(RollingDiceStage), findsOneWidget);
    });

    testWidgets('renders cleanly on narrow 360x640 mobile viewports', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ProviderScope(child: DiceCasterApp()));
      await tester.pumpAndSettle();

      expect(find.text('DICE CASTER'), findsOneWidget);
      expect(find.text('d20'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on landscape 640x360 mobile viewports', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(640, 360);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ProviderScope(child: DiceCasterApp()));
      await tester.pumpAndSettle();

      expect(find.text('DICE CASTER'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

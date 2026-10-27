import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/features/character_wizard/presentation/steps/step_2_race.dart';

void main() {
  testWidgets(
    'Human race card shows Human title and wraps modifiers on narrow 360px and 320px phone screens',
    (tester) async {
      // Test on standard phone width (360px)
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: Step2Race())),
        ),
      );
      await tester.pumpAndSettle();

      // Verify "Human" title is present and visible
      final humanFinder = find.text('Human');
      expect(humanFinder, findsOneWidget);
      await tester.ensureVisible(humanFinder);

      final humanCard = find
          .ancestor(of: humanFinder, matching: find.byType(InkWell))
          .first;

      // Verify all 6 attribute modifier badges are displayed on the Human card
      expect(
        find.descendant(of: humanCard, matching: find.text('+1 STR')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: humanCard, matching: find.text('+1 DEX')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: humanCard, matching: find.text('+1 CON')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: humanCard, matching: find.text('+1 INT')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: humanCard, matching: find.text('+1 WIS')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: humanCard, matching: find.text('+1 CHA')),
        findsOneWidget,
      );

      // Verify title has substantial non-zero width and height (not squished to 0px)
      final renderBox = tester.renderObject<RenderBox>(humanFinder);
      expect(renderBox.size.width, greaterThan(30));
      expect(renderBox.size.height, greaterThan(15));

      // Tap to select Human
      await tester.tap(humanFinder);
      await tester.pumpAndSettle();

      // Checkmark appears and "Human" is still clearly displayed
      expect(find.text('Human'), findsOneWidget);
      expect(
        find.descendant(
          of: humanCard,
          matching: find.byIcon(Icons.check_circle),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      // Now re-verify on an ultra-narrow 320px phone screen
      tester.view.physicalSize = const Size(320, 640);
      await tester.pumpAndSettle();

      expect(find.text('Human'), findsOneWidget);
      final renderBox320 = tester.renderObject<RenderBox>(humanFinder);
      expect(renderBox320.size.width, greaterThan(30));
      expect(tester.takeException(), isNull);
    },
  );
}

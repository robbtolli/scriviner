import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/app.dart';
import 'package:scrivener/dice_app.dart';
import 'package:scrivener/main.dart' as app_entry;

void main() {
  group('rootAppForFlavor', () {
    test('returns DiceCasterApp when flavor is dice', () {
      expect(app_entry.rootAppForFlavor('dice'), isA<DiceCasterApp>());
    });

    test('returns ScrivenerApp when flavor is scrivener or null', () {
      expect(app_entry.rootAppForFlavor('scrivener'), isA<ScrivenerApp>());
      expect(app_entry.rootAppForFlavor(null), isA<ScrivenerApp>());
    });

    testWidgets('dice flavor renders standalone Dice Caster UI', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: app_entry.rootAppForFlavor('dice')),
      );
      await tester.pumpAndSettle();

      expect(find.text('DICE CASTER'), findsOneWidget);
      expect(find.text('SCRIVENER'), findsNothing);
    });
  });
}

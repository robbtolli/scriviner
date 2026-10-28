import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/theme/app_theme.dart';
import 'package:scrivener/features/combat/presentation/widgets/damage_heal_dialog.dart';

void main() {
  group('DamageHealDialog Theme & Contrast Tests', () {
    testWidgets('uses high-contrast onSurface color under Scholars Desk theme', (
      tester,
    ) async {
      final scholarsTheme = AppTheme.scholarsDeskTheme;

      int? damageAmount;
      int? healAmount;
      int? tempHpAmount;

      await tester.pumpWidget(
        MaterialApp(
          theme: scholarsTheme,
          home: Scaffold(
            body: DamageHealDialog(
              onDamage: (amount) => damageAmount = amount,
              onHeal: (amount) => healAmount = amount,
              onSetTempHp: (amount) => tempHpAmount = amount,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Title is present
      expect(find.text('Adjust Hit Points'), findsOneWidget);

      // Verify TextField text style is NOT Colors.white, but theme.colorScheme.onSurface
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.style?.color,
        equals(scholarsTheme.colorScheme.onSurface),
      );
      expect(
        textField.decoration?.hintStyle?.color,
        equals(scholarsTheme.colorScheme.onSurface.withValues(alpha: 0.5)),
      );

      // Enter damage and verify callback
      await tester.enterText(find.byType(TextField), '15');
      await tester.pumpAndSettle();

      await tester.tap(find.text('DAMAGE'));
      await tester.pumpAndSettle();

      expect(damageAmount, equals(15));
      expect(healAmount, isNull);
      expect(tempHpAmount, isNull);
    });

    testWidgets('uses light onSurface text under dark themes (Ancient Tome)', (
      tester,
    ) async {
      final tomeTheme = AppTheme.ancientTomeTheme;

      await tester.pumpWidget(
        MaterialApp(
          theme: tomeTheme,
          home: Scaffold(
            body: DamageHealDialog(
              onDamage: (_) {},
              onHeal: (_) {},
              onSetTempHp: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.style?.color, equals(tomeTheme.colorScheme.onSurface));
    });
  });
}

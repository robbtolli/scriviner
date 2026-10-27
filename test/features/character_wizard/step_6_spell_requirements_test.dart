import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/features/character_wizard/models/srd_starter_data.dart';
import 'package:scrivener/features/character_wizard/presentation/steps/step_6_equipment_spells.dart';
import 'package:scrivener/features/character_wizard/providers/wizard_provider.dart';

void main() {
  testWidgets(
    'Step 6 displays required cantrips and 1st-level spells at the top for Wizard',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set Wizard class on draft (needs 3 cantrips and 6 1st-level spells)
      final wizardClass = SrdStarterData.classes.firstWhere(
        (c) => c.id == 'wizard',
      );
      container.read(characterWizardProvider.notifier).setClass(wizardClass);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: Step6EquipmentSpells()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify top requirements banner
      expect(
        find.textContaining(
          'Wizard Spells Needed: Select 3 Cantrips and 6 1st-Level Spells',
        ),
        findsOneWidget,
      );

      // Verify requirement summary and tracker chips
      expect(
        find.text('Required for Wizard: 3 Cantrips and 6 1st-Level Spells'),
        findsOneWidget,
      );
      expect(find.text('Cantrips (Level 0): 0 / 3'), findsOneWidget);
      expect(find.text('1st-Level Spells: 0 / 6'), findsOneWidget);

      // Verify section subheaders
      expect(find.text('CANTRIPS (LEVEL 0)'), findsOneWidget);
      expect(find.text('1ST-LEVEL SPELLS'), findsOneWidget);

      // Select Fire Bolt (cantrip)
      final fireBoltFinder = find.text('Fire Bolt').first;
      await tester.ensureVisible(fireBoltFinder);
      await tester.tap(fireBoltFinder);
      await tester.pumpAndSettle();

      // Tracker should now show 1 / 3 for Cantrips
      expect(find.text('Cantrips (Level 0): 1 / 3'), findsOneWidget);

      // Select Magic Missile (1st-level)
      final magicMissileFinder = find.text('Magic Missile').first;
      await tester.ensureVisible(magicMissileFinder);
      await tester.tap(magicMissileFinder);
      await tester.pumpAndSettle();

      // Tracker should now show 1 / 6 for 1st-Level Spells
      expect(find.text('1st-Level Spells: 1 / 6'), findsOneWidget);
    },
  );

  testWidgets(
    'Step 6 renders cleanly on narrow 320px mobile viewport without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final clericClass = SrdStarterData.classes.firstWhere(
        (c) => c.id == 'cleric',
      );
      container.read(characterWizardProvider.notifier).setClass(clericClass);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(body: Step6EquipmentSpells()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Cleric Spells Needed: Select 3 Cantrips and 4 1st-Level Spells',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}

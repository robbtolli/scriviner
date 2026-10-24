import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/tabs/spells_tab.dart';
import 'package:scrivener/features/character_sheet/providers/character_sheet_provider.dart';
import 'package:scrivener/features/combat/providers/combat_session_provider.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedWizardCharacter() async {
    final now = DateTime.now();
    final props = {
      'class': 'Wizard',
      'race': 'High Elf',
      'level': 1,
      'abilities': {
        'int': {'score': 16, 'mod': 3},
        'dex': {'score': 14, 'mod': 2},
      },
      'hp': {'current': 8, 'max': 8, 'temp': 0},
      'spellSlots': {
        '1': {'total': 2, 'spent': 0},
      },
      'spells': [
        {
          'id': 'spell_fire_bolt',
          'name': 'Fire Bolt',
          'level': 0,
          'school': 'Evocation',
          'castingTime': '1 action',
          'range': '120 feet',
          'isPrepared': true,
        },
        {
          'id': 'spell_magic_missile',
          'name': 'Magic Missile',
          'level': 1,
          'school': 'Evocation',
          'castingTime': '1 action',
          'range': '120 feet',
          'isPrepared': true,
        },
      ],
    };

    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: 'char_wizard',
        name: 'Lyra Moonshadow',
        systemId: const Value('dnd5e'),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: jsonEncode(props),
      ),
    );
  }

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp(
        home: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(characterSheetProvider('char_wizard'));
            final notifier = ref.read(characterSheetProvider('char_wizard').notifier);

            if (state == null) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            return Scaffold(
              body: SpellsTab(state: state, notifier: notifier),
            );
          },
        ),
      ),
    );
  }

  testWidgets('renders spellcasting stats, cantrips, and leveled spells', (tester) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedWizardCharacter();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify Spell Save DC (8 + 2 prof + 3 INT = 13)
    expect(find.text('SPELL SAVE DC'), findsOneWidget);
    expect(find.text('13'), findsOneWidget);

    // Verify Spell Attack (+2 prof + 3 INT = +5)
    expect(find.text('SPELL ATTACK'), findsOneWidget);
    expect(find.text('+5'), findsOneWidget);

    // Verify Cantrip and Leveled Spells
    expect(find.text('Fire Bolt'), findsOneWidget);
    expect(find.text('Magic Missile'), findsOneWidget);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('casting a 1st level spell deducts a spell slot from combat provider', (tester) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedWizardCharacter();

    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(characterSheetProvider('char_wizard'));
              final notifier = ref.read(characterSheetProvider('char_wizard').notifier);
              ref.watch(combatSessionProvider('char_wizard'));

              if (state == null) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              return Scaffold(
                body: SpellsTab(state: state, notifier: notifier),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify 1st level slot in combat state starts with 0 spent
    var combatState = container.read(combatSessionProvider('char_wizard'));
    expect(combatState?.spellSlots['1']?.spent, equals(0));

    // Tap CAST on Magic Missile
    final castButtons = find.widgetWithText(ElevatedButton, 'CAST');
    expect(castButtons, findsNWidgets(2)); // One for Fire Bolt, one for Magic Missile
    await tester.tap(castButtons.at(1));
    await tester.pumpAndSettle();

    // Slot should now have 1 spent!
    combatState = container.read(combatSessionProvider('char_wizard'));
    expect(combatState?.spellSlots['1']?.spent, equals(1));

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

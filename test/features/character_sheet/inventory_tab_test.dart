import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/character_sheet/presentation/tabs/inventory_tab.dart';
import 'package:scrivener/features/character_sheet/providers/character_sheet_provider.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedFighterWithInventory() async {
    final now = DateTime.now();
    final props = {
      'class': 'Fighter',
      'race': 'Mountain Dwarf',
      'level': 1,
      'abilities': {
        'str': {'score': 16, 'mod': 3},
        'dex': {'score': 12, 'mod': 1},
      },
      'armorClass': 11,
      'currency': {
        'gp': 25,
        'sp': 10,
        'cp': 50,
      },
    };

    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: 'char_fighter_inv',
        name: 'Thorin Gear Test',
        systemId: const Value('dnd5e'),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: jsonEncode(props),
      ),
    );

    // Add Chain Mail
    await db.upsertInventoryItem(
      InventoryTableCompanion.insert(
        id: 'item_chain_mail',
        characterId: 'char_fighter_inv',
        name: 'Chain Mail',
        weight: const Value(55.0),
        quantity: const Value(1),
        isEquipped: const Value(false),
        itemDataJson: Value(
          jsonEncode({
            'isArmor': true,
            'category': 'Heavy Armor',
            'armorClass': 16,
          }),
        ),
      ),
    );

    // Add Shield
    await db.upsertInventoryItem(
      InventoryTableCompanion.insert(
        id: 'item_shield',
        characterId: 'char_fighter_inv',
        name: 'Shield',
        weight: const Value(6.0),
        quantity: const Value(1),
        isEquipped: const Value(false),
        itemDataJson: Value(
          jsonEncode({
            'isShield': true,
            'armorClass': 2,
          }),
        ),
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
            final state = ref.watch(characterSheetProvider('char_fighter_inv'));
            final notifier = ref.read(characterSheetProvider('char_fighter_inv').notifier);

            if (state == null) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            return Scaffold(
              body: InventoryTab(state: state, notifier: notifier),
            );
          },
        ),
      ),
    );
  }

  testWidgets('renders currency, carried weight, and equipment items', (tester) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedFighterWithInventory();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify Currency Display
    expect(find.text('CURRENCY WALLET'), findsOneWidget);
    expect(find.text('25'), findsOneWidget); // 25 GP
    expect(find.text('GP'), findsOneWidget);

    // Verify Carried Weight: 55 + 6 = 61.0 lbs / 240.0 lbs capacity
    expect(find.text('61.0 / 240.0 lbs'), findsOneWidget);

    // Verify Inventory Items
    expect(find.text('Chain Mail'), findsOneWidget);
    expect(find.text('Shield'), findsOneWidget);

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('equipping armor and shield dynamically recalculates character AC', (tester) async {
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await seedFighterWithInventory();

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
              final state = ref.watch(characterSheetProvider('char_fighter_inv'));
              final notifier = ref.read(characterSheetProvider('char_fighter_inv').notifier);

              if (state == null) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }

              return Scaffold(
                body: InventoryTab(state: state, notifier: notifier),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Initially AC is 11 (10 + 1 DEX)
    var state = container.read(characterSheetProvider('char_fighter_inv'));
    expect(state?.armorClass, equals(11));

    // Tap Checkbox for Chain Mail (the first Checkbox)
    final checkboxes = find.byType(Checkbox);
    expect(checkboxes, findsNWidgets(2));
    await tester.tap(checkboxes.first);
    await tester.pumpAndSettle();

    // Equipping Chain Mail sets AC to 16
    state = container.read(characterSheetProvider('char_fighter_inv'));
    expect(state?.armorClass, equals(16));

    // Tap Checkbox for Shield (the second Checkbox)
    await tester.tap(checkboxes.last);
    await tester.pumpAndSettle();

    // Equipping Shield adds +2 -> AC becomes 18!
    state = container.read(characterSheetProvider('char_fighter_inv'));
    expect(state?.armorClass, equals(18));

    // Clean teardown
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}

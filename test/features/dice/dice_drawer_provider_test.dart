import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/features/dice/models/dice_roll_record.dart';
import 'package:scrivener/features/dice/providers/dice_drawer_provider.dart';

void main() {
  group('DiceDrawerProvider & State', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state defaults to 1d20 and normal roll', () {
      final state = container.read(diceDrawerProvider);
      expect(state.contextTitle, equals('Quick Roll'));
      expect(state.diceCounts, equals({20: 1}));
      expect(state.flatModifier, equals(0));
      expect(state.rollType, equals(RollType.normal));
      expect(state.formula, equals('1d20'));
      expect(state.history, isEmpty);
    });

    test('adding and removing polyhedral dice updates formula dynamically', () {
      final notifier = container.read(diceDrawerProvider.notifier);

      // Add 2d6 and 1d8
      notifier.addDie(6);
      notifier.addDie(6);
      notifier.addDie(8);

      var state = container.read(diceDrawerProvider);
      // Sorted highest to lowest: 1d20 + 1d8 + 2d6
      expect(state.formula, equals('1d20 + 1d8 + 2d6'));

      // Remove one d6
      notifier.removeDie(6);
      state = container.read(diceDrawerProvider);
      expect(state.formula, equals('1d20 + 1d8 + 1d6'));

      // Adjust flat modifier +4
      notifier.setFlatModifier(4);
      state = container.read(diceDrawerProvider);
      expect(state.formula, equals('1d20 + 1d8 + 1d6 + 4'));
    });

    test('advantage and disadvantage convert 1d20 to 2d20kh1 and 2d20kl1', () {
      final notifier = container.read(diceDrawerProvider.notifier);

      // Switch to Advantage
      notifier.setRollType(RollType.advantage);
      var state = container.read(diceDrawerProvider);
      expect(state.formula, equals('2d20kh1'));

      // Switch to Disadvantage
      notifier.setRollType(RollType.disadvantage);
      state = container.read(diceDrawerProvider);
      expect(state.formula, equals('2d20kl1'));

      // Return to Normal
      notifier.setRollType(RollType.normal);
      state = container.read(diceDrawerProvider);
      expect(state.formula, equals('1d20'));
    });

    test('situational bonuses append dice and flat values', () {
      final notifier = container.read(diceDrawerProvider.notifier);

      // Toggle Bless (+1d4)
      notifier.toggleSituationalBonus('bless');
      var state = container.read(diceDrawerProvider);
      expect(state.formula, equals('1d20 + 1d4'));

      // Toggle Cover (+2 Flat)
      notifier.toggleSituationalBonus('cover2');
      state = container.read(diceDrawerProvider);
      expect(state.formula, equals('1d20 + 1d4 + 2'));

      // Toggle off Bless
      notifier.toggleSituationalBonus('bless');
      state = container.read(diceDrawerProvider);
      expect(state.formula, equals('1d20 + 2'));
    });

    test('setContext preloads action parameters', () {
      final notifier = container.read(diceDrawerProvider.notifier);

      notifier.setContext(
        title: 'Thorin: Battleaxe Attack',
        diceCounts: {20: 1},
        flatModifier: 5,
        rollType: RollType.advantage,
      );

      final state = container.read(diceDrawerProvider);
      expect(state.contextTitle, equals('Thorin: Battleaxe Attack'));
      expect(state.formula, equals('2d20kh1 + 5'));
      expect(state.rollType, equals(RollType.advantage));
    });

    test('roll() executes formula, prepends to history, and calculates breakdown', () {
      final notifier = container.read(diceDrawerProvider.notifier);

      notifier.setContext(
        title: 'Test Roll',
        diceCounts: {6: 2},
        flatModifier: 3,
      );

      final record = notifier.roll();

      expect(record.context, equals('Test Roll'));
      expect(record.formula, equals('2d6 + 3'));
      // Total must be between 2*1+3 = 5 and 2*6+3 = 15
      expect(record.total, greaterThanOrEqualTo(5));
      expect(record.total, lessThanOrEqualTo(15));
      expect(record.formattedBreakdown, contains('= ${record.total}'));

      final state = container.read(diceDrawerProvider);
      expect(state.history.length, equals(1));
      expect(state.history.first.id, equals(record.id));
    });

    test('clearHistory() empties log', () {
      final notifier = container.read(diceDrawerProvider.notifier);
      notifier.roll();
      notifier.roll();

      expect(container.read(diceDrawerProvider).history.length, equals(2));

      notifier.clearHistory();
      expect(container.read(diceDrawerProvider).history, isEmpty);
    });
  });
}

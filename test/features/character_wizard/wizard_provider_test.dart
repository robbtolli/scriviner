import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/features/character_wizard/models/srd_starter_data.dart';
import 'package:scrivener/features/character_wizard/models/wizard_draft.dart';
import 'package:scrivener/features/character_wizard/providers/wizard_provider.dart';

void main() {
  group('CharacterWizardNotifier & WizardDraft', () {
    late ProviderContainer container;
    late CharacterWizardNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(characterWizardProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    WizardDraft getDraft() => container.read(characterWizardProvider);

    test('auto-assigns standard array optimally based on class', () {
      final fighter = SrdStarterData.classes.firstWhere((c) => c.id == 'fighter');
      notifier.setClass(fighter);

      expect(getDraft().baseAbilities['STR'], equals(15));
      expect(getDraft().baseAbilities['CON'], equals(14));
      expect(getDraft().baseAbilities['INT'], equals(8));

      final wizard = SrdStarterData.classes.firstWhere((c) => c.id == 'wizard');
      notifier.setClass(wizard);

      expect(getDraft().baseAbilities['INT'], equals(15));
      expect(getDraft().baseAbilities['CON'], equals(14));
      expect(getDraft().baseAbilities['STR'], equals(8));
    });

    test('calculates point buy remaining points correctly', () {
      notifier.setAbilityMethod(AbilityGenMethod.pointBuy);
      // Base point buy starts with all 8s (cost 0, 27 remaining)
      expect(getDraft().remainingPointBuyPoints, equals(27));

      // Increase STR to 15 (costs 9 points -> 18 remaining)
      notifier.setAbilityScore('STR', 15);
      expect(getDraft().remainingPointBuyPoints, equals(18));

      // Increase DEX to 14 (costs 7 points -> 11 remaining)
      notifier.setAbilityScore('DEX', 14);
      expect(getDraft().remainingPointBuyPoints, equals(11));
    });

    test('validates required fields on each step', () {
      // Step 0: Name is required
      var (isValid, error) = getDraft().validateStep(0);
      expect(isValid, isFalse);
      expect(error, contains('name'));

      notifier.setName('Aragorn');
      (isValid, _) = getDraft().validateStep(0);
      expect(isValid, isTrue);

      // Step 1: Race is required
      (isValid, error) = getDraft().validateStep(1);
      expect(isValid, isFalse);
      expect(error, contains('race'));

      notifier.setRace(SrdStarterData.races.firstWhere((r) => r.id == 'human'));
      (isValid, _) = getDraft().validateStep(1);
      expect(isValid, isTrue);

      // Step 2: Class is required
      (isValid, error) = getDraft().validateStep(2);
      expect(isValid, isFalse);
      expect(error, contains('class'));

      notifier.setClass(SrdStarterData.classes.firstWhere((c) => c.id == 'fighter'));
      (isValid, _) = getDraft().validateStep(2);
      expect(isValid, isTrue);
    });

    test('computes dynamic HP, AC, and saving to Drift database', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(() => db.close());

      notifier.setName('Gimli');
      notifier.setRace(SrdStarterData.races.firstWhere((r) => r.id == 'dwarf')); // +2 CON
      notifier.setClass(SrdStarterData.classes.firstWhere((c) => c.id == 'fighter')); // d10 hit die
      // Fighter auto-assigns CON 14. Dwarf adds +2 CON -> CON is 16 (+3 mod).
      // Max HP = Hit die (10) + CON mod (3) = 13 HP!
      expect(getDraft().finalAbilities['CON'], equals(16));
      expect(getDraft().abilityModifiers['CON'], equals(3));
      expect(getDraft().maxHp, equals(13));

      notifier.setBackground(SrdStarterData.backgrounds.firstWhere((b) => b.id == 'soldier'));
      notifier.toggleSkill('Athletics');
      notifier.toggleSkill('Perception');

      // Save character
      final charId = await notifier.saveCharacter(db);
      expect(charId, isNotEmpty);

      // Verify character in database
      final saved = await db.getCharacter(charId);
      expect(saved, isNotNull);
      expect(saved!.name, equals('Gimli'));
      expect(saved.systemId, equals('dnd5e'));
    });
  });
}

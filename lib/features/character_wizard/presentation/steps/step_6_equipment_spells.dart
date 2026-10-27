import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/srd_starter_data.dart';
import '../../providers/wizard_provider.dart';

class Step6EquipmentSpells extends ConsumerWidget {
  const Step6EquipmentSpells({super.key});

  static const List<String> _equipmentPackages = [
    'Standard Adventurer Package (Armor, Main Weapon, Shield, Backpack, Rations)',
    'Mobile Skirmisher Kit (Leather Armor, Shortbow, 20 Arrows, Daggers, Thieves Tools)',
    'Scholar Arcane Focus Kit (Spellbook, Arcane Focus, Component Pouch, Robes, Ink)',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(characterWizardProvider);
    final notifier = ref.read(characterWizardProvider.notifier);

    final isSpellcaster = draft.charClass?.isSpellcaster ?? false;
    final requiredCantrips = draft.charClass?.cantripsKnown ?? 0;
    final requiredFirstLevel = draft.charClass?.firstLevelSpellsKnown ?? 0;

    // Filter spells for this class
    final classSpells = SrdStarterData.spells.where((spell) {
      return spell.classes.contains(draft.charClass?.id);
    }).toList();

    final cantripSpells = classSpells.where((s) => s.level == 0).toList();
    final firstLevelSpells = classSpells.where((s) => s.level == 1).toList();

    final selectedCantrips = cantripSpells
        .where((s) => draft.selectedSpells.contains(s.id))
        .length;
    final selectedFirstLevel = firstLevelSpells
        .where((s) => draft.selectedSpells.contains(s.id))
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 6: Equipment & Magic',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Equip your hero with starting weapons and prepare your magical repertoire.',
            style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 14),
          ),
          if (isSpellcaster) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryGold.withAlpha(100)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppTheme.primaryGold,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${draft.charClass?.name ?? "Spellcaster"} Spells Needed: Select $requiredCantrips Cantrip${requiredCantrips == 1 ? "" : "s"} and $requiredFirstLevel 1st-Level Spell${requiredFirstLevel == 1 ? "" : "s"}.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Text(
            'STARTING EQUIPMENT PACKAGE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 10),
          ..._equipmentPackages.map((package) {
            final isSelected = draft.equipmentPackage == package;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => notifier.setEquipmentPackage(package),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryGold.withAlpha(25)
                        : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGold
                          : Colors.white.withAlpha(20),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? AppTheme.primaryGold
                            : Colors.white.withAlpha(120),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          package,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withAlpha(190),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (isSpellcaster) ...[
            const SizedBox(height: 28),
            // Spell Selection Requirements Section
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'SPELL SELECTION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                ),
                Text(
                  'Total: ${draft.selectedSpells.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Required for ${draft.charClass?.name ?? "Class"}: $requiredCantrips Cantrips and $requiredFirstLevel 1st-Level Spells',
              style: TextStyle(
                color: Colors.white.withAlpha(190),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            // Status tracker cards
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildTrackerChip(
                  icon: Icons.auto_awesome,
                  label: 'Cantrips (Level 0)',
                  current: selectedCantrips,
                  required: requiredCantrips,
                ),
                _buildTrackerChip(
                  icon: Icons.menu_book,
                  label: '1st-Level Spells',
                  current: selectedFirstLevel,
                  required: requiredFirstLevel,
                ),
              ],
            ),
            // Cantrips Section
            if (cantripSpells.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'CANTRIPS (LEVEL 0)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ),
                  Text(
                    '$selectedCantrips / $requiredCantrips selected',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: selectedCantrips == requiredCantrips
                          ? Colors.greenAccent
                          : Colors.cyanAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...cantripSpells.map(
                (spell) => _buildSpellCard(spell, draft, notifier),
              ),
            ],
            // 1st-Level Spells Section
            if (firstLevelSpells.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '1ST-LEVEL SPELLS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                  Text(
                    '$selectedFirstLevel / $requiredFirstLevel selected',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: selectedFirstLevel == requiredFirstLevel
                          ? Colors.greenAccent
                          : AppTheme.primaryGold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...firstLevelSpells.map(
                (spell) => _buildSpellCard(spell, draft, notifier),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTrackerChip({
    required IconData icon,
    required String label,
    required int current,
    required int required,
  }) {
    final isComplete = current == required;
    final isOver = current > required;

    final color = isComplete
        ? Colors.greenAccent
        : isOver
        ? Colors.orangeAccent
        : AppTheme.primaryGold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(120)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isComplete ? Icons.check_circle : icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '$label: $current / $required',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpellCard(
    SpellDefinition spell,
    dynamic draft,
    dynamic notifier,
  ) {
    final isSelected = draft.selectedSpells.contains(spell.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => notifier.toggleSpell(spell.id),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryGold.withAlpha(25)
                : AppTheme.cardDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryGold
                  : Colors.white.withAlpha(20),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) => notifier.toggleSpell(spell.id),
                activeColor: AppTheme.primaryGold,
                checkColor: Colors.black,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            spell.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isSelected
                                  ? AppTheme.primaryGold
                                  : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            spell.level == 0 ? 'Cantrip' : 'Level 1',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${spell.school} • ${spell.castingTime} • ${spell.range}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withAlpha(140),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      spell.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

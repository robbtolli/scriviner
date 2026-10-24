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

    // Filter spells for this class
    final classSpells = SrdStarterData.spells.where((spell) {
      return spell.classes.contains(draft.charClass?.id);
    }).toList();

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
                    color: isSelected ? AppTheme.primaryGold.withAlpha(25) : AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(20),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(120),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          package,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.white : Colors.white.withAlpha(190),
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
            Row(
              children: [
                const Text(
                  'SPELL SELECTION',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: AppTheme.primaryGold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Selected: ${draft.selectedSpells.length}',
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
              'Cantrips can be cast at-will. 1st-level spells expend daily spell slots.',
              style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...classSpells.map((spell) {
              final isSelected = draft.selectedSpells.contains(spell.id);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => notifier.toggleSpell(spell.id),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryGold.withAlpha(25) : AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(20),
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
                                  Text(
                                    spell.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isSelected ? AppTheme.primaryGold : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceDark,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      spell.level == 0 ? 'Cantrip' : 'Level 1',
                                      style: const TextStyle(fontSize: 10, color: Colors.cyanAccent),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${spell.school} • ${spell.castingTime} • ${spell.range}',
                                style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(140)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                spell.description,
                                style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(180)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

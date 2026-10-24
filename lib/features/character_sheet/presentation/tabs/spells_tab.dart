import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../compendium/presentation/compendium_search_dialog.dart';
import '../../models/character_sheet_data.dart';
import '../../providers/character_sheet_provider.dart';

class SpellsTab extends StatelessWidget {
  final CharacterSheetState state;
  final CharacterSheetNotifier notifier;

  const SpellsTab({
    super.key,
    required this.state,
    required this.notifier,
  });

  void _openAddSpellDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => CompendiumSearchDialog(
        initialCategory: 'spell',
        onAddEntry: (entry) {
          final spell = CharacterSpellItem(
            id: 'spell_${entry.name.toLowerCase().replaceAll(' ', '_')}',
            name: entry.name,
            level: entry.spellLevel,
            school: entry.school,
            castingTime: entry.castingTime,
            range: entry.range,
            components: entry.components,
            duration: entry.duration,
            isRitual: entry.isRitual,
            description: entry.description,
            isPrepared: true,
          );
          notifier.addSpell(spell);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group spells by level (0 = Cantrips, 1 = 1st Level, etc.)
    final groupedSpells = <int, List<CharacterSpellItem>>{};
    for (final s in state.spells) {
      groupedSpells.putIfAbsent(s.level, () => []).add(s);
    }
    final sortedLevels = groupedSpells.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Spellcasting Stats Header
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF4A4037)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  'SPELL SAVE DC',
                  '${state.spellSaveDc}',
                  '8 + Prof + ${state.spellcastingAbility.toUpperCase()}',
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFF4A4037)),
              Expanded(
                child: _buildStatTile(
                  'SPELL ATTACK',
                  '+${state.spellAttackBonus}',
                  'Prof + ${state.spellcastingAbility.toUpperCase()}',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Action bar: + Add Spell
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'KNOWN & PREPARED SPELLS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppTheme.primaryGold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _openAddSpellDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('ADD SPELL'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (state.spells.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.auto_fix_high, size: 48, color: Colors.white.withAlpha(50)),
                  const SizedBox(height: 12),
                  const Text(
                    'No spells in spellbook yet',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _openAddSpellDialog(context),
                    icon: const Icon(Icons.search, size: 16),
                    label: const Text('Browse SRD Spells'),
                  ),
                ],
              ),
            ),
          )
        else
          ...sortedLevels.map((lvl) {
            final spellsAtLevel = groupedSpells[lvl]!;
            final levelTitle = lvl == 0 ? 'Cantrips (At-Will)' : 'Level $lvl Spells';

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: AppTheme.cardDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF4A4037)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: const BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Text(
                      levelTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                  ...spellsAtLevel.map((spell) => _buildSpellTile(context, spell)),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, String subtitle) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGold,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withAlpha(120),
          ),
        ),
      ],
    );
  }

  Widget _buildSpellTile(BuildContext context, CharacterSpellItem spell) {
    return ExpansionTile(
      leading: spell.level > 0
          ? IconButton(
              icon: Icon(
                spell.isPrepared ? Icons.star : Icons.star_border,
                color: spell.isPrepared ? AppTheme.primaryGold : Colors.grey,
                size: 22,
              ),
              tooltip: spell.isPrepared ? 'Prepared' : 'Unprepared',
              onPressed: () => notifier.toggleSpellPreparation(spell.id),
            )
          : const Icon(Icons.bolt, color: AppTheme.primaryGold, size: 22),
      title: Row(
        children: [
          Expanded(
            child: Text(
              spell.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: (spell.level == 0 || spell.isPrepared)
                    ? Colors.white
                    : Colors.white.withAlpha(120),
              ),
            ),
          ),
          if (spell.isRitual)
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.purple.withAlpha(40),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('R', style: TextStyle(fontSize: 10, color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      subtitle: Text(
        '${spell.school} • ${spell.castingTime} • ${spell.range}',
        style: TextStyle(fontSize: 11, color: Colors.white.withAlpha(140)),
      ),
      trailing: ElevatedButton(
        onPressed: () => notifier.castSpell(spell, context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          visualDensity: VisualDensity.compact,
        ),
        child: const Text('CAST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Components: ${spell.components} • Duration: ${spell.duration}',
                style: const TextStyle(fontSize: 11, color: AppTheme.primaryGold),
              ),
              const SizedBox(height: 4),
              Text(
                spell.description,
                style: TextStyle(fontSize: 12, height: 1.3, color: Colors.white.withAlpha(180)),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => notifier.removeSpell(spell.id),
                  icon: const Icon(Icons.delete_outline, size: 14, color: Colors.redAccent),
                  label: const Text('Remove from book', style: TextStyle(color: Colors.redAccent, fontSize: 11)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

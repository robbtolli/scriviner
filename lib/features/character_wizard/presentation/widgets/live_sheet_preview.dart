import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/wizard_draft.dart';

class LiveSheetPreview extends StatelessWidget {
  final WizardDraft draft;

  const LiveSheetPreview({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    final raceName = draft.race?.name ?? 'Race';
    final className = draft.charClass?.name ?? 'Class';
    final name = draft.name.trim().isNotEmpty
        ? draft.name.trim()
        : 'Nameless Hero';

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primaryGold.withAlpha(140),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.surfaceDark,
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Level 1 $raceName $className',
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
          const Divider(height: 20, color: Color(0xFF4A4037)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric(
                'HP',
                '${draft.maxHp}',
                Icons.favorite,
                Colors.redAccent,
              ),
              _buildMetric(
                'AC',
                '${draft.armorClass}',
                Icons.shield,
                Colors.blueAccent,
              ),
              _buildMetric(
                'SPD',
                '${draft.speed}ft',
                Icons.directions_run,
                Colors.greenAccent,
              ),
              _buildMetric(
                'PERC',
                '${draft.passivePerception}',
                Icons.visibility,
                Colors.amberAccent,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'ABILITY SCORES & MODIFIERS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          _buildAbilityGrid(),
          if (draft.allProficientSkills.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'PROFICIENT SKILLS (${draft.allProficientSkills.length})',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: AppTheme.primaryGold,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: draft.allProficientSkills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white.withAlpha(20)),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withAlpha(160),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAbilityGrid() {
    final stats = ['STR', 'DEX', 'CON', 'INT', 'WIS', 'CHA'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stats.map((stat) {
        final score = draft.finalAbilities[stat] ?? 10;
        final mod = draft.abilityModifiers[stat] ?? 0;
        final modStr = mod >= 0 ? '+$mod' : '$mod';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withAlpha(25)),
          ),
          child: Column(
            children: [
              Text(
                stat,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                modStr,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

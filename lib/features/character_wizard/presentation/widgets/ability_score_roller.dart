import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AbilityScoreRoller extends StatelessWidget {
  final List<int> rolledScores;
  final VoidCallback onRoll;

  const AbilityScoreRoller({
    super.key,
    required this.rolledScores,
    required this.onRoll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGold.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.casino, color: AppTheme.primaryGold, size: 22),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Roll 4d6 Drop Lowest',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onRoll,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('ROLL STATS'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Rolls 4 six-sided dice, discards the lowest die, and sums the remaining 3 for each score.',
            style: TextStyle(fontSize: 13, color: Colors.white.withAlpha(180)),
          ),
          const SizedBox(height: 16),
          if (rolledScores.isNotEmpty) ...[
            const Text(
              'ROLLED POOL (Sorted High to Low):',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: rolledScores.map((score) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primaryGold, width: 1.5),
                  ),
                  child: Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/dice_roll_record.dart';

class RollHistoryList extends StatelessWidget {
  final List<DiceRollRecord> history;
  final void Function(DiceRollRecord record) onReroll;
  final VoidCallback onClearHistory;

  const RollHistoryList({
    super.key,
    required this.history,
    required this.onReroll,
    required this.onClearHistory,
  });

  String _formatTime(DateTime dt) {
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute:$second $ampm';
  }

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Icon(Icons.history, size: 36, color: Colors.white.withAlpha(60)),
              const SizedBox(height: 8),
              Text(
                'No rolls yet this session',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withAlpha(120),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.history, color: AppTheme.primaryGold, size: 16),
                const SizedBox(width: 6),
                Text(
                  'RECENT ROLLS (${history.length})',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: AppTheme.primaryGold,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: onClearHistory,
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('Clear', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...history.map((record) => _buildRollCard(context, record)),
      ],
    );
  }

  Widget _buildRollCard(BuildContext context, DiceRollRecord record) {
    final cardBorderColor = record.isCriticalHit
        ? AppTheme.accentEmerald
        : record.isCriticalMiss
            ? Colors.redAccent
            : const Color(0xFF4A4037);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: cardBorderColor,
          width: (record.isCriticalHit || record.isCriticalMiss) ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner for Crit Hit / Miss
          if (record.isCriticalHit) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.accentEmerald.withAlpha(40),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '🎯 NATURAL 20 / CRITICAL HIT!',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ] else if (record.isCriticalMiss) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.redAccent.withAlpha(40),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '💀 NATURAL 1 / CRITICAL MISS',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  record.context,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                _formatTime(record.timestamp),
                style: TextStyle(fontSize: 10, color: Colors.white.withAlpha(120)),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Total and Formula
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${record.total}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: record.isCriticalHit
                      ? Colors.greenAccent
                      : record.isCriticalMiss
                          ? Colors.redAccent
                          : AppTheme.primaryGold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.formula,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withAlpha(160),
                      ),
                    ),
                    Text(
                      record.formattedBreakdown,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                tooltip: 'Re-roll this formula',
                color: AppTheme.primaryGold,
                visualDensity: VisualDensity.compact,
                onPressed: () => onReroll(record),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

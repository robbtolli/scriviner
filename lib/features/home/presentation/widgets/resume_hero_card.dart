import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';

class ResumeHeroCard extends StatelessWidget {
  final CharactersTableData character;
  final VoidCallback onResume;

  const ResumeHeroCard({
    super.key,
    required this.character,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> props = {};
    try {
      props = jsonDecode(character.rawPropertiesJson) as Map<String, dynamic>;
    } catch (_) {}

    final className = props['class'] ?? 'Adventurer';
    final race = props['race'] ?? 'Hero';
    final level = props['level'] ?? 1;

    final hpMap = props['hp'] as Map<String, dynamic>? ?? {};
    final currentHp = hpMap['current'] ?? 10;
    final maxHp = hpMap['max'] ?? 10;
    final ac = props['armorClass'] ?? 10;

    final timeAgo = _formatRelativeTime(character.lastPlayedAt);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF382D20), Color(0xFF261F17)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onResume,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flash_on, color: AppTheme.primaryGold, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'RESUME SESSION',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppTheme.primaryGold,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.white.withAlpha(160),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.cardDark,
                      child: Text(
                        character.name.isNotEmpty
                            ? character.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            character.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Level $level $race $className • ${character.systemId.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withAlpha(200),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatPill('HP', '$currentHp / $maxHp', Icons.favorite, Colors.redAccent),
                    const SizedBox(width: 10),
                    _buildStatPill('AC', '$ac', Icons.shield, Colors.blueAccent),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: onResume,
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text('CONTINUE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withAlpha(180),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
}

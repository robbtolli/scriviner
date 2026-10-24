import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_theme.dart';

class CharacterCard extends StatelessWidget {
  final CharactersTableData character;
  final VoidCallback onTap;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback? onExport;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
    required this.onDuplicate,
    required this.onDelete,
    this.onExport,
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

    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.surfaceDark,
                    child: Text(
                      character.name.isNotEmpty
                          ? character.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Level $level $race $className',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withAlpha(180),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.white.withAlpha(160)),
                    color: AppTheme.surfaceDark,
                    onSelected: (value) {
                      if (value == 'open') onTap();
                      if (value == 'duplicate') onDuplicate();
                      if (value == 'export') onExport?.call();
                      if (value == 'delete') _showDeleteDialog(context);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'open',
                        child: Row(
                          children: [
                            Icon(Icons.open_in_new, size: 18),
                            SizedBox(width: 8),
                            Text('Open'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 18),
                            SizedBox(width: 8),
                            Text('Duplicate'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'export',
                        child: Row(
                          children: [
                            Icon(Icons.file_download_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Export (JSON)'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.primaryGold.withAlpha(100)),
                    ),
                    child: Text(
                      character.systemId.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildStatBadge(Icons.favorite, '$currentHp/$maxHp', Colors.redAccent),
                  const SizedBox(width: 8),
                  _buildStatBadge(Icons.shield, '$ac', Colors.blueAccent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(80),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Character?'),
        content: Text('Are you sure you want to delete ${character.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

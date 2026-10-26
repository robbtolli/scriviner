import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/theme/models/scrivener_theme_tokens.dart';

class CharacterCard extends StatelessWidget {
  final CharactersTableData character;
  final VoidCallback onTap;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback? onExport;
  final VoidCallback? onPrintPdf;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
    required this.onDuplicate,
    required this.onDelete,
    this.onExport,
    this.onPrintPdf,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;

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
      elevation: tokens.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        side: tokens.cardBorder,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.cardRadius),
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
                    backgroundColor: theme.colorScheme.surface,
                    child: Text(
                      character.name.isNotEmpty
                          ? character.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Level $level $race $className',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface.withAlpha(180),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.colorScheme.onSurface.withAlpha(160),
                    ),
                    color: theme.colorScheme.surface,
                    onSelected: (value) {
                      if (value == 'open') onTap();
                      if (value == 'duplicate') onDuplicate();
                      if (value == 'export') onExport?.call();
                      if (value == 'print_pdf') onPrintPdf?.call();
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
                        value: 'print_pdf',
                        child: Row(
                          children: [
                            Icon(Icons.print_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Print / PDF Sheet'),
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
                            Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: TextStyle(color: Colors.redAccent),
                            ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: theme.colorScheme.primary.withAlpha(100),
                      ),
                    ),
                    child: Text(
                      character.systemId.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildStatBadge(
                    context,
                    Icons.favorite,
                    '$currentHp/$maxHp',
                    Colors.redAccent,
                  ),
                  const SizedBox(width: 8),
                  _buildStatBadge(
                    context,
                    tokens.iconography.tabCombat,
                    '$ac',
                    theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(
    BuildContext context,
    IconData icon,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(180),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.dividerColor.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
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
        content: Text(
          'Are you sure you want to delete ${character.name}? This action cannot be undone.',
        ),
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

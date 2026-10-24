import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../services/character_export_service.dart';

/// Modal dialog showing the character's exported JSON payload with 1-tap clipboard copy.
class ExportCharacterDialog extends ConsumerStatefulWidget {
  final String characterId;
  final String characterName;

  const ExportCharacterDialog({
    super.key,
    required this.characterId,
    required this.characterName,
  });

  static Future<void> show(
    BuildContext context, {
    required String characterId,
    required String characterName,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ExportCharacterDialog(
        characterId: characterId,
        characterName: characterName,
      ),
    );
  }

  @override
  ConsumerState<ExportCharacterDialog> createState() => _ExportCharacterDialogState();
}

class _ExportCharacterDialogState extends ConsumerState<ExportCharacterDialog> {
  final CharacterExportService _service = CharacterExportService();
  String? _jsonPayload;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExport();
  }

  Future<void> _loadExport() async {
    try {
      final db = ref.read(databaseProvider);
      final json = await _service.exportCharacterToJson(db, widget.characterId);
      if (mounted) {
        setState(() {
          _jsonPayload = json;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _copyToClipboard() {
    if (_jsonPayload == null) return;
    Clipboard.setData(ClipboardData(text: _jsonPayload!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Backup JSON for "${widget.characterName}" copied to clipboard!'),
        backgroundColor: Colors.green.shade800,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.file_download_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'EXPORT: ${widget.characterName.toUpperCase()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: SizedBox(
        width: 520,
        height: 380,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(
                      'Failed to export character: $_errorMessage',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portable character backup including stats, conditions, spells, and equipment.',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withAlpha(160)),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.dividerColor.withAlpha(80)),
                          ),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              _jsonPayload ?? '',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
      actions: [
        if (_jsonPayload != null)
          ElevatedButton.icon(
            onPressed: _copyToClipboard,
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('COPY TO CLIPBOARD'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE'),
        ),
      ],
    );
  }
}

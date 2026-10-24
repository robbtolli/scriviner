import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../services/character_export_service.dart';

/// Modal dialog allowing the user to paste and restore a character JSON backup.
class ImportCharacterDialog extends ConsumerStatefulWidget {
  final void Function(String newCharacterId)? onCharacterImported;

  const ImportCharacterDialog({
    super.key,
    this.onCharacterImported,
  });

  static Future<void> show(
    BuildContext context, {
    void Function(String newCharacterId)? onCharacterImported,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ImportCharacterDialog(
        onCharacterImported: onCharacterImported,
      ),
    );
  }

  @override
  ConsumerState<ImportCharacterDialog> createState() => _ImportCharacterDialogState();
}

class _ImportCharacterDialogState extends ConsumerState<ImportCharacterDialog> {
  final TextEditingController _controller = TextEditingController();
  final CharacterExportService _service = CharacterExportService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      setState(() {
        _controller.text = data!.text!;
        _errorMessage = null;
      });
    }
  }

  Future<void> _importCharacter() async {
    final rawText = _controller.text.trim();
    if (rawText.isEmpty) {
      setState(() {
        _errorMessage = 'Please paste a valid character backup JSON string';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final db = ref.read(databaseProvider);
      final newCharId = await _service.importCharacterFromJson(db, rawText);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Character imported successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        widget.onCharacterImported?.call(newCharId);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Import failed: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.file_upload_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'IMPORT HERO (JSON)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: SizedBox(
        width: 520,
        height: 380,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paste a Scrivener character backup JSON payload to restore it.',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withAlpha(160)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: 14,
                decoration: InputDecoration(
                  hintText: '{\n  "format": "scrivener-character-backup",\n  "character": {\n    "name": "Thorin", ...\n  }\n}',
                  hintStyle: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  errorText: _errorMessage,
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: _pasteFromClipboard,
          icon: const Icon(Icons.paste, size: 16),
          label: const Text('PASTE'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _importCharacter,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('IMPORT HERO'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}

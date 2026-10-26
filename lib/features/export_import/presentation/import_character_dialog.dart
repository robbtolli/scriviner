import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../services/character_export_service.dart';

/// Modal dialog allowing the user to pick a character backup file (.json or .txt)
/// using a system file picker, or optionally paste character JSON directly.
class ImportCharacterDialog extends ConsumerStatefulWidget {
  final void Function(String newCharacterId)? onCharacterImported;

  const ImportCharacterDialog({super.key, this.onCharacterImported});

  static Future<void> show(
    BuildContext context, {
    void Function(String newCharacterId)? onCharacterImported,
  }) {
    return showDialog(
      context: context,
      builder: (context) =>
          ImportCharacterDialog(onCharacterImported: onCharacterImported),
    );
  }

  @override
  ConsumerState<ImportCharacterDialog> createState() =>
      _ImportCharacterDialogState();
}

class _ImportCharacterDialogState extends ConsumerState<ImportCharacterDialog> {
  final TextEditingController _controller = TextEditingController();
  final CharacterExportService _service = CharacterExportService();

  bool _isLoading = false;
  bool _isPicking = false;
  String? _errorMessage;

  String? _selectedFileName;
  int? _selectedFileSize;
  String? _previewHeroName;
  String? _previewHeroDetails;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      _updatePreview(_controller.text);
    }
  }

  void _updatePreview(String content) {
    if (content.trim().isEmpty) {
      setState(() {
        _previewHeroName = null;
        _previewHeroDetails = null;
      });
      return;
    }

    try {
      String cleaned = content.trim();
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.substring(7);
      } else if (cleaned.startsWith('```')) {
        cleaned = cleaned.substring(3);
      }
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3);
      }
      final decoded = jsonDecode(cleaned.trim());
      if (decoded is Map<String, dynamic>) {
        final charData = decoded['character'];
        if (charData is Map<String, dynamic>) {
          // Standard Scrivener format
          if (charData['name'] != null) {
            final name = charData['name'] as String;
            final rawProps = charData['rawProperties'];
            String details = 'Character Backup';
            if (rawProps is Map) {
              final cls = rawProps['class'] ?? '';
              final lvl = rawProps['level'] ?? 1;
              final race = rawProps['race'] ?? '';
              details = 'Level $lvl $cls ($race)'.trim();
            }
            setState(() {
              _previewHeroName = name;
              _previewHeroDetails = details;
              _errorMessage = null;
            });
            return;
          }
          // Character Keep format
          if (charData['personality'] is Map) {
            final p = charData['personality'] as Map;
            final name = p['name'] as String? ?? 'Hero';
            final cls = p['class'] as String? ?? '';
            final race = p['race'] as String? ?? '';
            setState(() {
              _previewHeroName = name;
              _previewHeroDetails = '$cls ($race) - Character Keep'.trim();
              _errorMessage = null;
            });
            return;
          }
        }
      }
    } catch (_) {}

    setState(() {
      _previewHeroName = null;
      _previewHeroDetails = null;
    });
  }

  Future<void> _pickFile() async {
    setState(() {
      _isPicking = true;
      _errorMessage = null;
    });

    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'txt'],
      );

      if (files.isEmpty) {
        setState(() => _isPicking = false);
        return;
      }

      final file = files.first;
      final bytes = await file.readAsBytes();
      final content = utf8.decode(bytes);

      if (content.trim().isEmpty) {
        setState(() {
          _isPicking = false;
          _errorMessage = 'The selected file is empty.';
        });
        return;
      }

      setState(() {
        _isPicking = false;
        _selectedFileName = file.name;
        _selectedFileSize = file.lengthSync() ?? bytes.length;
        _controller.text = content;
        _errorMessage = null;
      });
      _updatePreview(content);
    } catch (e) {
      setState(() {
        _isPicking = false;
        _errorMessage = 'Failed to load file: $e';
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      setState(() {
        _controller.text = data!.text!;
        _selectedFileName = 'Pasted Clipboard JSON';
        _selectedFileSize = data.text!.length;
        _errorMessage = null;
      });
      _updatePreview(data!.text!);
    }
  }

  Future<void> _importCharacter() async {
    final rawText = _controller.text.trim();
    if (rawText.isEmpty) {
      setState(() {
        _errorMessage = 'Please choose a backup file or paste character JSON';
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
    final hasContent = _controller.text.trim().isNotEmpty;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.file_upload_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'IMPORT HERO (JSON)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a character backup file (.json or .txt) from your device to restore your hero.',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withAlpha(170),
                ),
              ),
              const SizedBox(height: 14),

              // File Picker Target Area
              InkWell(
                onTap: _isLoading || _isPicking ? null : _pickFile,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedFileName != null
                        ? Colors.green.withAlpha(20)
                        : theme.colorScheme.primary.withAlpha(18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _selectedFileName != null
                          ? Colors.green.shade600
                          : theme.colorScheme.primary.withAlpha(120),
                      width: 1.5,
                    ),
                  ),
                  child: _isPicking
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Opening file browser...',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        )
                      : _selectedFileName != null
                      ? Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedFileName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (_previewHeroName != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      '$_previewHeroName ${_previewHeroDetails != null ? "• $_previewHeroDetails" : ""}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  if (_selectedFileSize != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      '${(_selectedFileSize! / 1024).toStringAsFixed(1)} KB',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: theme.colorScheme.onSurface
                                            .withAlpha(140),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _pickFile,
                              icon: const Icon(Icons.folder_open, size: 14),
                              label: const Text(
                                'Change',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open_outlined,
                              size: 36,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Choose Character Backup File',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Supports Scrivener (.json) and Character Keep (.txt) files',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface.withAlpha(
                                  140,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent.withAlpha(140)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Manual JSON Input area (allows pasting or direct text entry)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'OR PASTE BACKUP JSON',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: theme.colorScheme.primary.withAlpha(200),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _pasteFromClipboard,
                    icon: const Icon(Icons.paste, size: 14),
                    label: const Text('Paste', style: TextStyle(fontSize: 11)),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 120,
                child: TextField(
                  controller: _controller,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText:
                        '{\n  "format": "scrivener-character-backup", ...\n}',
                    hintStyle: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        OutlinedButton.icon(
          onPressed: _isLoading ? null : _pickFile,
          icon: const Icon(Icons.folder_open, size: 16),
          label: const Text('CHOOSE FILE'),
        ),
        ElevatedButton(
          onPressed: _isLoading || !hasContent ? null : _importCharacter,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('IMPORT HERO'),
        ),
      ],
    );
  }
}

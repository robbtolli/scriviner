import 'package:flutter/material.dart';

import '../../../../core/theme/models/scrivener_theme_tokens.dart';
import '../../models/character_sheet_data.dart';
import '../../providers/character_sheet_provider.dart';

class BioNotesTab extends StatefulWidget {
  final CharacterSheetState state;
  final CharacterSheetNotifier notifier;

  const BioNotesTab({
    super.key,
    required this.state,
    required this.notifier,
  });

  @override
  State<BioNotesTab> createState() => _BioNotesTabState();
}

class _BioNotesTabState extends State<BioNotesTab> {
  late TextEditingController _traitsCtrl;
  late TextEditingController _idealsCtrl;
  late TextEditingController _bondsCtrl;
  late TextEditingController _flawsCtrl;
  late TextEditingController _backstoryCtrl;
  late TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final bio = widget.state.bioNotes;
    _traitsCtrl = TextEditingController(text: bio.traits);
    _idealsCtrl = TextEditingController(text: bio.ideals);
    _bondsCtrl = TextEditingController(text: bio.bonds);
    _flawsCtrl = TextEditingController(text: bio.flaws);
    _backstoryCtrl = TextEditingController(text: bio.backstory);
    _notesCtrl = TextEditingController(text: bio.sessionNotes);
  }

  @override
  void dispose() {
    _traitsCtrl.dispose();
    _idealsCtrl.dispose();
    _bondsCtrl.dispose();
    _flawsCtrl.dispose();
    _backstoryCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updated = CharacterBioNotes(
      traits: _traitsCtrl.text,
      ideals: _idealsCtrl.text,
      bonds: _bondsCtrl.text,
      flaws: _flawsCtrl.text,
      backstory: _backstoryCtrl.text,
      sessionNotes: _notesCtrl.text,
    );
    widget.notifier.updateBioNotes(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notes and Biography saved!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<ScrivenerThemeTokens>() ?? ScrivenerThemeTokens.ancientTomeTokens;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(tokens.iconography.bio, color: theme.colorScheme.primary, size: 16),
                const SizedBox(width: 6),
                Text(
                  'ROLEPLAYING TRAITS & NOTES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save, size: 16),
              label: const Text('SAVE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Personality Traits Grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildBioField(context, 'Personality Traits', _traitsCtrl, maxLines: 3)),
            const SizedBox(width: 10),
            Expanded(child: _buildBioField(context, 'Ideals', _idealsCtrl, maxLines: 3)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildBioField(context, 'Bonds', _bondsCtrl, maxLines: 3)),
            const SizedBox(width: 10),
            Expanded(child: _buildBioField(context, 'Flaws', _flawsCtrl, maxLines: 3)),
          ],
        ),
        const SizedBox(height: 14),

        // Backstory
        _buildBioField(context, 'Character Backstory', _backstoryCtrl, maxLines: 5),
        const SizedBox(height: 14),

        // Campaign / Session Notes
        _buildBioField(context, 'Campaign & Session Notes (Markdown)', _notesCtrl, maxLines: 8),
      ],
    );
  }

  Widget _buildBioField(BuildContext context, String label, TextEditingController controller, {int maxLines = 3}) {
    final theme = Theme.of(context);
    final tokens = theme.extension<ScrivenerThemeTokens>() ?? ScrivenerThemeTokens.ancientTomeTokens;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(tokens.cardRadius * 0.8),
        border: Border.fromBorderSide(tokens.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface, height: 1.4),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: 'Enter $label...',
              hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(70)),
            ),
          ),
        ],
      ),
    );
  }
}

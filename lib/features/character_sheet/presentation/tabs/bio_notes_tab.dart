import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ROLEPLAYING TRAITS & NOTES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: AppTheme.primaryGold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save, size: 16),
              label: const Text('SAVE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: Colors.black,
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
            Expanded(child: _buildBioField('Personality Traits', _traitsCtrl, maxLines: 3)),
            const SizedBox(width: 10),
            Expanded(child: _buildBioField('Ideals', _idealsCtrl, maxLines: 3)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildBioField('Bonds', _bondsCtrl, maxLines: 3)),
            const SizedBox(width: 10),
            Expanded(child: _buildBioField('Flaws', _flawsCtrl, maxLines: 3)),
          ],
        ),
        const SizedBox(height: 14),

        // Backstory
        _buildBioField('Character Backstory', _backstoryCtrl, maxLines: 5),
        const SizedBox(height: 14),

        // Campaign / Session Notes
        _buildBioField('Campaign & Session Notes (Markdown)', _notesCtrl, maxLines: 8),
      ],
    );
  }

  Widget _buildBioField(String label, TextEditingController controller, {int maxLines = 3}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF4A4037)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: 'Enter $label...',
              hintStyle: TextStyle(color: Colors.white.withAlpha(70)),
            ),
          ),
        ],
      ),
    );
  }
}

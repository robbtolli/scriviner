import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

enum CreationMode { guidedWizard, freeformSheet }

class NewCharacterModal extends StatefulWidget {
  final void Function(String systemId, CreationMode mode) onStartCreation;
  final VoidCallback? onImportCharacter;

  const NewCharacterModal({
    super.key,
    required this.onStartCreation,
    this.onImportCharacter,
  });

  @override
  State<NewCharacterModal> createState() => _NewCharacterModalState();
}

class _NewCharacterModalState extends State<NewCharacterModal> {
  String _selectedSystem = 'dnd5e';
  CreationMode _selectedMode = CreationMode.guidedWizard;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.primaryGold, width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppTheme.primaryGold, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    'Create New Character',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'GAME SYSTEM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppTheme.primaryGold,
                ),
              ),
              const SizedBox(height: 8),
              _buildSystemTile(
                id: 'dnd5e',
                title: 'Dungeons & Dragons 5e / 2024',
                subtitle: 'Full SRD 5.1 rules, classes, races, and spellbook.',
                icon: Icons.auto_awesome,
              ),
              const SizedBox(height: 8),
              _buildSystemTile(
                id: 'pf2e',
                title: 'Pathfinder 2e (Remaster)',
                subtitle: 'Modular support coming in upcoming milestones.',
                icon: Icons.military_tech,
                isComingSoon: true,
              ),
              const SizedBox(height: 20),
              const Text(
                'CREATION MODE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppTheme.primaryGold,
                ),
              ),
              const SizedBox(height: 8),
              _buildModeOption(
                mode: CreationMode.guidedWizard,
                title: 'Guided Step-by-Step Wizard',
                subtitle: 'Recommended for new & leveling players. Educational tips, auto-assigned stats, and live sheet preview.',
                badge: 'RECOMMENDED',
              ),
              const SizedBox(height: 8),
              _buildModeOption(
                mode: CreationMode.freeformSheet,
                title: 'Freeform / Smart Paper Sheet',
                subtitle: 'Direct blank sheet for veteran players with total manual control and custom house rules.',
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.onImportCharacter != null)
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onImportCharacter!();
                      },
                      icon: const Icon(Icons.file_upload_outlined, size: 16),
                      label: const Text('IMPORT JSON', style: TextStyle(fontSize: 12)),
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onStartCreation(_selectedSystem, _selectedMode);
                        },
                        child: const Text('START CREATING'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemTile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    bool isComingSoon = false,
  }) {
    final isSelected = _selectedSystem == id;

    return InkWell(
      onTap: isComingSoon ? null : () => setState(() => _selectedSystem = id),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGold.withAlpha(25) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(20),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isComingSoon ? Colors.grey : AppTheme.primaryGold),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isComingSoon ? Colors.grey : Colors.white,
                        ),
                      ),
                      if (isComingSoon) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PLANNED',
                            style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(150)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption({
    required CreationMode mode,
    required String title,
    required String subtitle,
    String? badge,
  }) {
    final isSelected = _selectedMode == mode;

    return InkWell(
      onTap: () => setState(() => _selectedMode = mode),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGold.withAlpha(25) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(20),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.primaryGold : Colors.white.withAlpha(120),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(150)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

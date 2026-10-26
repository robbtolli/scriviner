import 'package:flutter/material.dart';

import '../../../../core/theme/models/scrivener_theme_tokens.dart';

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
    final theme = Theme.of(context);
    final tokens = context.tokens;

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        side: tokens.cardBorder,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    tokens.iconography.tabCombat,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Create New Character',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'GAME SYSTEM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              _buildSystemTile(
                context,
                id: 'dnd5e',
                title: 'Dungeons & Dragons 5e / 2024',
                subtitle: 'Full SRD 5.1 rules, classes, races, and spellbook.',
                icon: tokens.iconography.tabSpells,
              ),
              const SizedBox(height: 8),
              _buildSystemTile(
                context,
                id: 'pf2e',
                title: 'Pathfinder 2e (Remaster)',
                subtitle: 'Modular support coming in upcoming milestones.',
                icon: tokens.iconography.tabFeatures,
                isComingSoon: true,
              ),
              const SizedBox(height: 20),
              Text(
                'CREATION MODE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              _buildModeOption(
                context,
                mode: CreationMode.guidedWizard,
                title: 'Guided Step-by-Step Wizard',
                subtitle:
                    'Recommended for new & leveling players. Educational tips, auto-assigned stats, and live sheet preview.',
                badge: 'RECOMMENDED',
              ),
              const SizedBox(height: 8),
              _buildModeOption(
                context,
                mode: CreationMode.freeformSheet,
                title: 'Freeform / Smart Paper Sheet',
                subtitle:
                    'Direct blank sheet for veteran players with total manual control and custom house rules.',
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final importBtn = widget.onImportCharacter != null
                      ? OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onImportCharacter!();
                          },
                          icon: const Icon(
                            Icons.file_upload_outlined,
                            size: 16,
                          ),
                          label: const Text(
                            'IMPORT JSON',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      : null;

                  final actionBtns = Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onStartCreation(
                            _selectedSystem,
                            _selectedMode,
                          );
                        },
                        child: const Text('START CREATING'),
                      ),
                    ],
                  );

                  // When buttons do not comfortably fit on the same line (< 520dp available content width),
                  // place Cancel & START CREATING on the line below IMPORT JSON as requested.
                  if (constraints.maxWidth < 520 && importBtn != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: importBtn,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: actionBtns,
                        ),
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      importBtn ?? const SizedBox.shrink(),
                      Flexible(child: actionBtns),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemTile(
    BuildContext context, {
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    bool isComingSoon = false,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedSystem == id;

    return InkWell(
      onTap: isComingSoon ? null : () => setState(() => _selectedSystem = id),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withAlpha(25)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withAlpha(60),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isComingSoon ? Colors.grey : theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isComingSoon
                              ? Colors.grey
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (isComingSoon)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PLANNED',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
    BuildContext context, {
    required CreationMode mode,
    required String title,
    required String subtitle,
    String? badge,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedMode == mode;

    return InkWell(
      onTap: () => setState(() => _selectedMode = mode),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withAlpha(25)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withAlpha(60),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withAlpha(120),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 9,
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withAlpha(150),
                    ),
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

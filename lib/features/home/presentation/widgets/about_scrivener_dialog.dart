import 'package:flutter/material.dart';

import '../../../../core/theme/models/scrivener_theme_tokens.dart';

/// Modal dialog displaying application metadata, author credits,
/// the Mozilla Public License 2.0 terms, and the D&D 5e SRD 5.1 CC-BY-4.0 attribution.
class AboutScrivenerDialog extends StatelessWidget {
  const AboutScrivenerDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AboutScrivenerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.auto_stories, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                const Text(
                  'SCRIVENER',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(40),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(80),
                    ),
                  ),
                  child: Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Modern TTRPG Character Manager & Rules Engine',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                runSpacing: 4,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  Text(
                    'Author: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Robert Tolliver (tollitech.com)',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Name Origin & Meaning
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(
                    60,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history_edu,
                          size: 16,
                          color: tokens.accentColor,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'What is a Scrivener?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'In medieval times, a scrivener was a master scribe and record keeper entrusted with cataloging vital records. '
                      'This app is called Scrivener because it serves as your digital scribe—faithfully chronicling, calculating, and preserving your heroes\' attributes, gear, and adventures.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: theme.colorScheme.onSurface.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // Software License Section
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 16,
                        color: tokens.accentColor,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Open Source License',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.accentColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: tokens.accentColor.withAlpha(120),
                      ),
                    ),
                    child: Text(
                      'MPL 2.0',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: tokens.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Scrivener source code is licensed under the Mozilla Public License, Version 2.0 (MPL-2.0). '
                'Modifications to core files remain open source, while plugins, custom rulesets, and extensions remain unencumbered.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: theme.colorScheme.onSurface.withAlpha(200),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // D&D 5e SRD 5.1 Attribution
              Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'SRD 5.1 Attribution (CC-BY-4.0)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(
                    100,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(40),
                  ),
                ),
                child: Text(
                  'This work includes material taken from the System Reference Document 5.1 ("SRD 5.1") by Wizards of the Coast LLC and available at https://dnd.wizards.com/resources/systems-reference-document.\n\n'
                  'The SRD 5.1 is licensed under the Creative Commons Attribution 4.0 International License available at https://creativecommons.org/licenses/by/4.0/legalcode.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: theme.colorScheme.onSurface.withAlpha(190),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton.icon(
          icon: const Icon(Icons.library_books_outlined, size: 16),
          label: const Text('FULL LICENSES'),
          onPressed: () {
            showLicensePage(
              context: context,
              applicationName: 'Scrivener',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2026 Robert Tolliver (tollitech.com)',
            );
          },
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE'),
        ),
      ],
    );
  }
}

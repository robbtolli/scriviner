import 'package:flutter/material.dart';

import '../../../../core/theme/models/scrivener_theme_tokens.dart';

/// Modal dialog displaying application metadata, author credits,
/// the medieval origin of the name "Dice Caster", and Mozilla Public License 2.0 terms.
class AboutDiceCasterDialog extends StatelessWidget {
  const AboutDiceCasterDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AboutDiceCasterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;

    return AlertDialog(
      title: Row(
        children: [
          Image.asset(
            'assets/icons/dice_caster_icon_transparent.png',
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                const Text(
                  'DICE CASTER',
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
                'Tactile Polyhedral Dice Roller & Mathematical Engine',
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
                          'What is a Dice Caster?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'In medieval history, during games of Hazard (the ancestor of craps), the player holding and throwing the dice was formally known as "the caster." '
                      'In tabletop roleplaying, a caster channels arcane power to alter fate. '
                      'Dice Caster unites both worlds as a dedicated companion for every saving throw, ability check, and critical hit.',
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

              // Features / Engine Highlights
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Engine Highlights',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
                child: Text(
                  '• Polyhedral Sets: d4, d6, d8, d10, d12, d20, and d100.\n'
                  '• Formula Parser: Complex arithmetic, advantage (2d20kh1), disadvantage (2d20kl1), and drop-lowest (4d6dl1).\n'
                  '• Situational Modifiers: Quick-toggle Bless, Guidance, Inspiration, and Cover.\n'
                  '• 3D Dice Stage: Dynamic baked die sprite physics with natural 20 critical detection.\n'
                  '• 7 Atmospheric Themes: Hand-crafted palettes tailored for low-light tabletop sessions.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: theme.colorScheme.onSurface.withAlpha(190),
                  ),
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
                'Dice Caster source code is licensed under the Mozilla Public License, Version 2.0 (MPL-2.0). '
                'Modifications to core files remain open source, while custom themes and extensions remain unencumbered.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: theme.colorScheme.onSurface.withAlpha(200),
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
              applicationName: 'Dice Caster',
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';
import 'theme_provider.dart';

/// Modal dialog allowing the user to select from available visual themes.
class ThemeSelectorDialog extends ConsumerWidget {
  const ThemeSelectorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ThemeSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeData = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.palette, color: themeData.colorScheme.primary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'SELECT APP THEME',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: RadioGroup<AppThemeMode>(
            groupValue: currentTheme,
            onChanged: (val) {
              if (val != null) {
                ref.read(themeProvider.notifier).setTheme(val);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: AppThemeMode.values.map((mode) {
                final isSelected = mode == currentTheme;
                final previewTheme = AppTheme.getThemeData(mode);

                return InkWell(
                  onTap: () {
                    ref.read(themeProvider.notifier).setTheme(mode);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? themeData.colorScheme.primary.withAlpha(25)
                          : themeData.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? themeData.colorScheme.primary
                            : themeData.dividerColor.withAlpha(80),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio<AppThemeMode>(
                          value: mode,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    mode.icon,
                                    size: 18,
                                    color: previewTheme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      mode.displayName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: themeData.colorScheme.onSurface,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mode.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: themeData.colorScheme.onSurface.withAlpha(180),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Mini color swatch preview
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: previewTheme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: previewTheme.colorScheme.primary.withAlpha(120),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: previewTheme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: previewTheme.colorScheme.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('DONE'),
        ),
      ],
    );
  }
}

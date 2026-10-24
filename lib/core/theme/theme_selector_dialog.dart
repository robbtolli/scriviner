import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';
import 'theme_provider.dart';

/// Modal dialog allowing the user to select from available visual themes,
/// optionally supporting an "App Default" option for character-level overrides.
class ThemeSelectorDialog extends ConsumerWidget {
  final String title;
  final AppThemeMode? currentSelectedMode;
  final bool isCharacterLevel;
  final ValueChanged<AppThemeMode?>? onThemeSelected;

  const ThemeSelectorDialog({
    super.key,
    this.title = 'SELECT APP THEME',
    this.currentSelectedMode,
    this.isCharacterLevel = false,
    this.onThemeSelected,
  });

  static Future<void> show(
    BuildContext context, {
    String title = 'SELECT APP THEME',
    AppThemeMode? currentSelectedMode,
    bool isCharacterLevel = false,
    ValueChanged<AppThemeMode?>? onThemeSelected,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ThemeSelectorDialog(
        title: title,
        currentSelectedMode: currentSelectedMode,
        isCharacterLevel: isCharacterLevel,
        onThemeSelected: onThemeSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalAppTheme = ref.watch(themeProvider);
    final themeData = Theme.of(context);
    final activeSelection = isCharacterLevel ? currentSelectedMode : globalAppTheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.palette, color: themeData.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: SizedBox(
        width: 500,
        height: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCharacterLevel) ...[
                // "App Default" option
                InkWell(
                  onTap: () {
                    onThemeSelected?.call(null);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: activeSelection == null
                          ? themeData.colorScheme.primary.withAlpha(25)
                          : themeData.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: activeSelection == null
                            ? themeData.colorScheme.primary
                            : themeData.dividerColor.withAlpha(80),
                        width: activeSelection == null ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          activeSelection == null
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: activeSelection == null
                              ? themeData.colorScheme.primary
                              : themeData.colorScheme.onSurface.withAlpha(120),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'App Default (${globalAppTheme.displayName})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: themeData.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Inherits whatever theme is selected in global settings',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: themeData.colorScheme.onSurface.withAlpha(180),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Divider(),
                ),
              ],
              ...AppThemeMode.values.map((mode) {
                final isSelected = activeSelection == mode;
                final previewTheme = AppTheme.getThemeData(mode);

                return InkWell(
                  onTap: () {
                    if (isCharacterLevel) {
                      onThemeSelected?.call(mode);
                      Navigator.of(context).pop();
                    } else {
                      ref.read(themeProvider.notifier).setTheme(mode);
                    }
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
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? themeData.colorScheme.primary
                              : themeData.colorScheme.onSurface.withAlpha(120),
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
              }),
            ],
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

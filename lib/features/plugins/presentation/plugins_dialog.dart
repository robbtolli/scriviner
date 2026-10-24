import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/plugin_provider.dart';

/// Modal dialog for browsing, importing, and managing declarative homebrew plugins.
class PluginsDialog extends ConsumerWidget {
  const PluginsDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const PluginsDialog(),
    );
  }

  void _showImportJsonDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_upload_outlined),
            SizedBox(width: 8),
            Text('Import Plugin JSON', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Paste a valid scrivener-plugin JSON manifest below:',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: '{\n  "id": "my-homebrew",\n  "name": "My Custom Pack",\n  "version": "1.0.0",\n  "targetSystem": "dnd5e",\n  "entities": { ... }\n}',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              final success = await ref.read(pluginProvider.notifier).installFromJson(text);
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Plugin installed successfully!'
                          : (ref.read(pluginProvider).errorMessage ?? 'Failed to install plugin'),
                    ),
                    backgroundColor: success ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                );
              }
            },
            child: const Text('INSTALL'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pluginProvider);
    final theme = Theme.of(context);
    final isEloriaInstalled = ref.read(pluginProvider.notifier).isInstalled('eloria-homebrew-compendium');

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.extension, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'PLUGINS & HOMEBREW',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: SizedBox(
        width: 520,
        height: 400,
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Declarative, sandboxed homebrew packs extending spells, items, and rules.',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withAlpha(160)),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: state.installedPlugins.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.inventory_2_outlined, size: 48, color: theme.colorScheme.primary.withAlpha(120)),
                                const SizedBox(height: 12),
                                const Text(
                                  'No homebrew plugins installed',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Import custom JSON plugins or try the official sample pack below.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withAlpha(160)),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: state.installedPlugins.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final plugin = state.installedPlugins[index];
                              final spellsCount = (plugin.entities['spells'] as List?)?.length ?? 0;
                              final itemsCount = ((plugin.entities['items'] ?? plugin.entities['equipment']) as List?)?.length ?? 0;
                              final featuresCount = (plugin.entities['features'] as List?)?.length ?? 0;

                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.auto_awesome, size: 18, color: theme.colorScheme.primary),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              plugin.name,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                                            tooltip: 'Uninstall Plugin',
                                            onPressed: () async {
                                              await ref.read(pluginProvider.notifier).uninstall(plugin.id);
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'v${plugin.version} by ${plugin.author} • ${plugin.targetSystem}',
                                        style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withAlpha(140)),
                                      ),
                                      if (plugin.description.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          plugin.description,
                                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withAlpha(200)),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: [
                                          if (spellsCount > 0)
                                            Chip(
                                              label: Text('$spellsCount Spells', style: const TextStyle(fontSize: 10)),
                                              visualDensity: VisualDensity.compact,
                                              padding: EdgeInsets.zero,
                                            ),
                                          if (itemsCount > 0)
                                            Chip(
                                              label: Text('$itemsCount Items', style: const TextStyle(fontSize: 10)),
                                              visualDensity: VisualDensity.compact,
                                              padding: EdgeInsets.zero,
                                            ),
                                          if (featuresCount > 0)
                                            Chip(
                                              label: Text('$featuresCount Features', style: const TextStyle(fontSize: 10)),
                                              visualDensity: VisualDensity.compact,
                                              padding: EdgeInsets.zero,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
      actions: [
        if (!isEloriaInstalled)
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(pluginProvider.notifier).installSamplePack();
            },
            icon: const Icon(Icons.library_add, size: 16),
            label: const Text('SAMPLE PACK', style: TextStyle(fontSize: 12)),
          ),
        OutlinedButton.icon(
          onPressed: () => _showImportJsonDialog(context, ref),
          icon: const Icon(Icons.upload_file, size: 16),
          label: const Text('IMPORT JSON', style: TextStyle(fontSize: 12)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('DONE'),
        ),
      ],
    );
  }
}

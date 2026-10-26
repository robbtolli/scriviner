import 'dart:convert';
import 'package:drift/drift.dart' show Value;

import '../../../core/database/app_database.dart';
import '../models/plugin_manifest.dart';

/// Service responsible for validating, installing, and managing plugins in Scrivener.
/// All homebrew plugins are safe, data-driven entities injected into SQLite.
class PluginLoaderService {
  final Map<String, PluginManifest> _installedPlugins = {};

  List<PluginManifest> get installedPlugins =>
      _installedPlugins.values.toList();

  bool isPluginInstalled(String pluginId) =>
      _installedPlugins.containsKey(pluginId);

  PluginManifest? getPlugin(String pluginId) => _installedPlugins[pluginId];

  /// Validates and installs a plugin into the SQLite database.
  Future<int> installPlugin(AppDatabase db, PluginManifest manifest) async {
    manifest.validate();

    final List<CompendiumTableCompanion> entries = [];

    // Process spells
    final spells = manifest.entities['spells'];
    if (spells is List) {
      for (final raw in spells) {
        if (raw is Map<String, dynamic>) {
          final spellName = raw['name'] as String? ?? 'Unnamed Spell';
          final entityId = raw['id'] as String? ?? _slugify(spellName);
          final summary =
              raw['description'] as String? ?? raw['summary'] as String? ?? '';

          entries.add(
            CompendiumTableCompanion.insert(
              id: '${manifest.id}:spell:$entityId',
              systemId: manifest.targetSystem,
              category: 'spell',
              name: spellName,
              summary: Value(summary),
              fullDataJson: Value(jsonEncode(raw)),
            ),
          );
        }
      }
    }

    // Process equipment / items
    final items = manifest.entities['items'] ?? manifest.entities['equipment'];
    if (items is List) {
      for (final raw in items) {
        if (raw is Map<String, dynamic>) {
          final itemName = raw['name'] as String? ?? 'Unnamed Item';
          final entityId = raw['id'] as String? ?? _slugify(itemName);
          final summary =
              raw['description'] as String? ?? raw['summary'] as String? ?? '';

          entries.add(
            CompendiumTableCompanion.insert(
              id: '${manifest.id}:item:$entityId',
              systemId: manifest.targetSystem,
              category: 'item',
              name: itemName,
              summary: Value(summary),
              fullDataJson: Value(jsonEncode(raw)),
            ),
          );
        }
      }
    }

    // Process class features / traits
    final features = manifest.entities['features'];
    if (features is List) {
      for (final raw in features) {
        if (raw is Map<String, dynamic>) {
          final featureName = raw['name'] as String? ?? 'Unnamed Feature';
          final entityId = raw['id'] as String? ?? _slugify(featureName);
          final summary =
              raw['description'] as String? ?? raw['summary'] as String? ?? '';

          entries.add(
            CompendiumTableCompanion.insert(
              id: '${manifest.id}:feature:$entityId',
              systemId: manifest.targetSystem,
              category: 'feature',
              name: featureName,
              summary: Value(summary),
              fullDataJson: Value(jsonEncode(raw)),
            ),
          );
        }
      }
    }

    if (entries.isNotEmpty) {
      await db.insertCompendiumEntries(entries);
    }

    _installedPlugins[manifest.id] = manifest;
    return entries.length;
  }

  /// Uninstalls a plugin and removes all its entities from the compendium database.
  Future<int> uninstallPlugin(AppDatabase db, String pluginId) async {
    final deletedCount = await db.deleteCompendiumEntriesByPrefix('$pluginId:');
    _installedPlugins.remove(pluginId);
    return deletedCount;
  }

  /// Sample built-in homebrew pack "Relics of Eloria".
  static PluginManifest get sampleEloriaPlugin {
    return PluginManifest(
      id: 'eloria-homebrew-compendium',
      name: 'Relics of Eloria Pack',
      version: '1.0.0',
      author: 'Tabletop Guild',
      targetSystem: 'dnd5e',
      type: 'compendium',
      description:
          'Adds 3 legendary relics, 3 mystic spells, and 1 unique feature from the Eloria campaign.',
      entities: {
        'spells': [
          {
            'name': 'Elorian Moonfire',
            'level': 2,
            'school': 'Evocation',
            'castingTime': '1 action',
            'range': '60 feet',
            'description':
                'Bathes targets in silver moonlight dealing 3d6 radiant damage and revealing invisible creatures.',
          },
          {
            'name': 'Aegis of the Astral',
            'level': 3,
            'school': 'Abjuration',
            'castingTime': '1 reaction',
            'range': 'Self',
            'description':
                'Forms a shimmering crystalline barrier absorbing up to 25 force or radiant damage.',
          },
          {
            'name': 'Verdant Bloom',
            'level': 1,
            'school': 'Transmutation',
            'castingTime': '1 action',
            'range': '30 feet',
            'description':
                'Causes vibrant healing flora to blossom, restoring 1d8 + 3 HP to up to two creatures.',
          },
        ],
        'items': [
          {
            'name': 'Sunforged Blade',
            'category': 'Martial Melee Weapon',
            'weight': 3.0,
            'cost': '1,500 gp',
            'damage': '1d8 Slashing + 1d4 Radiant',
            'description':
                'A mastercrafted radiant scimitar forged inside the heart of an ancient solar forge.',
          },
          {
            'name': 'Cloak of Whispers',
            'category': 'Wondrous Item',
            'weight': 1.0,
            'cost': '800 gp',
            'description':
                'Woven from shadowsilk. Grants advantage on Stealth checks and 1/day invisibility.',
          },
          {
            'name': 'Ring of the Archmagus',
            'category': 'Ring',
            'weight': 0.1,
            'cost': '2,500 gp',
            'description':
                'Attuned ring granting +1 to spell attack rolls and spell save DC.',
          },
        ],
        'features': [
          {
            'name': 'Moonlight Blessing',
            'source': 'Eloria Cleric Domain',
            'description':
                'Once per long rest, call upon astral moonlight to grant yourself advantage on all saving throws for 1 round.',
          },
        ],
      },
    );
  }

  String _slugify(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }
}

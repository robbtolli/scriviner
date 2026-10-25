# Packaging & Distributing Scrivener Plugins

Once you have authored your homebrew spells, magic items, or custom systems, you can package and distribute them to the tabletop community. This guide details how to bundle, validate, test, and install Scrivener plugins.

<p align="center">
  <img src="../images/compendium.png" alt="Scrivener Plugin Manager Modal" width="700" />
</p>

---

## 1. Structuring Your Plugin Package

A Scrivener plugin is distributed as a single `.json` file. 

### File Naming Convention
Name your file with the plugin's kebab-case ID followed by `.scrivener-plugin.json` or simply `.json`:
```
eloria-homebrew-compendium.scrivener-plugin.json
```

### Manifest Format Review
Ensure your package contains the mandatory top-level metadata:
```json
{
  "id": "my-homebrew-pack",
  "name": "My Homebrew Pack",
  "version": "1.0.0",
  "author": "Your Name",
  "targetSystem": "dnd5e",
  "type": "compendium",
  "description": "A collection of 5 unique magic items and 3 cantrips.",
  "entities": {
    "spells": [],
    "items": [],
    "features": []
  }
}
```

---

## 2. Automated Validation & Local Testing

Before distributing your plugin file, test that it passes Scrivener's `PluginLoaderService` validation in Dart:

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/features/plugins/models/plugin_manifest.dart';
import 'package:scrivener/features/plugins/services/plugin_loader_service.dart';
import 'package:drift/native.dart';

void main() {
  test('validates and installs custom plugin', () async {
    final rawJson = File('my-homebrew-pack.json').readAsStringSync();
    final manifest = PluginManifest.parse(rawJson);

    // Verify manifest parsed successfully
    expect(manifest.id, 'my-homebrew-pack');
    expect(manifest.totalEntityCount, greaterThan(0));

    // Test SQLite injection into in-memory database
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => db.close());

    final service = PluginLoaderService();
    final insertedCount = await service.installPlugin(db, manifest);
    expect(insertedCount, equals(manifest.totalEntityCount));

    // Test clean uninstallation
    final deletedCount = await service.uninstallPlugin(db, manifest.id);
    expect(deletedCount, equals(insertedCount));
  });
}
```

---

## 3. In-App Installation Workflow

Users install plugins directly within Scrivener's user interface:

1. Tap the **Plugins & Homebrew** icon (`Icons.extension_outlined`) on the Home screen AppBar.
2. If no homebrew plugins are installed, tap **Sample Pack** to explore the built-in *Relics of Eloria* pack, or tap **Import JSON**.
3. **Pasting JSON**: Paste your raw plugin JSON text into the dialog.
4. **Validation**: Scrivener validates the manifest structure and counts all spells, items, and traits.
5. Tap **Install Plugin**.
6. All entities are written to the local SQLite compendium database and become instantly available across character sheets, equipment searches, and spell lists.

---

## 4. Managing Installed Plugins

Inside the **Plugins & Homebrew** dialog:
- View the active version, author, and description of each installed plugin.
- View the total entity count (e.g. `7 entities: 3 spells, 3 items, 1 feature`).
- **Uninstallation**: Tap the trash icon next to any installed plugin. Scrivener atomically deletes all entities prefixed with that plugin's namespace (`pluginId:*`), ensuring no orphaned items remain in the database.

---

## 5. Sharing & Distribution Channels

Because Scrivener plugins are pure JSON:
- **GitHub**: Host your plugin repository with releases containing the `.json` file.
- **Discord / Tabletop Forums**: Share the JSON text directly or upload the `.json` file.
- **QR Codes**: For smaller packs, compress the JSON and display a QR code for players to scan at the game table.

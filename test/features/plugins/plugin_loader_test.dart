import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrivener/core/database/app_database.dart';
import 'package:scrivener/core/database/database_provider.dart';
import 'package:scrivener/features/plugins/models/plugin_manifest.dart';
import 'package:scrivener/features/plugins/presentation/plugins_dialog.dart';
import 'package:scrivener/features/plugins/services/plugin_loader_service.dart';

void main() {
  late AppDatabase db;
  late PluginLoaderService loaderService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    loaderService = PluginLoaderService();
  });

  tearDown(() async {
    await db.close();
  });

  group('PluginManifest Tests', () {
    test('parses valid manifest JSON', () {
      const jsonStr = '''
      {
        "id": "test-pack",
        "name": "Test Homebrew Pack",
        "version": "1.2.0",
        "author": "Archmage",
        "targetSystem": "dnd5e",
        "description": "A testing pack",
        "entities": {
          "spells": [{"name": "Arcane Bolt", "level": 1}]
        }
      }
      ''';

      final manifest = PluginManifest.parse(jsonStr);
      expect(manifest.id, 'test-pack');
      expect(manifest.name, 'Test Homebrew Pack');
      expect(manifest.version, '1.2.0');
      expect(manifest.author, 'Archmage');
      expect(manifest.targetSystem, 'dnd5e');
      expect(manifest.totalEntityCount, 1);
    });

    test('strips markdown codeblock backticks when parsing', () {
      const codeblockStr = '''```json
      {
        "id": "codeblock-pack",
        "name": "Markdown Pack",
        "version": "1.0.0",
        "author": "Scribe",
        "targetSystem": "dnd5e"
      }
      ```''';

      final manifest = PluginManifest.parse(codeblockStr);
      expect(manifest.id, 'codeblock-pack');
      expect(manifest.name, 'Markdown Pack');
    });

    test('throws FormatException on missing required fields', () {
      expect(
        () => PluginManifest.fromJson({'name': 'Incomplete Pack'}),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('PluginLoaderService Tests', () {
    test('installs sample Eloria pack into SQLite compendium', () async {
      final sample = PluginLoaderService.sampleEloriaPlugin;
      final count = await loaderService.installPlugin(db, sample);

      expect(count, 7); // 3 spells + 3 items + 1 feature
      expect(
        loaderService.isPluginInstalled('eloria-homebrew-compendium'),
        isTrue,
      );

      // Verify queryable via database
      final spells = await db.searchCompendium(
        'dnd5e',
        category: 'spell',
        query: 'Moonfire',
      );
      expect(spells.length, 1);
      expect(spells.first.name, 'Elorian Moonfire');

      final items = await db.searchCompendium(
        'dnd5e',
        category: 'item',
        query: 'Sunforged',
      );
      expect(items.length, 1);
      expect(items.first.name, 'Sunforged Blade');

      final features = await db.searchCompendium(
        'dnd5e',
        category: 'feature',
        query: 'Blessing',
      );
      expect(features.length, 1);
      expect(features.first.name, 'Moonlight Blessing');
    });

    test('uninstalls plugin and clears compendium entries', () async {
      final sample = PluginLoaderService.sampleEloriaPlugin;
      await loaderService.installPlugin(db, sample);

      final uninstalledCount = await loaderService.uninstallPlugin(
        db,
        sample.id,
      );
      expect(uninstalledCount, 7);
      expect(loaderService.isPluginInstalled(sample.id), isFalse);

      final spellsAfter = await db.searchCompendium(
        'dnd5e',
        category: 'spell',
        query: 'Moonfire',
      );
      expect(spellsAfter, isEmpty);
    });
  });

  group('PluginsDialog Widget Tests', () {
    testWidgets('installs and uninstalls sample pack via dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => PluginsDialog.show(context),
                  child: const Text('Open Plugins'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Plugins'));
      await tester.pumpAndSettle();

      expect(find.text('PLUGINS & CUSTOM CONTENT'), findsOneWidget);
      expect(find.text('No custom plugins installed'), findsOneWidget);
      expect(find.text('SAMPLE PACK'), findsOneWidget);

      // Tap SAMPLE PACK to install
      await tester.tap(find.text('SAMPLE PACK'));
      await tester.pumpAndSettle();

      expect(find.text('Relics of Eloria Pack'), findsOneWidget);
      expect(find.text('3 Spells'), findsOneWidget);
      expect(find.text('3 Items'), findsOneWidget);
      expect(find.text('1 Features'), findsOneWidget);

      // Tap uninstall icon
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('No custom plugins installed'), findsOneWidget);
    });
  });
}

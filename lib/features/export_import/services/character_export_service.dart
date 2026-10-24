import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';

/// Service responsible for serializing characters into portable JSON and
/// restoring backups into SQLite with ID de-duplication.
class CharacterExportService {
  static const int currentSchemaVersion = 1;
  static const String backupFormatTag = 'scrivener-character-backup';

  /// Serializes a character and all related conditions and inventory into a JSON backup.
  Future<String> exportCharacterToJson(
    AppDatabase db,
    String characterId, {
    bool pretty = true,
  }) async {
    final character = await db.getCharacter(characterId);
    if (character == null) {
      throw ArgumentError('Character with id "$characterId" not found');
    }

    final conditions = await db.getConditionsForCharacter(characterId);
    final inventory = await db.getInventoryForCharacter(characterId);

    dynamic decodedProperties;
    try {
      decodedProperties = jsonDecode(character.rawPropertiesJson);
    } catch (_) {
      decodedProperties = character.rawPropertiesJson;
    }

    final Map<String, dynamic> payload = {
      'format': backupFormatTag,
      'schemaVersion': currentSchemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'character': {
        'id': character.id,
        'name': character.name,
        'systemId': character.systemId,
        'portraitUri': character.portraitUri,
        'createdAt': character.createdAt.toIso8601String(),
        'lastPlayedAt': character.lastPlayedAt.toIso8601String(),
        'rawProperties': decodedProperties,
        'notes': character.notes,
      },
      'conditions': conditions.map((c) => {
        'id': c.id,
        'conditionId': c.conditionId,
        'durationRounds': c.durationRounds,
        'customNotes': c.customNotes,
      }).toList(),
      'inventory': inventory.map((i) {
        dynamic itemData;
        try {
          itemData = jsonDecode(i.itemDataJson);
        } catch (_) {
          itemData = i.itemDataJson;
        }

        return {
          'id': i.id,
          'name': i.name,
          'quantity': i.quantity,
          'weight': i.weight,
          'isEquipped': i.isEquipped,
          'isAttuned': i.isAttuned,
          'containerName': i.containerName,
          'itemData': itemData,
        };
      }).toList(),
    };

    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(payload);
    } else {
      return jsonEncode(payload);
    }
  }

  /// Deserializes a character JSON backup and restores it to SQLite.
  /// When [generateNewId] is true, generates new UUIDs to prevent collisions
  /// when importing a copy or sharing with friends.
  Future<String> importCharacterFromJson(
    AppDatabase db,
    String jsonString, {
    bool generateNewId = true,
  }) async {
    String cleaned = jsonString.trim();
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    cleaned = cleaned.trim();

    final decoded = jsonDecode(cleaned);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Import payload must be a JSON object');
    }

    final charData = decoded['character'];
    if (charData is! Map<String, dynamic>) {
      throw const FormatException('Missing or invalid "character" block in backup');
    }

    final rawName = charData['name'] as String? ?? 'Imported Hero';
    final systemId = charData['systemId'] as String? ?? 'dnd5e';
    final portraitUri = charData['portraitUri'] as String?;
    final notes = charData['notes'] as String? ?? '';

    final rawProps = charData['rawProperties'];
    final String rawPropertiesJson = (rawProps is Map || rawProps is List)
        ? jsonEncode(rawProps)
        : (rawProps?.toString() ?? '{}');

    final now = DateTime.now();
    final String targetCharacterId = generateNewId
        ? const Uuid().v4()
        : (charData['id'] as String? ?? const Uuid().v4());

    final characterName = generateNewId && charData['id'] != null
        ? rawName
        : rawName;

    // Insert Character
    await db.upsertCharacter(
      CharactersTableCompanion.insert(
        id: targetCharacterId,
        name: characterName,
        systemId: Value(systemId),
        portraitUri: portraitUri != null ? Value(portraitUri) : const Value.absent(),
        createdAt: now,
        lastPlayedAt: now,
        rawPropertiesJson: rawPropertiesJson,
        notes: Value(notes),
      ),
    );

    // Insert Conditions
    final conditionsList = decoded['conditions'];
    if (conditionsList is List) {
      for (final rawCond in conditionsList) {
        if (rawCond is Map<String, dynamic>) {
          final conditionId = rawCond['conditionId'] as String? ?? 'unknown';
          final duration = rawCond['durationRounds'] as int?;
          final customNotes = rawCond['customNotes'] as String? ?? '';

          await db.addCondition(
            ConditionsTableCompanion.insert(
              id: const Uuid().v4(),
              characterId: targetCharacterId,
              conditionId: conditionId,
              durationRounds: duration != null ? Value(duration) : const Value.absent(),
              customNotes: Value(customNotes),
            ),
          );
        }
      }
    }

    // Insert Inventory
    final inventoryList = decoded['inventory'];
    if (inventoryList is List) {
      for (final rawItem in inventoryList) {
        if (rawItem is Map<String, dynamic>) {
          final itemName = rawItem['name'] as String? ?? 'Item';
          final quantity = rawItem['quantity'] as int? ?? 1;
          final weight = (rawItem['weight'] as num?)?.toDouble() ?? 0.0;
          final isEquipped = rawItem['isEquipped'] as bool? ?? false;
          final isAttuned = rawItem['isAttuned'] as bool? ?? false;
          final containerName = rawItem['containerName'] as String? ?? 'Backpack';
          final itemData = rawItem['itemData'];
          final itemDataJson = (itemData is Map || itemData is List)
              ? jsonEncode(itemData)
              : (itemData?.toString() ?? '{}');

          await db.upsertInventoryItem(
            InventoryTableCompanion.insert(
              id: const Uuid().v4(),
              characterId: targetCharacterId,
              name: itemName,
              quantity: Value(quantity),
              weight: Value(weight),
              isEquipped: Value(isEquipped),
              isAttuned: Value(isAttuned),
              containerName: Value(containerName),
              itemDataJson: Value(itemDataJson),
            ),
          );
        }
      }
    }

    return targetCharacterId;
  }
}

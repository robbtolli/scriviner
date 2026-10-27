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
      'conditions': conditions
          .map(
            (c) => {
              'id': c.id,
              'conditionId': c.conditionId,
              'durationRounds': c.durationRounds,
              'customNotes': c.customNotes,
            },
          )
          .toList(),
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

    final rawDecoded = jsonDecode(cleaned);
    if (rawDecoded is! Map<String, dynamic>) {
      throw const FormatException('Import payload must be a JSON object');
    }

    final decoded = _normalizeCharacterPayload(rawDecoded);

    final charData = decoded['character'];
    if (charData is! Map<String, dynamic>) {
      throw const FormatException(
        'Missing or invalid "character" block in backup',
      );
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
        portraitUri: portraitUri != null
            ? Value(portraitUri)
            : const Value.absent(),
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
              durationRounds: duration != null
                  ? Value(duration)
                  : const Value.absent(),
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
          final containerName =
              rawItem['containerName'] as String? ?? 'Backpack';
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

  /// Normalizes incoming payloads, seamlessly converting legacy or alternative
  /// formats like Character Keep into Scrivener's expected schema.
  Map<String, dynamic> _normalizeCharacterPayload(Map<String, dynamic> raw) {
    final charData = raw['character'];
    if (charData is! Map<String, dynamic>) {
      return raw;
    }

    // If standard Scrivener backup with rawProperties, return unmodified
    if (charData['rawProperties'] != null) {
      return raw;
    }

    // Check if it is a Character Keep export
    final personality = charData['personality'];
    if (personality is Map) {
      final name = personality['name'] as String? ?? 'Imported Hero';
      final rawClass = personality['class'] as String? ?? 'Adventurer';
      final className = rawClass.replaceAll(' (2024)', '').trim();
      final levels = personality['levels'] as List? ?? [];
      final level = levels.isNotEmpty ? levels.length : 1;
      final rawRace = personality['race'] as String? ?? 'Human';
      final subrace = personality['subrace'] as String?;
      final raceName = (subrace != null && subrace.trim().isNotEmpty)
          ? subrace.trim()
          : rawRace.replaceAll(' (2024)', '').trim();
      final bg = charData['background'];
      final bgName = (bg is Map)
          ? (bg['name'] as String? ?? 'Folk Hero')
          : 'Folk Hero';

      final ckAbilities = charData['abilities'] as Map? ?? {};
      final abilityScores = <String, dynamic>{};
      for (final stat in ['str', 'dex', 'con', 'int', 'wis', 'cha']) {
        final statData = ckAbilities[stat.toUpperCase()] as Map? ?? {};
        final base = int.tryParse(statData['base']?.toString() ?? '10') ?? 10;
        final raceMod = int.tryParse(statData['race']?.toString() ?? '0') ?? 0;
        final miscMod = int.tryParse(statData['misc']?.toString() ?? '0') ?? 0;
        final bgMod = int.tryParse(statData['bg']?.toString() ?? '0') ?? 0;
        final total = base + raceMod + miscMod + bgMod;
        final mod = ((total - 10) / 2).floor();
        abilityScores[stat] = {'score': total, 'mod': mod};
      }

      final profBonus = 2 + ((level - 1) / 4).floor();

      final classLower = className.toLowerCase();
      List<String> saves = ['str', 'dex'];
      if (classLower.contains('sorcerer')) {
        saves = ['con', 'cha'];
      } else if (classLower.contains('wizard') ||
          classLower.contains('druid')) {
        saves = ['int', 'wis'];
      } else if (classLower.contains('fighter') ||
          classLower.contains('barbarian')) {
        saves = ['str', 'con'];
      } else if (classLower.contains('rogue')) {
        saves = ['dex', 'int'];
      } else if (classLower.contains('cleric') ||
          classLower.contains('paladin')) {
        saves = ['wis', 'cha'];
      } else if (classLower.contains('bard')) {
        saves = ['dex', 'cha'];
      } else if (classLower.contains('ranger')) {
        saves = ['str', 'dex'];
      }

      final ckSkills = charData['skills'] as Map? ?? {};
      final skillsList = <String>[];
      final skillProfs = <String, int>{};
      ckSkills.forEach((k, v) {
        if (v is Map && (v['proficiency'] == true || v['expert'] == true)) {
          final sName = k.toString();
          skillsList.add(sName);
          skillProfs[sName] = (v['expert'] == true) ? 2 : 1;
        }
      });

      final ckCombat = charData['combat'] as Map? ?? {};
      final ckHp = ckCombat['hp'] as Map? ?? {};
      final currentHp = (ckHp['current'] as num?)?.toInt() ?? 10;
      final maxHp = (ckHp['max'] as num?)?.toInt() ?? 10;
      final tempHp = (ckHp['temp'] as num?)?.toInt() ?? 0;

      int hitDie = 8;
      if (classLower.contains('barbarian')) {
        hitDie = 12;
      } else if (classLower.contains('fighter') ||
          classLower.contains('paladin') ||
          classLower.contains('ranger')) {
        hitDie = 10;
      } else if (classLower.contains('sorcerer') ||
          classLower.contains('wizard')) {
        hitDie = 6;
      }

      int ac = 10 + (abilityScores['dex']?['mod'] as int? ?? 0);
      final armorList = charData['items']?['armor'] as List? ?? [];
      for (final a in armorList) {
        if (a is Map && a['equipped'] == true) {
          final aName = (a['name'] as String? ?? '').toLowerCase();
          final dexMod = (abilityScores['dex']?['mod'] as int? ?? 0);
          if (aName.contains('studded leather')) {
            ac = 12 + dexMod;
          } else if (aName.contains('leather')) {
            ac = 11 + dexMod;
          } else if (aName.contains('hide')) {
            ac = 12 + (dexMod > 2 ? 2 : dexMod);
          } else if (aName.contains('chain shirt') ||
              aName.contains('scale mail')) {
            ac = 14 + (dexMod > 2 ? 2 : dexMod);
          } else if (aName.contains('breastplate') ||
              aName.contains('half plate')) {
            ac = 15 + (dexMod > 2 ? 2 : dexMod);
          } else if (aName.contains('plate')) {
            ac = 18;
          }
          break;
        }
      }

      final spellsList = <Map<String, dynamic>>[];
      for (final s in (charData['spells'] as List? ?? [])) {
        if (s is Map) {
          final sName = s['name'] as String? ?? 'Spell';
          spellsList.add({
            'id': 'spell_${sName.toLowerCase().replaceAll(' ', '_')}',
            'name': sName,
            'level': 0,
            'school': 'Evocation',
            'isPrepared': s['prepared'] == true || s['alwaysPrepared'] == true,
          });
        }
      }

      final featuresList = <Map<String, dynamic>>[];
      for (final f in (charData['feats'] as List? ?? [])) {
        if (f is Map) {
          final fName = f['name'] as String? ?? 'Feat';
          final desc = (f['desc'] is List)
              ? (f['desc'] as List).join(' ')
              : f['desc']?.toString() ?? '';
          featuresList.add({
            'id': 'feat_${fName.toLowerCase().replaceAll(' ', '_')}',
            'name': fName,
            'source': f['type']?.toString() ?? 'Feat',
            'description': desc,
          });
        }
      }

      final ckMoney = charData['money'] as Map? ?? {};
      final currency = {
        'cp': (ckMoney['CP'] as num?)?.toInt() ?? 0,
        'sp': (ckMoney['SP'] as num?)?.toInt() ?? 0,
        'ep': (ckMoney['EP'] as num?)?.toInt() ?? 0,
        'gp': (ckMoney['GP'] as num?)?.toInt() ?? 0,
        'pp': (ckMoney['PP'] as num?)?.toInt() ?? 0,
      };

      final inventoryList = <Map<String, dynamic>>[];
      final ckItems = charData['items'] as Map? ?? {};
      ckItems.forEach((catKey, items) {
        if (items is List) {
          for (final it in items) {
            if (it is Map) {
              final iName = it['name'] as String? ?? 'Item';
              final qty = (it['amount'] as num?)?.toInt() ?? 1;
              final isEq = it['equipped'] == true;
              inventoryList.add({
                'id': const Uuid().v4(),
                'name': iName,
                'quantity': qty,
                'weight': 1.0,
                'isEquipped': isEq,
                'isAttuned': false,
                'containerName': isEq ? 'Equipped' : 'Backpack',
                'itemData': {'category': catKey},
              });
            }
          }
        }
      });

      return {
        'format': backupFormatTag,
        'schemaVersion': currentSchemaVersion,
        'exportedAt': DateTime.now().toUtc().toIso8601String(),
        'character': {
          'id': charData['id'] as String? ?? const Uuid().v4(),
          'name': name,
          'systemId': 'dnd5e',
          'portraitUri': null,
          'rawProperties': {
            'level': level,
            'class': className,
            'race': raceName,
            'background': bgName,
            'hp': {'current': currentHp, 'max': maxHp, 'temp': tempHp},
            'armorClass': ac,
            'speed': raceName.toLowerCase().contains('wood elf') ? 35 : 30,
            'proficiencyBonus': profBonus,
            'abilities': abilityScores,
            'savingThrows': saves,
            'skills': skillsList,
            'skillProficiencies': skillProfs,
            'spells': spellsList,
            'featuresList': featuresList,
            'hitDice': {'total': level, 'spent': 0, 'die': '1d$hitDie'},
            'currency': currency,
            'bio': {
              'backstory': personality['backstory']?.toString() ?? '',
              'sessionNotes': 'Imported from Character Keep',
            },
          },
          'notes': 'Imported from Character Keep',
        },
        'conditions': [],
        'inventory': inventoryList,
      };
    }

    return raw;
  }
}

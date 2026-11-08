import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/database/app_database.dart';

/// Lightweight summary model representing a character for home screen widgets.
class CharacterWidgetSummary {
  final String id;
  final String name;
  final String classLevel;
  final int currentHp;
  final int maxHp;

  const CharacterWidgetSummary({
    required this.id,
    required this.name,
    required this.classLevel,
    required this.currentHp,
    required this.maxHp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'classLevel': classLevel,
    'currentHp': currentHp,
    'maxHp': maxHp,
  };

  factory CharacterWidgetSummary.fromJson(Map<String, dynamic> json) =>
      CharacterWidgetSummary(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Hero',
        classLevel: json['classLevel'] as String? ?? 'Adventurer',
        currentHp: (json['currentHp'] as num?)?.toInt() ?? 10,
        maxHp: (json['maxHp'] as num?)?.toInt() ?? 10,
      );

  /// Constructs a [CharacterWidgetSummary] from Drift [CharactersTableData].
  static CharacterWidgetSummary fromCharacterData(
    CharactersTableData character,
  ) {
    Map<String, dynamic> props = {};
    try {
      if (character.rawPropertiesJson.isNotEmpty) {
        props = jsonDecode(character.rawPropertiesJson) as Map<String, dynamic>;
      }
    } catch (_) {}

    final className =
        props['className']?.toString() ?? props['class']?.toString() ?? '';
    final race = props['race']?.toString() ?? '';
    final level = props['level']?.toString() ?? '1';
    int currentHp = 10;
    int maxHp = 10;

    final hpRaw = props['hp'];
    if (hpRaw is Map) {
      currentHp = (hpRaw['current'] as num?)?.toInt() ?? 10;
      maxHp = (hpRaw['max'] as num?)?.toInt() ?? currentHp;
    } else if (hpRaw is num) {
      currentHp = hpRaw.toInt();
      maxHp = currentHp;
    }

    if (props['currentHp'] is num) {
      currentHp = (props['currentHp'] as num).toInt();
    }
    if (props['maxHp'] is num) {
      maxHp = (props['maxHp'] as num).toInt();
    } else if (props['hpMax'] is num) {
      maxHp = (props['hpMax'] as num).toInt();
    }

    final classLevelParts = <String>[];
    if (race.isNotEmpty) classLevelParts.add(race);
    if (className.isNotEmpty) {
      classLevelParts.add('$className $level');
    } else if (race.isEmpty) {
      classLevelParts.add('Adventurer');
    } else {
      classLevelParts.add('Level $level');
    }

    return CharacterWidgetSummary(
      id: character.id,
      name: character.name.isNotEmpty ? character.name : 'Unnamed Hero',
      classLevel: classLevelParts.join(' • '),
      currentHp: currentHp,
      maxHp: maxHp < 1 ? 1 : maxHp,
    );
  }
}

/// Service that synchronizes character data with Android home screen widgets.
class CharacterWidgetSyncService {
  static const String characterSummaryKey = 'character_summary_list';
  static const String characterWidgetProvider = 'CharacterWidgetProvider';

  /// Synchronizes a list of characters to widget shared storage and requests a widget update.
  static Future<void> syncAll(List<CharactersTableData> characters) async {
    try {
      final summaries = characters
          .map(CharacterWidgetSummary.fromCharacterData)
          .toList();
      final jsonStr = jsonEncode(summaries.map((s) => s.toJson()).toList());

      await HomeWidget.saveWidgetData<String>(characterSummaryKey, jsonStr);

      for (final summary in summaries) {
        await _saveCharacterFields(summary);
      }

      await HomeWidget.updateWidget(name: characterWidgetProvider);
    } catch (e) {
      debugPrint('CharacterWidgetSyncService.syncAll error: $e');
    }
  }

  /// Synchronizes a single character's data to widget shared storage.
  static Future<void> syncCharacter(CharactersTableData character) async {
    try {
      final summary = CharacterWidgetSummary.fromCharacterData(character);
      await _saveCharacterFields(summary);
      await HomeWidget.updateWidget(name: characterWidgetProvider);
    } catch (e) {
      debugPrint('CharacterWidgetSyncService.syncCharacter error: $e');
    }
  }

  static Future<void> _saveCharacterFields(
    CharacterWidgetSummary summary,
  ) async {
    await HomeWidget.saveWidgetData<String>(
      'character_${summary.id}_name',
      summary.name,
    );
    await HomeWidget.saveWidgetData<String>(
      'character_${summary.id}_class_level',
      summary.classLevel,
    );
    await HomeWidget.saveWidgetData<int>(
      'character_${summary.id}_current_hp',
      summary.currentHp,
    );
    await HomeWidget.saveWidgetData<int>(
      'character_${summary.id}_max_hp',
      summary.maxHp,
    );
  }
}

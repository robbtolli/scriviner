import 'dart:convert';

/// Represents a declarative, sandboxed plugin package for Scrivener.
/// Homebrew compendiums, custom systems, and themes declare entities safely
/// without running arbitrary executable code.
class PluginManifest {
  final String id;
  final String name;
  final String version;
  final String author;
  final String targetSystem;
  final String type; // 'compendium', 'theme', 'system'
  final String description;
  final Map<String, dynamic> entities;

  const PluginManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.author,
    required this.targetSystem,
    this.type = 'compendium',
    this.description = '',
    this.entities = const {},
  });

  /// Total count of all packaged entities across spells, items, and features.
  int get totalEntityCount {
    int count = 0;
    entities.forEach((_, value) {
      if (value is List) {
        count += value.length;
      }
    });
    return count;
  }

  /// Validates that required manifest fields are present and well-formed.
  void validate() {
    if (id.trim().isEmpty) {
      throw const FormatException('Plugin manifest missing required field: id');
    }
    if (name.trim().isEmpty) {
      throw const FormatException('Plugin manifest missing required field: name');
    }
    if (version.trim().isEmpty) {
      throw const FormatException('Plugin manifest missing required field: version');
    }
    if (targetSystem.trim().isEmpty) {
      throw const FormatException('Plugin manifest missing required field: targetSystem');
    }
  }

  factory PluginManifest.fromJson(Map<String, dynamic> json) {
    final manifest = PluginManifest(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      version: json['version'] as String? ?? '1.0.0',
      author: json['author'] as String? ?? 'Unknown Author',
      targetSystem: json['targetSystem'] as String? ?? 'dnd5e',
      type: json['type'] as String? ?? 'compendium',
      description: json['description'] as String? ?? '',
      entities: (json['entities'] as Map<String, dynamic>?) ?? {},
    );
    manifest.validate();
    return manifest;
  }

  /// Parses a plugin manifest from a raw string (handling potential JSON codeblock wrapping).
  factory PluginManifest.parse(String rawContent) {
    String cleaned = rawContent.trim();
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
      throw const FormatException('Plugin manifest must be a JSON object');
    }
    return PluginManifest.fromJson(decoded);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'author': author,
      'targetSystem': targetSystem,
      'type': type,
      'description': description,
      'entities': entities,
    };
  }
}

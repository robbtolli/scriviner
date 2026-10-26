import 'dart:convert';

/// Strongly typed representation of an SRD or homebrew compendium entry.
class CompendiumEntry {
  final String id;
  final String systemId;
  final String category; // 'spell', 'equipment', 'feature', 'rule'
  final String name;
  final String summary;
  final Map<String, dynamic> data;

  const CompendiumEntry({
    required this.id,
    this.systemId = 'dnd5e',
    required this.category,
    required this.name,
    this.summary = '',
    this.data = const {},
  });

  // Helpers for spells
  int get spellLevel => (data['level'] as num?)?.toInt() ?? 0;
  String get school => data['school'] as String? ?? 'Evocation';
  String get castingTime => data['castingTime'] as String? ?? '1 action';
  String get range => data['range'] as String? ?? 'Self';
  String get components => data['components'] as String? ?? 'V, S';
  String get duration => data['duration'] as String? ?? 'Instantaneous';
  bool get isRitual => (data['ritual'] as bool?) ?? false;
  String get description => data['description'] as String? ?? summary;

  // Helpers for equipment / items
  double get weight => (data['weight'] as num?)?.toDouble() ?? 0.0;
  String get cost => data['cost'] as String? ?? '—';
  String get damage => data['damage'] as String? ?? '';
  int get armorClass => (data['armorClass'] as num?)?.toInt() ?? 0;
  bool get isArmor => data['isArmor'] as bool? ?? false;
  bool get isShield => data['isShield'] as bool? ?? false;

  Map<String, dynamic> toJson() => {
    'id': id,
    'systemId': systemId,
    'category': category,
    'name': name,
    'summary': summary,
    'data': data,
  };

  factory CompendiumEntry.fromJson(Map<String, dynamic> json) {
    return CompendiumEntry(
      id: json['id'] as String,
      systemId: json['systemId'] as String? ?? 'dnd5e',
      category: json['category'] as String,
      name: json['name'] as String,
      summary: json['summary'] as String? ?? '',
      data: json['data'] is Map
          ? Map<String, dynamic>.from(json['data'] as Map)
          : (json['fullDataJson'] != null && json['fullDataJson'] is String
                ? Map<String, dynamic>.from(
                    jsonDecode(json['fullDataJson'] as String) as Map,
                  )
                : {}),
    );
  }
}

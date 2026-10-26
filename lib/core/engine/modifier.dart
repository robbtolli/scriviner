/// Types of operations that can modify a property.
enum ModifierOperation {
  /// Adds a numeric value to the base value.
  add,

  /// Multiplies the value by a factor.
  multiply,

  /// Completely overrides the value (e.g., Belt of Hill Giant Strength setting STR to 21).
  override,

  /// Adds a situational dice expression (e.g., +1d4 from Bless).
  diceBonus,
}

/// Standard execution priorities for modifiers. Lower priorities execute first.
class ModifierPriority {
  const ModifierPriority._();

  static const int base = 10;
  static const int featOrClass = 20;
  static const int equipment = 30;
  static const int activeBuff = 40;
  static const int situational = 50;
}

/// Represents an active or passive modifier modifying a character property.
class Modifier {
  final String id;
  final String targetProperty;
  final ModifierOperation operation;
  final dynamic value;
  final String source;
  final int priority;
  final bool isEnabled;

  const Modifier({
    required this.id,
    required this.targetProperty,
    required this.operation,
    required this.value,
    required this.source,
    this.priority = ModifierPriority.equipment,
    this.isEnabled = true,
  });

  Modifier copyWith({
    String? id,
    String? targetProperty,
    ModifierOperation? operation,
    dynamic value,
    String? source,
    int? priority,
    bool? isEnabled,
  }) {
    return Modifier(
      id: id ?? this.id,
      targetProperty: targetProperty ?? this.targetProperty,
      operation: operation ?? this.operation,
      value: value ?? this.value,
      source: source ?? this.source,
      priority: priority ?? this.priority,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetProperty': targetProperty,
      'operation': operation.name,
      'value': value,
      'source': source,
      'priority': priority,
      'isEnabled': isEnabled,
    };
  }

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      id: json['id'] as String,
      targetProperty: json['targetProperty'] as String,
      operation: ModifierOperation.values.byName(json['operation'] as String),
      value: json['value'],
      source: json['source'] as String,
      priority:
          (json['priority'] as num?)?.toInt() ?? ModifierPriority.equipment,
      isEnabled: (json['isEnabled'] as bool?) ?? true,
    );
  }

  @override
  String toString() =>
      'Modifier($id: $targetProperty ${operation.name} $value from "$source")';
}

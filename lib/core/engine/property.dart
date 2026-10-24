import 'modifier.dart';

/// Represents a resolved property with its key path, base value,
/// computed value, and the list of modifiers applied to it.
class Property<T> {
  final String path;
  final T baseValue;
  final T value;
  final List<Modifier> appliedModifiers;
  final List<String> situationalDice;

  const Property({
    required this.path,
    required this.baseValue,
    required this.value,
    this.appliedModifiers = const [],
    this.situationalDice = const [],
  });

  Property<T> copyWith({
    String? path,
    T? baseValue,
    T? value,
    List<Modifier>? appliedModifiers,
    List<String>? situationalDice,
  }) {
    return Property<T>(
      path: path ?? this.path,
      baseValue: baseValue ?? this.baseValue,
      value: value ?? this.value,
      appliedModifiers: appliedModifiers ?? this.appliedModifiers,
      situationalDice: situationalDice ?? this.situationalDice,
    );
  }

  @override
  String toString() => 'Property($path: $value [base: $baseValue])';
}

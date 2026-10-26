import 'formula_evaluator.dart';
import 'modifier.dart';
import 'property.dart';

/// Container for the fully resolved property values and applied modifiers of a character.
class ResolvedCharacterState {
  final Map<String, Property<dynamic>> properties;

  const ResolvedCharacterState(this.properties);

  /// Retrieves the typed value of a property, or [defaultValue] if not found or incompatible.
  T? getValue<T>(String path, [T? defaultValue]) {
    final prop = properties[path];
    if (prop == null) return defaultValue;
    if (prop.value is T) return prop.value as T;
    return defaultValue;
  }

  /// Convenience method to retrieve an integer property.
  int getInt(String path, {int defaultValue = 0}) {
    final val = properties[path]?.value;
    if (val is int) return val;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? defaultValue;
    return defaultValue;
  }

  /// Convenience method to retrieve a double property.
  double getDouble(String path, {double defaultValue = 0.0}) {
    final val = properties[path]?.value;
    if (val is double) return val;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? defaultValue;
    return defaultValue;
  }

  /// Convenience method to retrieve a string property.
  String getString(String path, {String defaultValue = ''}) {
    final val = properties[path]?.value;
    if (val == null) return defaultValue;
    return val.toString();
  }

  /// Retrieves any situational dice bonuses active on this property (e.g., `["1d4"]` from Bless).
  List<String> getSituationalDice(String path) {
    return properties[path]?.situationalDice ?? const [];
  }

  /// Retrieves all modifiers applied to a given property.
  List<Modifier> getModifiersFor(String path) {
    return properties[path]?.appliedModifiers ?? const [];
  }

  /// Exports all resolved properties as a simple key-value map.
  Map<String, dynamic> toMap() {
    return properties.map((k, v) => MapEntry(k, v.value));
  }
}

/// Executes the staged Property-Modifier pipeline and formula evaluations.
class PropertyPipeline {
  /// Computes the final resolved character properties given base values, modifiers, and formula rules.
  static ResolvedCharacterState resolve({
    required Map<String, dynamic> baseProperties,
    required List<Modifier> modifiers,
    Map<String, String> formulaRules = const {},
  }) {
    final resolvedMap = <String, Property<dynamic>>{};
    final workingValues = Map<String, dynamic>.from(baseProperties);

    // Group active modifiers by target property
    final activeModifiers = modifiers.where((m) => m.isEnabled).toList();
    // Sort modifiers strictly by priority ascending
    activeModifiers.sort((a, b) => a.priority.compareTo(b.priority));

    final modifiersByTarget = <String, List<Modifier>>{};
    for (final mod in activeModifiers) {
      modifiersByTarget.putIfAbsent(mod.targetProperty, () => []).add(mod);
    }

    // 1. Resolve all base properties + direct modifiers
    final allKeys = {...baseProperties.keys, ...modifiersByTarget.keys};

    for (final key in allKeys) {
      final baseVal = baseProperties[key];
      dynamic currentVal = baseVal;
      final applied = <Modifier>[];
      final situationalDice = <String>[];

      final mods = modifiersByTarget[key] ?? const [];
      for (final mod in mods) {
        applied.add(mod);
        switch (mod.operation) {
          case ModifierOperation.override:
            currentVal = mod.value;
            break;
          case ModifierOperation.add:
            if (currentVal is num && mod.value is num) {
              currentVal = currentVal + (mod.value as num);
            } else if (currentVal == null && mod.value is num) {
              currentVal = mod.value;
            }
            break;
          case ModifierOperation.multiply:
            if (currentVal is num && mod.value is num) {
              currentVal = currentVal * (mod.value as num);
            }
            break;
          case ModifierOperation.diceBonus:
            situationalDice.add(mod.value.toString());
            break;
        }
      }

      workingValues[key] = currentVal;
      resolvedMap[key] = Property(
        path: key,
        baseValue: baseVal,
        value: currentVal,
        appliedModifiers: applied,
        situationalDice: situationalDice,
      );
    }

    // 2. Evaluate derived formulas
    if (formulaRules.isNotEmpty) {
      // Iterative resolution: resolve formulas whose dependencies are met
      final pendingFormulas = Map<String, String>.from(formulaRules);
      int maxIterations = pendingFormulas.length + 5;

      while (pendingFormulas.isNotEmpty && maxIterations > 0) {
        maxIterations--;
        final resolvedThisRound = <String>[];

        for (final entry in pendingFormulas.entries) {
          final targetKey = entry.key;
          final formula = entry.value;
          final deps = FormulaEvaluator.extractDependencies(formula);

          // Check if all dependencies are currently available in workingValues
          final canResolve = deps.every(
            (dep) => workingValues.containsKey(dep),
          );
          if (canResolve || maxIterations == 0) {
            try {
              final computedValue = FormulaEvaluator.evaluate(
                formula,
                workingValues,
              );
              workingValues[targetKey] = computedValue;

              // Also apply any modifiers targeting this formula property
              dynamic finalValue = computedValue;
              final applied = <Modifier>[];
              final situationalDice = <String>[];
              final mods = modifiersByTarget[targetKey] ?? const [];

              for (final mod in mods) {
                applied.add(mod);
                switch (mod.operation) {
                  case ModifierOperation.override:
                    finalValue = mod.value;
                    break;
                  case ModifierOperation.add:
                    if (finalValue is num && mod.value is num) {
                      finalValue = finalValue + (mod.value as num);
                    }
                    break;
                  case ModifierOperation.multiply:
                    if (finalValue is num && mod.value is num) {
                      finalValue = finalValue * (mod.value as num);
                    }
                    break;
                  case ModifierOperation.diceBonus:
                    situationalDice.add(mod.value.toString());
                    break;
                }
              }

              workingValues[targetKey] = finalValue;
              resolvedMap[targetKey] = Property(
                path: targetKey,
                baseValue: computedValue,
                value: finalValue,
                appliedModifiers: applied,
                situationalDice: situationalDice,
              );
              resolvedThisRound.add(targetKey);
            } catch (_) {
              // Defer to next iteration if formula evaluation failed
            }
          }
        }

        for (final resolved in resolvedThisRound) {
          pendingFormulas.remove(resolved);
        }

        if (resolvedThisRound.isEmpty) {
          // Circular dependency or missing property
          break;
        }
      }
    }

    return ResolvedCharacterState(resolvedMap);
  }
}

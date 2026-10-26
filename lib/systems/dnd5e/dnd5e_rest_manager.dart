import 'dart:math';

/// Handles short and long rest mechanics and resource restoration for D&D 5e characters.
class Dnd5eRestManager {
  const Dnd5eRestManager._();

  /// Executes a Short Rest:
  /// - Restores hit points from rolled hit dice (up to max HP).
  /// - Updates spent hit dice.
  /// - Recharges short-rest features (e.g. Warlock pact slots, Second Wind).
  static Map<String, dynamic> applyShortRest({
    required Map<String, dynamic> properties,
    required int hitDiceSpent,
    required int hitPointsRecovered,
  }) {
    final updated = Map<String, dynamic>.from(properties);

    // 1. Update HP
    final hp = Map<String, dynamic>.from(updated['hp'] as Map? ?? {});
    final currentHp = (hp['current'] as num?)?.toInt() ?? 10;
    final maxHp = (hp['max'] as num?)?.toInt() ?? 10;
    hp['current'] = min(maxHp, currentHp + hitPointsRecovered);
    updated['hp'] = hp;

    // 2. Update Hit Dice
    final hitDice = Map<String, dynamic>.from(updated['hitDice'] as Map? ?? {});
    final spent = (hitDice['spent'] as num?)?.toInt() ?? 0;
    final total = (hitDice['total'] as num?)?.toInt() ?? 1;
    hitDice['spent'] = min(total, spent + hitDiceSpent);
    updated['hitDice'] = hitDice;

    // 3. Recharge Short-Rest features (like Second Wind / Pact slots)
    final features = Map<String, dynamic>.from(
      updated['features'] as Map? ?? {},
    );
    if (features.containsKey('secondWind')) {
      features['secondWind'] = true; // Available again
    }
    updated['features'] = features;

    // Reset pact slots if warlock
    final spellSlots = Map<String, dynamic>.from(
      updated['spellSlots'] as Map? ?? {},
    );
    if (spellSlots.containsKey('pact')) {
      final pact = Map<String, dynamic>.from(spellSlots['pact'] as Map? ?? {});
      pact['spent'] = 0;
      spellSlots['pact'] = pact;
      updated['spellSlots'] = spellSlots;
    }

    return updated;
  }

  /// Executes a Long Rest (8 hours):
  /// - Restores all hit points to maximum.
  /// - Clears all temporary hit points.
  /// - Recovers up to half of max Hit Dice (minimum 1 die).
  /// - Restores all spell slots (levels 1-9 and pact slots).
  /// - Resets all class features and death saves.
  static Map<String, dynamic> applyLongRest({
    required Map<String, dynamic> properties,
  }) {
    final updated = Map<String, dynamic>.from(properties);

    // 1. Full HP restoration
    final hp = Map<String, dynamic>.from(updated['hp'] as Map? ?? {});
    final maxHp = (hp['max'] as num?)?.toInt() ?? 10;
    hp['current'] = maxHp;
    hp['temp'] = 0;
    updated['hp'] = hp;

    // 2. Hit Dice recovery: half of total (minimum 1)
    final hitDice = Map<String, dynamic>.from(updated['hitDice'] as Map? ?? {});
    final totalDice = (hitDice['total'] as num?)?.toInt() ?? 1;
    final currentlySpent = (hitDice['spent'] as num?)?.toInt() ?? 0;
    final recoverCount = max(1, (totalDice / 2).floor());
    hitDice['spent'] = max(0, currentlySpent - recoverCount);
    updated['hitDice'] = hitDice;

    // 3. Reset all spell slots
    final rawSpellSlots = updated['spellSlots'] as Map? ?? {};
    final resetSlots = <String, dynamic>{};
    rawSpellSlots.forEach((key, val) {
      if (val is Map) {
        final slotMap = Map<String, dynamic>.from(val);
        slotMap['spent'] = 0;
        resetSlots[key.toString()] = slotMap;
      }
    });
    updated['spellSlots'] = resetSlots;

    // 4. Reset features
    final features = Map<String, dynamic>.from(
      updated['features'] as Map? ?? {},
    );
    features['secondWind'] = true;
    updated['features'] = features;

    // 5. Reset death saves
    updated['deathSaves'] = {'successes': 0, 'failures': 0};

    return updated;
  }
}

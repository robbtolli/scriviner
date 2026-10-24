import 'dart:convert';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../systems/dnd5e/dnd5e_rest_manager.dart';

class SpellSlotInfo {
  final int total;
  final int spent;

  const SpellSlotInfo({required this.total, required this.spent});

  int get available => max(0, total - spent);

  SpellSlotInfo copyWith({int? total, int? spent}) {
    return SpellSlotInfo(
      total: total ?? this.total,
      spent: spent ?? this.spent,
    );
  }
}

class WeaponAttackInfo {
  final String name;
  final String type;
  final int toHit;
  final String damageFormula;

  const WeaponAttackInfo({
    required this.name,
    required this.type,
    required this.toHit,
    required this.damageFormula,
  });
}

class CombatSessionState {
  final String characterId;
  final String name;
  final String className;
  final String raceName;
  final int level;
  final int currentHp;
  final int maxHp;
  final int tempHp;
  final int armorClass;
  final int speed;
  final int initiative;
  final int hitDiceTotal;
  final int hitDiceSpent;
  final String hitDiceDie;
  final int deathSaveSuccesses;
  final int deathSaveFailures;
  final Map<String, SpellSlotInfo> spellSlots;
  final Set<String> activeConditions;
  final List<WeaponAttackInfo> weapons;
  final bool hasSecondWind;

  const CombatSessionState({
    required this.characterId,
    required this.name,
    required this.className,
    required this.raceName,
    this.level = 1,
    this.currentHp = 10,
    this.maxHp = 10,
    this.tempHp = 0,
    this.armorClass = 10,
    this.speed = 30,
    this.initiative = 0,
    this.hitDiceTotal = 1,
    this.hitDiceSpent = 0,
    this.hitDiceDie = '1d10',
    this.deathSaveSuccesses = 0,
    this.deathSaveFailures = 0,
    this.spellSlots = const {},
    this.activeConditions = const {},
    this.weapons = const [],
    this.hasSecondWind = true,
  });

  bool get isConscious => currentHp > 0;
  bool get isDying => currentHp == 0 && deathSaveFailures < 3 && deathSaveSuccesses < 3;
  bool get isStabilized => currentHp == 0 && deathSaveSuccesses >= 3;
  bool get isDead => deathSaveFailures >= 3;
  int get availableHitDice => max(0, hitDiceTotal - hitDiceSpent);

  CombatSessionState copyWith({
    int? currentHp,
    int? maxHp,
    int? tempHp,
    int? hitDiceSpent,
    int? deathSaveSuccesses,
    int? deathSaveFailures,
    Map<String, SpellSlotInfo>? spellSlots,
    Set<String>? activeConditions,
    bool? hasSecondWind,
  }) {
    return CombatSessionState(
      characterId: characterId,
      name: name,
      className: className,
      raceName: raceName,
      level: level,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      tempHp: tempHp ?? this.tempHp,
      armorClass: armorClass,
      speed: speed,
      initiative: initiative,
      hitDiceTotal: hitDiceTotal,
      hitDiceSpent: hitDiceSpent ?? this.hitDiceSpent,
      hitDiceDie: hitDiceDie,
      deathSaveSuccesses: deathSaveSuccesses ?? this.deathSaveSuccesses,
      deathSaveFailures: deathSaveFailures ?? this.deathSaveFailures,
      spellSlots: spellSlots ?? this.spellSlots,
      activeConditions: activeConditions ?? this.activeConditions,
      weapons: weapons,
      hasSecondWind: hasSecondWind ?? this.hasSecondWind,
    );
  }
}

class CombatSessionNotifier extends Notifier<CombatSessionState?> {
  final String characterId;

  CombatSessionNotifier(this.characterId);

  @override
  CombatSessionState? build() {
    // Initial async load
    _loadFromDatabase(characterId);
    return null;
  }

  Future<void> _loadFromDatabase(String charId) async {
    final db = ref.read(databaseProvider);
    final char = await db.getCharacter(charId);
    if (char == null) return;

    Map<String, dynamic> raw = {};
    try {
      raw = jsonDecode(char.rawPropertiesJson) as Map<String, dynamic>;
    } catch (_) {}

    final hp = raw['hp'] as Map? ?? {};
    final currentHp = (hp['current'] as num?)?.toInt() ?? 10;
    final maxHp = (hp['max'] as num?)?.toInt() ?? 10;
    final tempHp = (hp['temp'] as num?)?.toInt() ?? 0;

    final hitDice = raw['hitDice'] as Map? ?? {};
    final hdTotal = (hitDice['total'] as num?)?.toInt() ?? 1;
    final hdSpent = (hitDice['spent'] as num?)?.toInt() ?? 0;
    final hdDie = hitDice['die'] as String? ?? '1d10';

    final deathSaves = raw['deathSaves'] as Map? ?? {};
    final dSuccess = (deathSaves['successes'] as num?)?.toInt() ?? 0;
    final dFailures = (deathSaves['failures'] as num?)?.toInt() ?? 0;

    final rawSlots = raw['spellSlots'] as Map? ?? {};
    final slotsMap = <String, SpellSlotInfo>{};
    rawSlots.forEach((k, v) {
      if (v is Map) {
        String keyStr = k.toString();
        if (keyStr.toLowerCase().startsWith('level')) {
          keyStr = keyStr.toLowerCase().replaceFirst('level', '');
        }
        slotsMap[keyStr] = SpellSlotInfo(
          total: (v['total'] as num?)?.toInt() ?? 0,
          spent: (v['spent'] as num?)?.toInt() ?? 0,
        );
      }
    });

    final conditions = Set<String>.from(
      (raw['activeConditions'] as List? ?? []).map((e) => e.toString()),
    );

    final abilities = raw['abilities'] as Map? ?? {};
    final strMod = ((abilities['str']?['mod'] as num?)?.toInt()) ?? 2;
    final dexMod = ((abilities['dex']?['mod'] as num?)?.toInt()) ?? 1;

    final weapons = <WeaponAttackInfo>[
      WeaponAttackInfo(
        name: 'Main Weapon (Melee)',
        type: 'Melee',
        toHit: strMod + 2,
        damageFormula: '1d8 + $strMod',
      ),
      WeaponAttackInfo(
        name: 'Secondary / Ranged',
        type: 'Ranged',
        toHit: dexMod + 2,
        damageFormula: '1d6 + $dexMod',
      ),
    ];

    state = CombatSessionState(
      characterId: charId,
      name: char.name,
      className: raw['class'] ?? 'Adventurer',
      raceName: raw['race'] ?? 'Hero',
      level: (raw['level'] as num?)?.toInt() ?? 1,
      currentHp: currentHp,
      maxHp: maxHp,
      tempHp: tempHp,
      armorClass: (raw['armorClass'] as num?)?.toInt() ?? 10,
      speed: (raw['speed'] as num?)?.toInt() ?? 30,
      initiative: dexMod,
      hitDiceTotal: hdTotal,
      hitDiceSpent: hdSpent,
      hitDiceDie: hdDie,
      deathSaveSuccesses: dSuccess,
      deathSaveFailures: dFailures,
      spellSlots: slotsMap,
      activeConditions: conditions,
      weapons: weapons,
      hasSecondWind: (raw['features']?['secondWind'] as bool?) ?? true,
    );
  }

  /// Applies damage: temp HP absorbs first, then reduces current HP.
  void applyDamage(int amount) {
    if (state == null || amount <= 0) return;

    int remainingDamage = amount;
    int newTempHp = state!.tempHp;

    if (newTempHp > 0) {
      if (newTempHp >= remainingDamage) {
        newTempHp -= remainingDamage;
        remainingDamage = 0;
      } else {
        remainingDamage -= newTempHp;
        newTempHp = 0;
      }
    }

    final newCurrentHp = max(0, state!.currentHp - remainingDamage);

    state = state!.copyWith(
      tempHp: newTempHp,
      currentHp: newCurrentHp,
    );
    _persistToDatabase();
  }

  /// Applies healing up to max HP. Resets death saves if revived from 0.
  void applyHealing(int amount) {
    if (state == null || amount <= 0) return;

    final wasAtZero = state!.currentHp == 0;
    final newHp = min(state!.maxHp, state!.currentHp + amount);

    state = state!.copyWith(
      currentHp: newHp,
      deathSaveSuccesses: wasAtZero ? 0 : state!.deathSaveSuccesses,
      deathSaveFailures: wasAtZero ? 0 : state!.deathSaveFailures,
    );
    _persistToDatabase();
  }

  void setTempHp(int amount) {
    if (state == null) return;
    state = state!.copyWith(tempHp: max(0, amount));
    _persistToDatabase();
  }

  void recordDeathSave({
    required bool isSuccess,
    bool isCritSuccess = false,
    bool isCritFailure = false,
  }) {
    if (state == null) return;

    if (isCritSuccess) {
      // Natural 20 restores 1 HP!
      state = state!.copyWith(
        currentHp: 1,
        deathSaveSuccesses: 0,
        deathSaveFailures: 0,
      );
    } else if (isCritFailure) {
      // Natural 1 marks 2 failures
      state = state!.copyWith(
        deathSaveFailures: min(3, state!.deathSaveFailures + 2),
      );
    } else if (isSuccess) {
      state = state!.copyWith(
        deathSaveSuccesses: min(3, state!.deathSaveSuccesses + 1),
      );
    } else {
      state = state!.copyWith(
        deathSaveFailures: min(3, state!.deathSaveFailures + 1),
      );
    }
    _persistToDatabase();
  }

  void resetDeathSaves() {
    if (state == null) return;
    state = state!.copyWith(deathSaveSuccesses: 0, deathSaveFailures: 0);
    _persistToDatabase();
  }

  void toggleSpellSlot(String slotKey, int slotIndex) {
    if (state == null) return;

    final currentSlot = state!.spellSlots[slotKey];
    if (currentSlot == null) return;

    final isCurrentlySpent = slotIndex < currentSlot.spent;
    final newSpent = isCurrentlySpent ? currentSlot.spent - 1 : currentSlot.spent + 1;

    final updatedSlots = Map<String, SpellSlotInfo>.from(state!.spellSlots);
    updatedSlots[slotKey] = currentSlot.copyWith(spent: newSpent.clamp(0, currentSlot.total));

    state = state!.copyWith(spellSlots: updatedSlots);
    _persistToDatabase();
  }

  void toggleCondition(String conditionId) {
    if (state == null) return;

    final updated = Set<String>.from(state!.activeConditions);
    if (updated.contains(conditionId)) {
      updated.remove(conditionId);
    } else {
      updated.add(conditionId);
    }

    state = state!.copyWith(activeConditions: updated);
    _persistToDatabase();
  }

  void useSecondWind() {
    if (state == null || !state!.hasSecondWind) return;
    state = state!.copyWith(hasSecondWind: false);
    _persistToDatabase();
  }

  void shortRest({required int hitDiceSpent, required int hitPointsRecovered}) {
    if (state == null) return;

    final raw = _extractRawMap();
    final updated = Dnd5eRestManager.applyShortRest(
      properties: raw,
      hitDiceSpent: hitDiceSpent,
      hitPointsRecovered: hitPointsRecovered,
    );

    _applyRawMapToState(updated);
    _persistToDatabase();
  }

  void longRest() {
    if (state == null) return;

    final raw = _extractRawMap();
    final updated = Dnd5eRestManager.applyLongRest(properties: raw);

    _applyRawMapToState(updated);
    _persistToDatabase();
  }

  Map<String, dynamic> _extractRawMap() {
    return {
      'level': state!.level,
      'hp': {
        'current': state!.currentHp,
        'max': state!.maxHp,
        'temp': state!.tempHp,
      },
      'hitDice': {
        'total': state!.hitDiceTotal,
        'spent': state!.hitDiceSpent,
        'die': state!.hitDiceDie,
      },
      'deathSaves': {
        'successes': state!.deathSaveSuccesses,
        'failures': state!.deathSaveFailures,
      },
      'spellSlots': state!.spellSlots.map(
        (k, v) => MapEntry(k, {'total': v.total, 'spent': v.spent}),
      ),
      'activeConditions': state!.activeConditions.toList(),
      'features': {
        'secondWind': state!.hasSecondWind,
      },
    };
  }

  void _applyRawMapToState(Map<String, dynamic> raw) {
    final hp = raw['hp'] as Map? ?? {};
    final hitDice = raw['hitDice'] as Map? ?? {};
    final deathSaves = raw['deathSaves'] as Map? ?? {};

    final rawSlots = raw['spellSlots'] as Map? ?? {};
    final slotsMap = <String, SpellSlotInfo>{};
    rawSlots.forEach((k, v) {
      if (v is Map) {
        String keyStr = k.toString();
        if (keyStr.toLowerCase().startsWith('level')) {
          keyStr = keyStr.toLowerCase().replaceFirst('level', '');
        }
        slotsMap[keyStr] = SpellSlotInfo(
          total: (v['total'] as num?)?.toInt() ?? 0,
          spent: (v['spent'] as num?)?.toInt() ?? 0,
        );
      }
    });

    state = state!.copyWith(
      currentHp: (hp['current'] as num?)?.toInt() ?? state!.currentHp,
      maxHp: (hp['max'] as num?)?.toInt() ?? state!.maxHp,
      tempHp: (hp['temp'] as num?)?.toInt() ?? 0,
      hitDiceSpent: (hitDice['spent'] as num?)?.toInt() ?? state!.hitDiceSpent,
      deathSaveSuccesses: (deathSaves['successes'] as num?)?.toInt() ?? 0,
      deathSaveFailures: (deathSaves['failures'] as num?)?.toInt() ?? 0,
      spellSlots: slotsMap,
      hasSecondWind: (raw['features']?['secondWind'] as bool?) ?? true,
    );
  }

  Future<void> _persistToDatabase() async {
    if (state == null) return;
    final db = ref.read(databaseProvider);
    final char = await db.getCharacter(state!.characterId);
    if (char == null) return;

    Map<String, dynamic> raw = {};
    try {
      raw = jsonDecode(char.rawPropertiesJson) as Map<String, dynamic>;
    } catch (_) {}

    raw['hp'] = {
      'current': state!.currentHp,
      'max': state!.maxHp,
      'temp': state!.tempHp,
    };
    raw['hitDice'] = {
      'total': state!.hitDiceTotal,
      'spent': state!.hitDiceSpent,
      'die': state!.hitDiceDie,
    };
    raw['deathSaves'] = {
      'successes': state!.deathSaveSuccesses,
      'failures': state!.deathSaveFailures,
    };
    raw['spellSlots'] = state!.spellSlots.map(
      (k, v) => MapEntry(k, {'total': v.total, 'spent': v.spent}),
    );
    raw['activeConditions'] = state!.activeConditions.toList();
    raw['features'] = {
      'secondWind': state!.hasSecondWind,
    };

    await db.upsertCharacter(
      char.toCompanion(true).copyWith(
        rawPropertiesJson: Value(jsonEncode(raw)),
        lastPlayedAt: Value(DateTime.now()),
      ),
    );
  }
}

final combatSessionProvider =
    NotifierProvider.family<CombatSessionNotifier, CombatSessionState?, String>(
  CombatSessionNotifier.new,
);

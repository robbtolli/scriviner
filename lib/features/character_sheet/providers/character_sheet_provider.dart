import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../character_wizard/models/srd_starter_data.dart';
import '../../combat/providers/combat_session_provider.dart';
import '../models/character_sheet_data.dart';

class CharacterSheetState {
  final String characterId;
  final String name;
  final String className;
  final String raceName;
  final int level;
  final int proficiencyBonus;
  final String spellcastingAbility;
  final int spellcastingMod;
  final int strengthScore;
  final int dexterityMod;
  final int armorClass;
  final Map<String, int> abilityScores;
  final Set<String> savingThrowProficiencies;
  final Map<String, int> skillProficiencies;
  final List<CharacterSpellItem> spells;
  final List<CharacterFeatureItem> features;
  final CharacterCurrency currency;
  final CharacterBioNotes bioNotes;
  final List<InventoryTableData> inventoryItems;

  const CharacterSheetState({
    required this.characterId,
    required this.name,
    required this.className,
    required this.raceName,
    this.level = 1,
    this.proficiencyBonus = 2,
    this.spellcastingAbility = 'int',
    this.spellcastingMod = 0,
    this.strengthScore = 10,
    this.dexterityMod = 0,
    this.armorClass = 10,
    this.abilityScores = const {
      'str': 10,
      'dex': 10,
      'con': 10,
      'int': 10,
      'wis': 10,
      'cha': 10,
    },
    this.savingThrowProficiencies = const {},
    this.skillProficiencies = const {},
    this.spells = const [],
    this.features = const [],
    this.currency = const CharacterCurrency(),
    this.bioNotes = const CharacterBioNotes(),
    this.inventoryItems = const [],
  });

  int get spellSaveDc => 8 + proficiencyBonus + spellcastingMod;
  int get spellAttackBonus => proficiencyBonus + spellcastingMod;

  int getAbilityScore(String key) => abilityScores[key.toLowerCase()] ?? 10;
  int getAbilityModifier(String key) => ((getAbilityScore(key) - 10) / 2).floor();

  int getSavingThrowBonus(String key) {
    final mod = getAbilityModifier(key);
    final isProf = savingThrowProficiencies.contains(key.toLowerCase());
    return mod + (isProf ? proficiencyBonus : 0);
  }

  int getSkillBonus(String skillName, String abilityKey) {
    final mod = getAbilityModifier(abilityKey);
    final profLevel = skillProficiencies[skillName] ?? 0;
    return mod + (profLevel * proficiencyBonus);
  }

  int get passivePerception => 10 + getSkillBonus('Perception', 'wis');
  int get passiveInvestigation => 10 + getSkillBonus('Investigation', 'int');
  int get passiveInsight => 10 + getSkillBonus('Insight', 'wis');

  double get carriedWeight {
    double total = 0.0;
    for (final item in inventoryItems) {
      total += (item.weight * item.quantity);
    }
    return double.parse(total.toStringAsFixed(1));
  }

  double get carryingCapacity => (strengthScore * 15.0);
  bool get isEncumbered => carriedWeight > carryingCapacity;
  double get encumbrancePercent =>
      carryingCapacity > 0 ? (carriedWeight / carryingCapacity).clamp(0.0, 1.0) : 0.0;

  CharacterSheetState copyWith({
    String? name,
    int? level,
    int? proficiencyBonus,
    int? armorClass,
    int? strengthScore,
    int? dexterityMod,
    Map<String, int>? abilityScores,
    Set<String>? savingThrowProficiencies,
    Map<String, int>? skillProficiencies,
    List<CharacterSpellItem>? spells,
    List<CharacterFeatureItem>? features,
    CharacterCurrency? currency,
    CharacterBioNotes? bioNotes,
    List<InventoryTableData>? inventoryItems,
  }) {
    final newLevel = level ?? this.level;
    final newProf = proficiencyBonus ?? (2 + ((newLevel - 1) / 4).floor());
    return CharacterSheetState(
      characterId: characterId,
      name: name ?? this.name,
      className: className,
      raceName: raceName,
      level: newLevel,
      proficiencyBonus: newProf,
      spellcastingAbility: spellcastingAbility,
      spellcastingMod: spellcastingMod,
      strengthScore: strengthScore ?? this.strengthScore,
      dexterityMod: dexterityMod ?? this.dexterityMod,
      armorClass: armorClass ?? this.armorClass,
      abilityScores: abilityScores ?? this.abilityScores,
      savingThrowProficiencies:
          savingThrowProficiencies ?? this.savingThrowProficiencies,
      skillProficiencies: skillProficiencies ?? this.skillProficiencies,
      spells: spells ?? this.spells,
      features: features ?? this.features,
      currency: currency ?? this.currency,
      bioNotes: bioNotes ?? this.bioNotes,
      inventoryItems: inventoryItems ?? this.inventoryItems,
    );
  }
}

class CharacterSheetNotifier extends Notifier<CharacterSheetState?> {
  final String characterId;

  CharacterSheetNotifier(this.characterId);

  @override
  CharacterSheetState? build() {
    _loadFromDatabase();
    return null;
  }

  Future<void> _loadFromDatabase() async {
    final db = ref.read(databaseProvider);
    final char = await db.getCharacter(characterId);
    if (char == null) return;

    Map<String, dynamic> raw = {};
    try {
      raw = jsonDecode(char.rawPropertiesJson) as Map<String, dynamic>;
    } catch (_) {}

    final level = (raw['level'] as num?)?.toInt() ?? 1;
    final prof = 2 + ((level - 1) / 4).floor();
    final className = raw['class'] as String? ?? 'Adventurer';

    final abilities = raw['abilities'] as Map? ?? {};
    final abilityScores = <String, int>{
      'str': ((abilities['str']?['score'] as num?)?.toInt()) ?? 10,
      'dex': ((abilities['dex']?['score'] as num?)?.toInt()) ?? 10,
      'con': ((abilities['con']?['score'] as num?)?.toInt()) ?? 10,
      'int': ((abilities['int']?['score'] as num?)?.toInt()) ?? 10,
      'wis': ((abilities['wis']?['score'] as num?)?.toInt()) ?? 10,
      'cha': ((abilities['cha']?['score'] as num?)?.toInt()) ?? 10,
    };

    final rawSaves = (raw['savingThrows'] as List? ?? [])
        .map((e) => e.toString().toLowerCase())
        .toSet();
    final saves = Set<String>.from(rawSaves);
    if (saves.isEmpty) {
      final cls = className.toLowerCase();
      if (cls.contains('fighter')) {
        saves.addAll(['str', 'con']);
      } else if (cls.contains('wizard')) {
        saves.addAll(['int', 'wis']);
      } else if (cls.contains('rogue')) {
        saves.addAll(['dex', 'int']);
      } else if (cls.contains('cleric') || cls.contains('paladin')) {
        saves.addAll(['wis', 'cha']);
      } else {
        saves.addAll(['str', 'dex']);
      }
    }

    final rawSkillsMap = raw['skillProficiencies'] as Map? ?? {};
    final skillProficiencies = <String, int>{};
    rawSkillsMap.forEach((k, v) {
      skillProficiencies[k.toString()] = (v as num?)?.toInt() ?? 1;
    });
    for (final s in (raw['skills'] as List? ?? [])) {
      skillProficiencies.putIfAbsent(s.toString(), () => 1);
    }

    final strScore = abilityScores['str']!;
    final dexMod = ((abilityScores['dex']! - 10) / 2).floor();
    final intMod = ((abilityScores['int']! - 10) / 2).floor();
    final wisMod = ((abilityScores['wis']! - 10) / 2).floor();
    final chaMod = ((abilityScores['cha']! - 10) / 2).floor();

    String spellAbility = 'int';
    int spellMod = intMod;
    if (className.toLowerCase().contains('cleric') ||
        className.toLowerCase().contains('druid')) {
      spellAbility = 'wis';
      spellMod = wisMod;
    } else if (className.toLowerCase().contains('warlock') ||
        className.toLowerCase().contains('sorcerer') ||
        className.toLowerCase().contains('bard')) {
      spellAbility = 'cha';
      spellMod = chaMod;
    }

    // Load Spells (handles both Map objects and raw String spell names)
    final rawSpells = raw['spells'] as List? ?? [];
    final spells = <CharacterSpellItem>[];
    for (final s in rawSpells) {
      if (s is Map<String, dynamic>) {
        spells.add(CharacterSpellItem.fromJson(s));
      } else if (s is Map) {
        spells.add(CharacterSpellItem.fromJson(Map<String, dynamic>.from(s)));
      } else if (s is String) {
        final found = SrdStarterData.spells.cast<SpellDefinition?>().firstWhere(
          (def) => def?.name.toLowerCase() == s.toLowerCase() || def?.id.toLowerCase() == s.toLowerCase(),
          orElse: () => null,
        );
        if (found != null) {
          spells.add(CharacterSpellItem(
            id: 'spell_${found.id}',
            name: found.name,
            level: found.level,
            school: found.school,
            castingTime: found.castingTime,
            range: found.range,
            description: found.description,
            isPrepared: true,
          ));
        } else {
          spells.add(CharacterSpellItem(
            id: 'spell_${s.toLowerCase().replaceAll(' ', '_')}',
            name: s,
            level: 0,
            isPrepared: true,
          ));
        }
      }
    }

    // Load Features (handles both Map objects and raw String feature names)
    final rawFeatures = raw['featuresList'] as List? ?? raw['features'] as List? ?? [];
    final features = <CharacterFeatureItem>[];
    for (final f in rawFeatures) {
      if (f is Map<String, dynamic>) {
        features.add(CharacterFeatureItem.fromJson(f));
      } else if (f is Map) {
        features.add(CharacterFeatureItem.fromJson(Map<String, dynamic>.from(f)));
      } else if (f is String) {
        features.add(CharacterFeatureItem(
          id: 'feat_${f.toLowerCase().replaceAll(' ', '_')}',
          name: f,
          source: className,
          description: '$f granted by $className',
        ));
      }
    }

    // Load Currency
    final rawCurrency = raw['currency'] as Map? ?? {};
    final currency = CharacterCurrency.fromJson(Map<String, dynamic>.from(rawCurrency));

    // Load Bio & Notes
    final rawBio = raw['bio'] as Map? ?? {};
    final bioNotes = CharacterBioNotes.fromJson(Map<String, dynamic>.from(rawBio));

    // Load Inventory from SQLite inventory table
    final inventoryItems = await (db.select(db.inventoryTable)
          ..where((t) => t.characterId.equals(characterId)))
        .get();

    final ac = (raw['armorClass'] as num?)?.toInt() ?? 10;

    state = CharacterSheetState(
      characterId: characterId,
      name: char.name,
      className: className,
      raceName: raw['race'] as String? ?? 'Hero',
      level: level,
      proficiencyBonus: prof,
      spellcastingAbility: spellAbility,
      spellcastingMod: spellMod,
      strengthScore: strScore,
      dexterityMod: dexMod,
      armorClass: ac,
      abilityScores: abilityScores,
      savingThrowProficiencies: saves,
      skillProficiencies: skillProficiencies,
      spells: spells,
      features: features,
      currency: currency,
      bioNotes: bioNotes,
      inventoryItems: inventoryItems,
    );
  }

  Future<void> updateName(String newName) async {
    final trimmed = newName.trim();
    if (state == null || trimmed.isEmpty) return;

    state = state!.copyWith(name: trimmed);

    final db = ref.read(databaseProvider);
    final char = await db.getCharacter(characterId);
    if (char != null) {
      Map<String, dynamic> raw = {};
      try {
        raw = jsonDecode(char.rawPropertiesJson) as Map<String, dynamic>;
      } catch (_) {}
      raw['name'] = trimmed;

      await db.upsertCharacter(
        char.toCompanion(true).copyWith(
          name: Value(trimmed),
          rawPropertiesJson: Value(jsonEncode(raw)),
        ),
      );
    }
    ref.invalidate(combatSessionProvider(characterId));
  }

  void toggleSavingThrowProficiency(String abilityKey) {
    if (state == null) return;
    final updated = Set<String>.from(state!.savingThrowProficiencies);
    final key = abilityKey.toLowerCase();
    if (updated.contains(key)) {
      updated.remove(key);
    } else {
      updated.add(key);
    }
    state = state!.copyWith(savingThrowProficiencies: updated);
    _persistRawJson();
  }

  void cycleSkillProficiency(String skillName) {
    if (state == null) return;
    final updated = Map<String, int>.from(state!.skillProficiencies);
    final current = updated[skillName] ?? 0;
    final next = (current + 1) % 3;
    if (next == 0) {
      updated.remove(skillName);
    } else {
      updated[skillName] = next;
    }
    state = state!.copyWith(skillProficiencies: updated);
    _persistRawJson();
  }

  void updateAbilityScore(String abilityKey, int newScore) {
    if (state == null) return;
    final key = abilityKey.toLowerCase();
    final updatedAbilities = Map<String, int>.from(state!.abilityScores);
    updatedAbilities[key] = newScore;

    state = state!.copyWith(
      abilityScores: updatedAbilities,
      strengthScore: key == 'str' ? newScore : state!.strengthScore,
      dexterityMod: key == 'dex' ? ((newScore - 10) / 2).floor() : state!.dexterityMod,
    );
    _persistRawJson();
  }

  void updateLevel(int newLevel) async {
    if (state == null) return;
    final clamped = newLevel.clamp(1, 20);
    final newProf = 2 + ((clamped - 1) / 4).floor();

    state = state!.copyWith(
      level: clamped,
      proficiencyBonus: newProf,
    );

    final db = ref.read(databaseProvider);
    final char = await db.getCharacter(characterId);
    if (char != null) {
      Map<String, dynamic> raw = {};
      try {
        raw = jsonDecode(char.rawPropertiesJson) as Map<String, dynamic>;
      } catch (_) {}
      raw['level'] = clamped;
      raw['proficiencyBonus'] = newProf;

      final hd = Map<String, dynamic>.from(raw['hitDice'] as Map? ?? {});
      hd['total'] = clamped;
      raw['hitDice'] = hd;

      await db.upsertCharacter(
        char.toCompanion(true).copyWith(
          rawPropertiesJson: Value(jsonEncode(raw)),
        ),
      );
    }

    _persistRawJson();
    ref.invalidate(combatSessionProvider(characterId));
  }

  Future<void> applyLevelUp({
    required int hpIncrease,
    Map<String, int>? abilityScoreIncreases,
    List<CharacterFeatureItem>? newFeatures,
  }) async {
    if (state == null) return;
    final newLevel = (state!.level + 1).clamp(1, 20);
    final newProf = 2 + ((newLevel - 1) / 4).floor();

    var updatedAbilities = Map<String, int>.from(state!.abilityScores);
    if (abilityScoreIncreases != null) {
      abilityScoreIncreases.forEach((k, v) {
        final current = updatedAbilities[k] ?? 10;
        updatedAbilities[k] = current + v;
      });
    }

    var updatedFeatures = List<CharacterFeatureItem>.from(state!.features);
    if (newFeatures != null && newFeatures.isNotEmpty) {
      updatedFeatures.addAll(newFeatures);
    }

    state = state!.copyWith(
      level: newLevel,
      proficiencyBonus: newProf,
      abilityScores: updatedAbilities,
      features: updatedFeatures,
      strengthScore: updatedAbilities['str'] ?? state!.strengthScore,
      dexterityMod: (((updatedAbilities['dex'] ?? 10) - 10) / 2).floor(),
    );

    final db = ref.read(databaseProvider);
    final char = await db.getCharacter(characterId);
    if (char != null) {
      Map<String, dynamic> raw = {};
      try {
        raw = jsonDecode(char.rawPropertiesJson) as Map<String, dynamic>;
      } catch (_) {}

      final hp = Map<String, dynamic>.from(raw['hp'] as Map? ?? {});
      final currentMax = (hp['max'] as num?)?.toInt() ?? 10;
      final currentHp = (hp['current'] as num?)?.toInt() ?? 10;
      hp['max'] = currentMax + hpIncrease;
      hp['current'] = currentHp + hpIncrease;
      raw['hp'] = hp;

      final hd = Map<String, dynamic>.from(raw['hitDice'] as Map? ?? {});
      hd['total'] = newLevel;
      raw['hitDice'] = hd;

      raw['level'] = newLevel;
      raw['proficiencyBonus'] = newProf;

      await db.upsertCharacter(
        char.toCompanion(true).copyWith(
          rawPropertiesJson: Value(jsonEncode(raw)),
        ),
      );
    }

    _persistRawJson();
    ref.invalidate(combatSessionProvider(characterId));
  }

  void toggleSpellPreparation(String spellId) {
    if (state == null) return;
    final updated = state!.spells.map((s) {
      if (s.id == spellId) {
        return s.copyWith(isPrepared: !s.isPrepared);
      }
      return s;
    }).toList();

    state = state!.copyWith(spells: updated);
    _persistRawJson();
  }

  void addSpell(CharacterSpellItem spell) {
    if (state == null) return;
    final updated = [...state!.spells, spell];
    state = state!.copyWith(spells: updated);
    _persistRawJson();
  }

  void removeSpell(String spellId) {
    if (state == null) return;
    final updated = state!.spells.where((s) => s.id != spellId).toList();
    state = state!.copyWith(spells: updated);
    _persistRawJson();
  }

  void addFeature(CharacterFeatureItem feature) {
    if (state == null) return;
    final updated = [...state!.features, feature];
    state = state!.copyWith(features: updated);
    _persistRawJson();
  }

  void removeFeature(String featureId) {
    if (state == null) return;
    final updated = state!.features.where((f) => f.id != featureId).toList();
    state = state!.copyWith(features: updated);
    _persistRawJson();
  }

  /// Attempts to cast a spell: if level > 0, deducts a spell slot.
  bool castSpell(CharacterSpellItem spell, BuildContext context) {
    if (state == null) return false;

    if (spell.level == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cast ${spell.name} (Cantrip — At Will)!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      return true;
    }

    final combatState = ref.read(combatSessionProvider(characterId));
    final combatNotifier = ref.read(combatSessionProvider(characterId).notifier);

    final slotKey = '${spell.level}';
    final slot = combatState?.spellSlots[slotKey];

    if (slot == null || slot.available <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No Level ${spell.level} spell slots available to cast ${spell.name}!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    // Toggle the first unspent slot
    combatNotifier.toggleSpellSlot(slotKey, slot.spent);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cast ${spell.name}! Level ${spell.level} slot expended (${slot.available - 1} remaining).'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    return true;
  }

  void updateCurrency(CharacterCurrency currency) {
    if (state == null) return;
    state = state!.copyWith(currency: currency);
    _persistRawJson();
  }

  void updateBioNotes(CharacterBioNotes notes) {
    if (state == null) return;
    state = state!.copyWith(bioNotes: notes);
    _persistRawJson();
  }

  Future<void> toggleItemEquipped(String itemId, bool isEquipped) async {
    if (state == null) return;
    final db = ref.read(databaseProvider);

    await (db.update(db.inventoryTable)..where((t) => t.id.equals(itemId)))
        .write(InventoryTableCompanion(isEquipped: Value(isEquipped)));

    // Refresh inventory
    final items = await (db.select(db.inventoryTable)
          ..where((t) => t.characterId.equals(characterId)))
        .get();

    // Recalculate Armor Class based on equipped armor & shields
    int baseAc = 10 + state!.dexterityMod;
    int shieldBonus = 0;

    for (final it in items) {
      if (!it.isEquipped) continue;
      try {
        final data = jsonDecode(it.itemDataJson) as Map<String, dynamic>;
        if (data['isShield'] == true) {
          shieldBonus += 2;
        } else if (data['isArmor'] == true) {
          final acVal = (data['armorClass'] as num?)?.toInt() ?? 10;
          final cat = data['category'] as String? ?? '';
          if (cat.contains('Heavy')) {
            baseAc = acVal;
          } else if (cat.contains('Medium')) {
            baseAc = acVal + state!.dexterityMod.clamp(-5, 2);
          } else {
            baseAc = acVal + state!.dexterityMod;
          }
        }
      } catch (_) {}
    }

    final newAc = baseAc + shieldBonus;

    state = state!.copyWith(
      inventoryItems: items,
      armorClass: newAc,
    );

    // Save AC to character
    final char = await db.getCharacter(characterId);
    if (char != null) {
      Map<String, dynamic> raw = {};
      try {
        raw = jsonDecode(char.rawPropertiesJson) as Map<String, dynamic>;
      } catch (_) {}
      raw['armorClass'] = newAc;
      await db.upsertCharacter(
        char.toCompanion(true).copyWith(
          rawPropertiesJson: Value(jsonEncode(raw)),
        ),
      );
    }
  }

  Future<void> adjustItemQuantity(String itemId, int delta) async {
    if (state == null) return;
    final db = ref.read(databaseProvider);

    final item = await (db.select(db.inventoryTable)
          ..where((t) => t.id.equals(itemId)))
        .getSingleOrNull();

    if (item == null) return;

    final newQty = item.quantity + delta;
    if (newQty <= 0) {
      await (db.delete(db.inventoryTable)..where((t) => t.id.equals(itemId))).go();
    } else {
      await (db.update(db.inventoryTable)..where((t) => t.id.equals(itemId)))
          .write(InventoryTableCompanion(quantity: Value(newQty)));
    }

    final items = await (db.select(db.inventoryTable)
          ..where((t) => t.characterId.equals(characterId)))
        .get();

    state = state!.copyWith(inventoryItems: items);
  }

  Future<void> addInventoryItem(InventoryTableCompanion item) async {
    final db = ref.read(databaseProvider);
    await db.upsertInventoryItem(item);

    final items = await (db.select(db.inventoryTable)
          ..where((t) => t.characterId.equals(characterId)))
        .get();

    state = state!.copyWith(inventoryItems: items);
  }

  Future<void> deleteInventoryItem(String itemId) async {
    final db = ref.read(databaseProvider);
    await db.removeInventoryItem(itemId);

    final items = await (db.select(db.inventoryTable)
          ..where((t) => t.characterId.equals(characterId)))
        .get();

    state = state!.copyWith(inventoryItems: items);
  }

  Future<void> _persistRawJson() async {
    if (state == null) return;
    final db = ref.read(databaseProvider);
    final char = await db.getCharacter(characterId);
    if (char == null) return;

    Map<String, dynamic> raw = {};
    try {
      raw = jsonDecode(char.rawPropertiesJson) as Map<String, dynamic>;
    } catch (_) {}

    raw['spells'] = state!.spells.map((s) => s.toJson()).toList();
    raw['featuresList'] = state!.features.map((f) => f.toJson()).toList();
    raw['currency'] = state!.currency.toJson();
    raw['bio'] = state!.bioNotes.toJson();
    raw['armorClass'] = state!.armorClass;
    raw['savingThrows'] = state!.savingThrowProficiencies.toList();
    raw['skillProficiencies'] = state!.skillProficiencies;
    raw['level'] = state!.level;
    raw['proficiencyBonus'] = state!.proficiencyBonus;

    final hd = Map<String, dynamic>.from(raw['hitDice'] as Map? ?? {});
    hd['total'] = state!.level;
    raw['hitDice'] = hd;

    final existingAbilities = raw['abilities'] as Map<String, dynamic>? ?? {};
    final updatedAbilities = Map<String, dynamic>.from(existingAbilities);
    for (final entry in state!.abilityScores.entries) {
      final mod = ((entry.value - 10) / 2).floor();
      updatedAbilities[entry.key] = {
        'score': entry.value,
        'mod': mod,
      };
    }
    raw['abilities'] = updatedAbilities;

    await db.upsertCharacter(
      char.toCompanion(true).copyWith(
        rawPropertiesJson: Value(jsonEncode(raw)),
      ),
    );
  }
}

final characterSheetProvider =
    NotifierProvider.family<CharacterSheetNotifier, CharacterSheetState?, String>(
  CharacterSheetNotifier.new,
);

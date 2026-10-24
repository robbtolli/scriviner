class SkillInfo {
  final String name;
  final String abilityKey; // 'str', 'dex', 'con', 'int', 'wis', 'cha'

  const SkillInfo(this.name, this.abilityKey);
}

const List<SkillInfo> standard5eSkills = [
  SkillInfo('Acrobatics', 'dex'),
  SkillInfo('Animal Handling', 'wis'),
  SkillInfo('Arcana', 'int'),
  SkillInfo('Athletics', 'str'),
  SkillInfo('Deception', 'cha'),
  SkillInfo('History', 'int'),
  SkillInfo('Insight', 'wis'),
  SkillInfo('Intimidation', 'cha'),
  SkillInfo('Investigation', 'int'),
  SkillInfo('Medicine', 'wis'),
  SkillInfo('Nature', 'int'),
  SkillInfo('Perception', 'wis'),
  SkillInfo('Performance', 'cha'),
  SkillInfo('Persuasion', 'cha'),
  SkillInfo('Religion', 'int'),
  SkillInfo('Sleight of Hand', 'dex'),
  SkillInfo('Stealth', 'dex'),
  SkillInfo('Survival', 'wis'),
];

class CharacterSpellItem {
  final String id;
  final String name;
  final int level;
  final String school;
  final String castingTime;
  final String range;
  final String components;
  final String duration;
  final bool isPrepared;
  final bool isRitual;
  final String description;

  const CharacterSpellItem({
    required this.id,
    required this.name,
    this.level = 0,
    this.school = 'Evocation',
    this.castingTime = '1 action',
    this.range = 'Touch',
    this.components = 'V, S',
    this.duration = 'Instantaneous',
    this.isPrepared = true,
    this.isRitual = false,
    this.description = '',
  });

  CharacterSpellItem copyWith({
    bool? isPrepared,
  }) {
    return CharacterSpellItem(
      id: id,
      name: name,
      level: level,
      school: school,
      castingTime: castingTime,
      range: range,
      components: components,
      duration: duration,
      isPrepared: isPrepared ?? this.isPrepared,
      isRitual: isRitual,
      description: description,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'level': level,
        'school': school,
        'castingTime': castingTime,
        'range': range,
        'components': components,
        'duration': duration,
        'isPrepared': isPrepared,
        'isRitual': isRitual,
        'description': description,
      };

  factory CharacterSpellItem.fromJson(Map<String, dynamic> json) {
    return CharacterSpellItem(
      id: json['id'] as String? ?? UniqueKey().toString(),
      name: json['name'] as String? ?? 'Unnamed Spell',
      level: (json['level'] as num?)?.toInt() ?? 0,
      school: json['school'] as String? ?? 'Evocation',
      castingTime: json['castingTime'] as String? ?? '1 action',
      range: json['range'] as String? ?? 'Touch',
      components: json['components'] as String? ?? 'V, S',
      duration: json['duration'] as String? ?? 'Instantaneous',
      isPrepared: (json['isPrepared'] as bool?) ?? true,
      isRitual: (json['isRitual'] as bool?) ?? false,
      description: json['description'] as String? ?? '',
    );
  }
}

class CharacterFeatureItem {
  final String id;
  final String name;
  final String source;
  final String recharge;
  final int usesMax;
  final int usesSpent;
  final String description;

  const CharacterFeatureItem({
    required this.id,
    required this.name,
    this.source = 'Class',
    this.recharge = 'Short or Long Rest',
    this.usesMax = 0,
    this.usesSpent = 0,
    this.description = '',
  });

  int get availableUses => usesMax > 0 ? (usesMax - usesSpent) : 0;

  CharacterFeatureItem copyWith({int? usesSpent}) {
    return CharacterFeatureItem(
      id: id,
      name: name,
      source: source,
      recharge: recharge,
      usesMax: usesMax,
      usesSpent: usesSpent ?? this.usesSpent,
      description: description,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'source': source,
        'recharge': recharge,
        'usesMax': usesMax,
        'usesSpent': usesSpent,
        'description': description,
      };

  factory CharacterFeatureItem.fromJson(Map<String, dynamic> json) {
    return CharacterFeatureItem(
      id: json['id'] as String? ?? 'feat_${json['name']}',
      name: json['name'] as String? ?? 'Feature',
      source: json['source'] as String? ?? 'Class',
      recharge: json['recharge'] as String? ?? 'Short or Long Rest',
      usesMax: (json['usesMax'] as num?)?.toInt() ?? 0,
      usesSpent: (json['usesSpent'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
    );
  }
}

class CharacterCurrency {
  final int cp;
  final int sp;
  final int ep;
  final int gp;
  final int pp;

  const CharacterCurrency({
    this.cp = 0,
    this.sp = 0,
    this.ep = 0,
    this.gp = 15,
    this.pp = 0,
  });

  double get totalInGp =>
      gp + (pp * 10) + (ep * 0.5) + (sp * 0.1) + (cp * 0.01);

  CharacterCurrency copyWith({
    int? cp,
    int? sp,
    int? ep,
    int? gp,
    int? pp,
  }) {
    return CharacterCurrency(
      cp: cp ?? this.cp,
      sp: sp ?? this.sp,
      ep: ep ?? this.ep,
      gp: gp ?? this.gp,
      pp: pp ?? this.pp,
    );
  }

  Map<String, dynamic> toJson() => {
        'cp': cp,
        'sp': sp,
        'ep': ep,
        'gp': gp,
        'pp': pp,
      };

  factory CharacterCurrency.fromJson(Map<String, dynamic> json) {
    return CharacterCurrency(
      cp: (json['cp'] as num?)?.toInt() ?? 0,
      sp: (json['sp'] as num?)?.toInt() ?? 0,
      ep: (json['ep'] as num?)?.toInt() ?? 0,
      gp: (json['gp'] as num?)?.toInt() ?? 15,
      pp: (json['pp'] as num?)?.toInt() ?? 0,
    );
  }
}

class CharacterBioNotes {
  final String backstory;
  final String traits;
  final String ideals;
  final String bonds;
  final String flaws;
  final String sessionNotes;

  const CharacterBioNotes({
    this.backstory = '',
    this.traits = '',
    this.ideals = '',
    this.bonds = '',
    this.flaws = '',
    this.sessionNotes = '',
  });

  CharacterBioNotes copyWith({
    String? backstory,
    String? traits,
    String? ideals,
    String? bonds,
    String? flaws,
    String? sessionNotes,
  }) {
    return CharacterBioNotes(
      backstory: backstory ?? this.backstory,
      traits: traits ?? this.traits,
      ideals: ideals ?? this.ideals,
      bonds: bonds ?? this.bonds,
      flaws: flaws ?? this.flaws,
      sessionNotes: sessionNotes ?? this.sessionNotes,
    );
  }

  Map<String, dynamic> toJson() => {
        'backstory': backstory,
        'traits': traits,
        'ideals': ideals,
        'bonds': bonds,
        'flaws': flaws,
        'sessionNotes': sessionNotes,
      };

  factory CharacterBioNotes.fromJson(Map<String, dynamic> json) {
    return CharacterBioNotes(
      backstory: json['backstory'] as String? ?? '',
      traits: json['traits'] as String? ?? '',
      ideals: json['ideals'] as String? ?? '',
      bonds: json['bonds'] as String? ?? '',
      flaws: json['flaws'] as String? ?? '',
      sessionNotes: json['sessionNotes'] as String? ?? '',
    );
  }
}

// Simple unique key helper
class UniqueKey {
  static int _id = 0;
  @override
  String toString() => 'spell_${DateTime.now().millisecondsSinceEpoch}_${_id++}';
}

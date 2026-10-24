// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CharactersTableTable extends CharactersTable
    with TableInfo<$CharactersTableTable, CharactersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systemIdMeta = const VerificationMeta(
    'systemId',
  );
  @override
  late final GeneratedColumn<String> systemId = GeneratedColumn<String>(
    'system_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dnd5e'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portraitUriMeta = const VerificationMeta(
    'portraitUri',
  );
  @override
  late final GeneratedColumn<String> portraitUri = GeneratedColumn<String>(
    'portrait_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawPropertiesJsonMeta = const VerificationMeta(
    'rawPropertiesJson',
  );
  @override
  late final GeneratedColumn<String> rawPropertiesJson =
      GeneratedColumn<String>(
        'raw_properties_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    systemId,
    name,
    portraitUri,
    createdAt,
    lastPlayedAt,
    rawPropertiesJson,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharactersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('system_id')) {
      context.handle(
        _systemIdMeta,
        systemId.isAcceptableOrUnknown(data['system_id']!, _systemIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('portrait_uri')) {
      context.handle(
        _portraitUriMeta,
        portraitUri.isAcceptableOrUnknown(
          data['portrait_uri']!,
          _portraitUriMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastPlayedAtMeta);
    }
    if (data.containsKey('raw_properties_json')) {
      context.handle(
        _rawPropertiesJsonMeta,
        rawPropertiesJson.isAcceptableOrUnknown(
          data['raw_properties_json']!,
          _rawPropertiesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawPropertiesJsonMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharactersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharactersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      systemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      portraitUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}portrait_uri'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_at'],
      )!,
      rawPropertiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_properties_json'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $CharactersTableTable createAlias(String alias) {
    return $CharactersTableTable(attachedDatabase, alias);
  }
}

class CharactersTableData extends DataClass
    implements Insertable<CharactersTableData> {
  final String id;
  final String systemId;
  final String name;
  final String? portraitUri;
  final DateTime createdAt;
  final DateTime lastPlayedAt;
  final String rawPropertiesJson;
  final String notes;
  const CharactersTableData({
    required this.id,
    required this.systemId,
    required this.name,
    this.portraitUri,
    required this.createdAt,
    required this.lastPlayedAt,
    required this.rawPropertiesJson,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['system_id'] = Variable<String>(systemId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || portraitUri != null) {
      map['portrait_uri'] = Variable<String>(portraitUri);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    map['raw_properties_json'] = Variable<String>(rawPropertiesJson);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  CharactersTableCompanion toCompanion(bool nullToAbsent) {
    return CharactersTableCompanion(
      id: Value(id),
      systemId: Value(systemId),
      name: Value(name),
      portraitUri: portraitUri == null && nullToAbsent
          ? const Value.absent()
          : Value(portraitUri),
      createdAt: Value(createdAt),
      lastPlayedAt: Value(lastPlayedAt),
      rawPropertiesJson: Value(rawPropertiesJson),
      notes: Value(notes),
    );
  }

  factory CharactersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharactersTableData(
      id: serializer.fromJson<String>(json['id']),
      systemId: serializer.fromJson<String>(json['systemId']),
      name: serializer.fromJson<String>(json['name']),
      portraitUri: serializer.fromJson<String?>(json['portraitUri']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastPlayedAt: serializer.fromJson<DateTime>(json['lastPlayedAt']),
      rawPropertiesJson: serializer.fromJson<String>(json['rawPropertiesJson']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'systemId': serializer.toJson<String>(systemId),
      'name': serializer.toJson<String>(name),
      'portraitUri': serializer.toJson<String?>(portraitUri),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastPlayedAt': serializer.toJson<DateTime>(lastPlayedAt),
      'rawPropertiesJson': serializer.toJson<String>(rawPropertiesJson),
      'notes': serializer.toJson<String>(notes),
    };
  }

  CharactersTableData copyWith({
    String? id,
    String? systemId,
    String? name,
    Value<String?> portraitUri = const Value.absent(),
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    String? rawPropertiesJson,
    String? notes,
  }) => CharactersTableData(
    id: id ?? this.id,
    systemId: systemId ?? this.systemId,
    name: name ?? this.name,
    portraitUri: portraitUri.present ? portraitUri.value : this.portraitUri,
    createdAt: createdAt ?? this.createdAt,
    lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    rawPropertiesJson: rawPropertiesJson ?? this.rawPropertiesJson,
    notes: notes ?? this.notes,
  );
  CharactersTableData copyWithCompanion(CharactersTableCompanion data) {
    return CharactersTableData(
      id: data.id.present ? data.id.value : this.id,
      systemId: data.systemId.present ? data.systemId.value : this.systemId,
      name: data.name.present ? data.name.value : this.name,
      portraitUri: data.portraitUri.present
          ? data.portraitUri.value
          : this.portraitUri,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
      rawPropertiesJson: data.rawPropertiesJson.present
          ? data.rawPropertiesJson.value
          : this.rawPropertiesJson,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharactersTableData(')
          ..write('id: $id, ')
          ..write('systemId: $systemId, ')
          ..write('name: $name, ')
          ..write('portraitUri: $portraitUri, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('rawPropertiesJson: $rawPropertiesJson, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    systemId,
    name,
    portraitUri,
    createdAt,
    lastPlayedAt,
    rawPropertiesJson,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharactersTableData &&
          other.id == this.id &&
          other.systemId == this.systemId &&
          other.name == this.name &&
          other.portraitUri == this.portraitUri &&
          other.createdAt == this.createdAt &&
          other.lastPlayedAt == this.lastPlayedAt &&
          other.rawPropertiesJson == this.rawPropertiesJson &&
          other.notes == this.notes);
}

class CharactersTableCompanion extends UpdateCompanion<CharactersTableData> {
  final Value<String> id;
  final Value<String> systemId;
  final Value<String> name;
  final Value<String?> portraitUri;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastPlayedAt;
  final Value<String> rawPropertiesJson;
  final Value<String> notes;
  final Value<int> rowid;
  const CharactersTableCompanion({
    this.id = const Value.absent(),
    this.systemId = const Value.absent(),
    this.name = const Value.absent(),
    this.portraitUri = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.rawPropertiesJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharactersTableCompanion.insert({
    required String id,
    this.systemId = const Value.absent(),
    required String name,
    this.portraitUri = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastPlayedAt,
    required String rawPropertiesJson,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       lastPlayedAt = Value(lastPlayedAt),
       rawPropertiesJson = Value(rawPropertiesJson);
  static Insertable<CharactersTableData> custom({
    Expression<String>? id,
    Expression<String>? systemId,
    Expression<String>? name,
    Expression<String>? portraitUri,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastPlayedAt,
    Expression<String>? rawPropertiesJson,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (systemId != null) 'system_id': systemId,
      if (name != null) 'name': name,
      if (portraitUri != null) 'portrait_uri': portraitUri,
      if (createdAt != null) 'created_at': createdAt,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (rawPropertiesJson != null) 'raw_properties_json': rawPropertiesJson,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharactersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? systemId,
    Value<String>? name,
    Value<String?>? portraitUri,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastPlayedAt,
    Value<String>? rawPropertiesJson,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return CharactersTableCompanion(
      id: id ?? this.id,
      systemId: systemId ?? this.systemId,
      name: name ?? this.name,
      portraitUri: portraitUri ?? this.portraitUri,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      rawPropertiesJson: rawPropertiesJson ?? this.rawPropertiesJson,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (systemId.present) {
      map['system_id'] = Variable<String>(systemId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (portraitUri.present) {
      map['portrait_uri'] = Variable<String>(portraitUri.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    if (rawPropertiesJson.present) {
      map['raw_properties_json'] = Variable<String>(rawPropertiesJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersTableCompanion(')
          ..write('id: $id, ')
          ..write('systemId: $systemId, ')
          ..write('name: $name, ')
          ..write('portraitUri: $portraitUri, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('rawPropertiesJson: $rawPropertiesJson, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConditionsTableTable extends ConditionsTable
    with TableInfo<$ConditionsTableTable, ConditionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConditionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _conditionIdMeta = const VerificationMeta(
    'conditionId',
  );
  @override
  late final GeneratedColumn<String> conditionId = GeneratedColumn<String>(
    'condition_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationRoundsMeta = const VerificationMeta(
    'durationRounds',
  );
  @override
  late final GeneratedColumn<int> durationRounds = GeneratedColumn<int>(
    'duration_rounds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customNotesMeta = const VerificationMeta(
    'customNotes',
  );
  @override
  late final GeneratedColumn<String> customNotes = GeneratedColumn<String>(
    'custom_notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    conditionId,
    durationRounds,
    customNotes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conditions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConditionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('condition_id')) {
      context.handle(
        _conditionIdMeta,
        conditionId.isAcceptableOrUnknown(
          data['condition_id']!,
          _conditionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conditionIdMeta);
    }
    if (data.containsKey('duration_rounds')) {
      context.handle(
        _durationRoundsMeta,
        durationRounds.isAcceptableOrUnknown(
          data['duration_rounds']!,
          _durationRoundsMeta,
        ),
      );
    }
    if (data.containsKey('custom_notes')) {
      context.handle(
        _customNotesMeta,
        customNotes.isAcceptableOrUnknown(
          data['custom_notes']!,
          _customNotesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConditionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConditionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      conditionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_id'],
      )!,
      durationRounds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_rounds'],
      ),
      customNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_notes'],
      )!,
    );
  }

  @override
  $ConditionsTableTable createAlias(String alias) {
    return $ConditionsTableTable(attachedDatabase, alias);
  }
}

class ConditionsTableData extends DataClass
    implements Insertable<ConditionsTableData> {
  final String id;
  final String characterId;
  final String conditionId;
  final int? durationRounds;
  final String customNotes;
  const ConditionsTableData({
    required this.id,
    required this.characterId,
    required this.conditionId,
    this.durationRounds,
    required this.customNotes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['character_id'] = Variable<String>(characterId);
    map['condition_id'] = Variable<String>(conditionId);
    if (!nullToAbsent || durationRounds != null) {
      map['duration_rounds'] = Variable<int>(durationRounds);
    }
    map['custom_notes'] = Variable<String>(customNotes);
    return map;
  }

  ConditionsTableCompanion toCompanion(bool nullToAbsent) {
    return ConditionsTableCompanion(
      id: Value(id),
      characterId: Value(characterId),
      conditionId: Value(conditionId),
      durationRounds: durationRounds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationRounds),
      customNotes: Value(customNotes),
    );
  }

  factory ConditionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConditionsTableData(
      id: serializer.fromJson<String>(json['id']),
      characterId: serializer.fromJson<String>(json['characterId']),
      conditionId: serializer.fromJson<String>(json['conditionId']),
      durationRounds: serializer.fromJson<int?>(json['durationRounds']),
      customNotes: serializer.fromJson<String>(json['customNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'characterId': serializer.toJson<String>(characterId),
      'conditionId': serializer.toJson<String>(conditionId),
      'durationRounds': serializer.toJson<int?>(durationRounds),
      'customNotes': serializer.toJson<String>(customNotes),
    };
  }

  ConditionsTableData copyWith({
    String? id,
    String? characterId,
    String? conditionId,
    Value<int?> durationRounds = const Value.absent(),
    String? customNotes,
  }) => ConditionsTableData(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    conditionId: conditionId ?? this.conditionId,
    durationRounds: durationRounds.present
        ? durationRounds.value
        : this.durationRounds,
    customNotes: customNotes ?? this.customNotes,
  );
  ConditionsTableData copyWithCompanion(ConditionsTableCompanion data) {
    return ConditionsTableData(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      conditionId: data.conditionId.present
          ? data.conditionId.value
          : this.conditionId,
      durationRounds: data.durationRounds.present
          ? data.durationRounds.value
          : this.durationRounds,
      customNotes: data.customNotes.present
          ? data.customNotes.value
          : this.customNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConditionsTableData(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('conditionId: $conditionId, ')
          ..write('durationRounds: $durationRounds, ')
          ..write('customNotes: $customNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, characterId, conditionId, durationRounds, customNotes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConditionsTableData &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.conditionId == this.conditionId &&
          other.durationRounds == this.durationRounds &&
          other.customNotes == this.customNotes);
}

class ConditionsTableCompanion extends UpdateCompanion<ConditionsTableData> {
  final Value<String> id;
  final Value<String> characterId;
  final Value<String> conditionId;
  final Value<int?> durationRounds;
  final Value<String> customNotes;
  final Value<int> rowid;
  const ConditionsTableCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.conditionId = const Value.absent(),
    this.durationRounds = const Value.absent(),
    this.customNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConditionsTableCompanion.insert({
    required String id,
    required String characterId,
    required String conditionId,
    this.durationRounds = const Value.absent(),
    this.customNotes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       characterId = Value(characterId),
       conditionId = Value(conditionId);
  static Insertable<ConditionsTableData> custom({
    Expression<String>? id,
    Expression<String>? characterId,
    Expression<String>? conditionId,
    Expression<int>? durationRounds,
    Expression<String>? customNotes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (conditionId != null) 'condition_id': conditionId,
      if (durationRounds != null) 'duration_rounds': durationRounds,
      if (customNotes != null) 'custom_notes': customNotes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConditionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? characterId,
    Value<String>? conditionId,
    Value<int?>? durationRounds,
    Value<String>? customNotes,
    Value<int>? rowid,
  }) {
    return ConditionsTableCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      conditionId: conditionId ?? this.conditionId,
      durationRounds: durationRounds ?? this.durationRounds,
      customNotes: customNotes ?? this.customNotes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (conditionId.present) {
      map['condition_id'] = Variable<String>(conditionId.value);
    }
    if (durationRounds.present) {
      map['duration_rounds'] = Variable<int>(durationRounds.value);
    }
    if (customNotes.present) {
      map['custom_notes'] = Variable<String>(customNotes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConditionsTableCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('conditionId: $conditionId, ')
          ..write('durationRounds: $durationRounds, ')
          ..write('customNotes: $customNotes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryTableTable extends InventoryTable
    with TableInfo<$InventoryTableTable, InventoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isEquippedMeta = const VerificationMeta(
    'isEquipped',
  );
  @override
  late final GeneratedColumn<bool> isEquipped = GeneratedColumn<bool>(
    'is_equipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_equipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isAttunedMeta = const VerificationMeta(
    'isAttuned',
  );
  @override
  late final GeneratedColumn<bool> isAttuned = GeneratedColumn<bool>(
    'is_attuned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_attuned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _containerNameMeta = const VerificationMeta(
    'containerName',
  );
  @override
  late final GeneratedColumn<String> containerName = GeneratedColumn<String>(
    'container_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Backpack'),
  );
  static const VerificationMeta _itemDataJsonMeta = const VerificationMeta(
    'itemDataJson',
  );
  @override
  late final GeneratedColumn<String> itemDataJson = GeneratedColumn<String>(
    'item_data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    name,
    quantity,
    weight,
    isEquipped,
    isAttuned,
    containerName,
    itemDataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('is_equipped')) {
      context.handle(
        _isEquippedMeta,
        isEquipped.isAcceptableOrUnknown(data['is_equipped']!, _isEquippedMeta),
      );
    }
    if (data.containsKey('is_attuned')) {
      context.handle(
        _isAttunedMeta,
        isAttuned.isAcceptableOrUnknown(data['is_attuned']!, _isAttunedMeta),
      );
    }
    if (data.containsKey('container_name')) {
      context.handle(
        _containerNameMeta,
        containerName.isAcceptableOrUnknown(
          data['container_name']!,
          _containerNameMeta,
        ),
      );
    }
    if (data.containsKey('item_data_json')) {
      context.handle(
        _itemDataJsonMeta,
        itemDataJson.isAcceptableOrUnknown(
          data['item_data_json']!,
          _itemDataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      isEquipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_equipped'],
      )!,
      isAttuned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_attuned'],
      )!,
      containerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}container_name'],
      )!,
      itemDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_data_json'],
      )!,
    );
  }

  @override
  $InventoryTableTable createAlias(String alias) {
    return $InventoryTableTable(attachedDatabase, alias);
  }
}

class InventoryTableData extends DataClass
    implements Insertable<InventoryTableData> {
  final String id;
  final String characterId;
  final String name;
  final int quantity;
  final double weight;
  final bool isEquipped;
  final bool isAttuned;
  final String containerName;
  final String itemDataJson;
  const InventoryTableData({
    required this.id,
    required this.characterId,
    required this.name,
    required this.quantity,
    required this.weight,
    required this.isEquipped,
    required this.isAttuned,
    required this.containerName,
    required this.itemDataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['character_id'] = Variable<String>(characterId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<int>(quantity);
    map['weight'] = Variable<double>(weight);
    map['is_equipped'] = Variable<bool>(isEquipped);
    map['is_attuned'] = Variable<bool>(isAttuned);
    map['container_name'] = Variable<String>(containerName);
    map['item_data_json'] = Variable<String>(itemDataJson);
    return map;
  }

  InventoryTableCompanion toCompanion(bool nullToAbsent) {
    return InventoryTableCompanion(
      id: Value(id),
      characterId: Value(characterId),
      name: Value(name),
      quantity: Value(quantity),
      weight: Value(weight),
      isEquipped: Value(isEquipped),
      isAttuned: Value(isAttuned),
      containerName: Value(containerName),
      itemDataJson: Value(itemDataJson),
    );
  }

  factory InventoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryTableData(
      id: serializer.fromJson<String>(json['id']),
      characterId: serializer.fromJson<String>(json['characterId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int>(json['quantity']),
      weight: serializer.fromJson<double>(json['weight']),
      isEquipped: serializer.fromJson<bool>(json['isEquipped']),
      isAttuned: serializer.fromJson<bool>(json['isAttuned']),
      containerName: serializer.fromJson<String>(json['containerName']),
      itemDataJson: serializer.fromJson<String>(json['itemDataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'characterId': serializer.toJson<String>(characterId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int>(quantity),
      'weight': serializer.toJson<double>(weight),
      'isEquipped': serializer.toJson<bool>(isEquipped),
      'isAttuned': serializer.toJson<bool>(isAttuned),
      'containerName': serializer.toJson<String>(containerName),
      'itemDataJson': serializer.toJson<String>(itemDataJson),
    };
  }

  InventoryTableData copyWith({
    String? id,
    String? characterId,
    String? name,
    int? quantity,
    double? weight,
    bool? isEquipped,
    bool? isAttuned,
    String? containerName,
    String? itemDataJson,
  }) => InventoryTableData(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    weight: weight ?? this.weight,
    isEquipped: isEquipped ?? this.isEquipped,
    isAttuned: isAttuned ?? this.isAttuned,
    containerName: containerName ?? this.containerName,
    itemDataJson: itemDataJson ?? this.itemDataJson,
  );
  InventoryTableData copyWithCompanion(InventoryTableCompanion data) {
    return InventoryTableData(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      weight: data.weight.present ? data.weight.value : this.weight,
      isEquipped: data.isEquipped.present
          ? data.isEquipped.value
          : this.isEquipped,
      isAttuned: data.isAttuned.present ? data.isAttuned.value : this.isAttuned,
      containerName: data.containerName.present
          ? data.containerName.value
          : this.containerName,
      itemDataJson: data.itemDataJson.present
          ? data.itemDataJson.value
          : this.itemDataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTableData(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('weight: $weight, ')
          ..write('isEquipped: $isEquipped, ')
          ..write('isAttuned: $isAttuned, ')
          ..write('containerName: $containerName, ')
          ..write('itemDataJson: $itemDataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    characterId,
    name,
    quantity,
    weight,
    isEquipped,
    isAttuned,
    containerName,
    itemDataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryTableData &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.weight == this.weight &&
          other.isEquipped == this.isEquipped &&
          other.isAttuned == this.isAttuned &&
          other.containerName == this.containerName &&
          other.itemDataJson == this.itemDataJson);
}

class InventoryTableCompanion extends UpdateCompanion<InventoryTableData> {
  final Value<String> id;
  final Value<String> characterId;
  final Value<String> name;
  final Value<int> quantity;
  final Value<double> weight;
  final Value<bool> isEquipped;
  final Value<bool> isAttuned;
  final Value<String> containerName;
  final Value<String> itemDataJson;
  final Value<int> rowid;
  const InventoryTableCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.weight = const Value.absent(),
    this.isEquipped = const Value.absent(),
    this.isAttuned = const Value.absent(),
    this.containerName = const Value.absent(),
    this.itemDataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryTableCompanion.insert({
    required String id,
    required String characterId,
    required String name,
    this.quantity = const Value.absent(),
    this.weight = const Value.absent(),
    this.isEquipped = const Value.absent(),
    this.isAttuned = const Value.absent(),
    this.containerName = const Value.absent(),
    this.itemDataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       characterId = Value(characterId),
       name = Value(name);
  static Insertable<InventoryTableData> custom({
    Expression<String>? id,
    Expression<String>? characterId,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<double>? weight,
    Expression<bool>? isEquipped,
    Expression<bool>? isAttuned,
    Expression<String>? containerName,
    Expression<String>? itemDataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (weight != null) 'weight': weight,
      if (isEquipped != null) 'is_equipped': isEquipped,
      if (isAttuned != null) 'is_attuned': isAttuned,
      if (containerName != null) 'container_name': containerName,
      if (itemDataJson != null) 'item_data_json': itemDataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? characterId,
    Value<String>? name,
    Value<int>? quantity,
    Value<double>? weight,
    Value<bool>? isEquipped,
    Value<bool>? isAttuned,
    Value<String>? containerName,
    Value<String>? itemDataJson,
    Value<int>? rowid,
  }) {
    return InventoryTableCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      weight: weight ?? this.weight,
      isEquipped: isEquipped ?? this.isEquipped,
      isAttuned: isAttuned ?? this.isAttuned,
      containerName: containerName ?? this.containerName,
      itemDataJson: itemDataJson ?? this.itemDataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (isEquipped.present) {
      map['is_equipped'] = Variable<bool>(isEquipped.value);
    }
    if (isAttuned.present) {
      map['is_attuned'] = Variable<bool>(isAttuned.value);
    }
    if (containerName.present) {
      map['container_name'] = Variable<String>(containerName.value);
    }
    if (itemDataJson.present) {
      map['item_data_json'] = Variable<String>(itemDataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryTableCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('weight: $weight, ')
          ..write('isEquipped: $isEquipped, ')
          ..write('isAttuned: $isAttuned, ')
          ..write('containerName: $containerName, ')
          ..write('itemDataJson: $itemDataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompendiumTableTable extends CompendiumTable
    with TableInfo<$CompendiumTableTable, CompendiumTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompendiumTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systemIdMeta = const VerificationMeta(
    'systemId',
  );
  @override
  late final GeneratedColumn<String> systemId = GeneratedColumn<String>(
    'system_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fullDataJsonMeta = const VerificationMeta(
    'fullDataJson',
  );
  @override
  late final GeneratedColumn<String> fullDataJson = GeneratedColumn<String>(
    'full_data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    systemId,
    category,
    name,
    summary,
    fullDataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compendium_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompendiumTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('system_id')) {
      context.handle(
        _systemIdMeta,
        systemId.isAcceptableOrUnknown(data['system_id']!, _systemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_systemIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('full_data_json')) {
      context.handle(
        _fullDataJsonMeta,
        fullDataJson.isAcceptableOrUnknown(
          data['full_data_json']!,
          _fullDataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompendiumTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompendiumTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      systemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      fullDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_data_json'],
      )!,
    );
  }

  @override
  $CompendiumTableTable createAlias(String alias) {
    return $CompendiumTableTable(attachedDatabase, alias);
  }
}

class CompendiumTableData extends DataClass
    implements Insertable<CompendiumTableData> {
  final String id;
  final String systemId;
  final String category;
  final String name;
  final String summary;
  final String fullDataJson;
  const CompendiumTableData({
    required this.id,
    required this.systemId,
    required this.category,
    required this.name,
    required this.summary,
    required this.fullDataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['system_id'] = Variable<String>(systemId);
    map['category'] = Variable<String>(category);
    map['name'] = Variable<String>(name);
    map['summary'] = Variable<String>(summary);
    map['full_data_json'] = Variable<String>(fullDataJson);
    return map;
  }

  CompendiumTableCompanion toCompanion(bool nullToAbsent) {
    return CompendiumTableCompanion(
      id: Value(id),
      systemId: Value(systemId),
      category: Value(category),
      name: Value(name),
      summary: Value(summary),
      fullDataJson: Value(fullDataJson),
    );
  }

  factory CompendiumTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompendiumTableData(
      id: serializer.fromJson<String>(json['id']),
      systemId: serializer.fromJson<String>(json['systemId']),
      category: serializer.fromJson<String>(json['category']),
      name: serializer.fromJson<String>(json['name']),
      summary: serializer.fromJson<String>(json['summary']),
      fullDataJson: serializer.fromJson<String>(json['fullDataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'systemId': serializer.toJson<String>(systemId),
      'category': serializer.toJson<String>(category),
      'name': serializer.toJson<String>(name),
      'summary': serializer.toJson<String>(summary),
      'fullDataJson': serializer.toJson<String>(fullDataJson),
    };
  }

  CompendiumTableData copyWith({
    String? id,
    String? systemId,
    String? category,
    String? name,
    String? summary,
    String? fullDataJson,
  }) => CompendiumTableData(
    id: id ?? this.id,
    systemId: systemId ?? this.systemId,
    category: category ?? this.category,
    name: name ?? this.name,
    summary: summary ?? this.summary,
    fullDataJson: fullDataJson ?? this.fullDataJson,
  );
  CompendiumTableData copyWithCompanion(CompendiumTableCompanion data) {
    return CompendiumTableData(
      id: data.id.present ? data.id.value : this.id,
      systemId: data.systemId.present ? data.systemId.value : this.systemId,
      category: data.category.present ? data.category.value : this.category,
      name: data.name.present ? data.name.value : this.name,
      summary: data.summary.present ? data.summary.value : this.summary,
      fullDataJson: data.fullDataJson.present
          ? data.fullDataJson.value
          : this.fullDataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompendiumTableData(')
          ..write('id: $id, ')
          ..write('systemId: $systemId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('summary: $summary, ')
          ..write('fullDataJson: $fullDataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, systemId, category, name, summary, fullDataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompendiumTableData &&
          other.id == this.id &&
          other.systemId == this.systemId &&
          other.category == this.category &&
          other.name == this.name &&
          other.summary == this.summary &&
          other.fullDataJson == this.fullDataJson);
}

class CompendiumTableCompanion extends UpdateCompanion<CompendiumTableData> {
  final Value<String> id;
  final Value<String> systemId;
  final Value<String> category;
  final Value<String> name;
  final Value<String> summary;
  final Value<String> fullDataJson;
  final Value<int> rowid;
  const CompendiumTableCompanion({
    this.id = const Value.absent(),
    this.systemId = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
    this.summary = const Value.absent(),
    this.fullDataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompendiumTableCompanion.insert({
    required String id,
    required String systemId,
    required String category,
    required String name,
    this.summary = const Value.absent(),
    this.fullDataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       systemId = Value(systemId),
       category = Value(category),
       name = Value(name);
  static Insertable<CompendiumTableData> custom({
    Expression<String>? id,
    Expression<String>? systemId,
    Expression<String>? category,
    Expression<String>? name,
    Expression<String>? summary,
    Expression<String>? fullDataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (systemId != null) 'system_id': systemId,
      if (category != null) 'category': category,
      if (name != null) 'name': name,
      if (summary != null) 'summary': summary,
      if (fullDataJson != null) 'full_data_json': fullDataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompendiumTableCompanion copyWith({
    Value<String>? id,
    Value<String>? systemId,
    Value<String>? category,
    Value<String>? name,
    Value<String>? summary,
    Value<String>? fullDataJson,
    Value<int>? rowid,
  }) {
    return CompendiumTableCompanion(
      id: id ?? this.id,
      systemId: systemId ?? this.systemId,
      category: category ?? this.category,
      name: name ?? this.name,
      summary: summary ?? this.summary,
      fullDataJson: fullDataJson ?? this.fullDataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (systemId.present) {
      map['system_id'] = Variable<String>(systemId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (fullDataJson.present) {
      map['full_data_json'] = Variable<String>(fullDataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompendiumTableCompanion(')
          ..write('id: $id, ')
          ..write('systemId: $systemId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('summary: $summary, ')
          ..write('fullDataJson: $fullDataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CharactersTableTable charactersTable = $CharactersTableTable(
    this,
  );
  late final $ConditionsTableTable conditionsTable = $ConditionsTableTable(
    this,
  );
  late final $InventoryTableTable inventoryTable = $InventoryTableTable(this);
  late final $CompendiumTableTable compendiumTable = $CompendiumTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    charactersTable,
    conditionsTable,
    inventoryTable,
    compendiumTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('conditions_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inventory_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CharactersTableTableCreateCompanionBuilder =
    CharactersTableCompanion Function({
      required String id,
      Value<String> systemId,
      required String name,
      Value<String?> portraitUri,
      required DateTime createdAt,
      required DateTime lastPlayedAt,
      required String rawPropertiesJson,
      Value<String> notes,
      Value<int> rowid,
    });
typedef $$CharactersTableTableUpdateCompanionBuilder =
    CharactersTableCompanion Function({
      Value<String> id,
      Value<String> systemId,
      Value<String> name,
      Value<String?> portraitUri,
      Value<DateTime> createdAt,
      Value<DateTime> lastPlayedAt,
      Value<String> rawPropertiesJson,
      Value<String> notes,
      Value<int> rowid,
    });

final class $$CharactersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharactersTableTable,
          CharactersTableData
        > {
  $$CharactersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ConditionsTableTable, List<ConditionsTableData>>
  _conditionsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.conditionsTable,
    aliasName: 'characters_table__id__conditions_table__character_id',
  );

  $$ConditionsTableTableProcessedTableManager get conditionsTableRefs {
    final manager = $$ConditionsTableTableTableManager(
      $_db,
      $_db.conditionsTable,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _conditionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InventoryTableTable, List<InventoryTableData>>
  _inventoryTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventoryTable,
    aliasName: 'characters_table__id__inventory_table__character_id',
  );

  $$InventoryTableTableProcessedTableManager get inventoryTableRefs {
    final manager = $$InventoryTableTableTableManager(
      $_db,
      $_db.inventoryTable,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CharactersTableTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTableTable> {
  $$CharactersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemId => $composableBuilder(
    column: $table.systemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portraitUri => $composableBuilder(
    column: $table.portraitUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawPropertiesJson => $composableBuilder(
    column: $table.rawPropertiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> conditionsTableRefs(
    Expression<bool> Function($$ConditionsTableTableFilterComposer f) f,
  ) {
    final $$ConditionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.conditionsTable,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConditionsTableTableFilterComposer(
            $db: $db,
            $table: $db.conditionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventoryTableRefs(
    Expression<bool> Function($$InventoryTableTableFilterComposer f) f,
  ) {
    final $$InventoryTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryTable,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryTableTableFilterComposer(
            $db: $db,
            $table: $db.inventoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharactersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTableTable> {
  $$CharactersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemId => $composableBuilder(
    column: $table.systemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portraitUri => $composableBuilder(
    column: $table.portraitUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawPropertiesJson => $composableBuilder(
    column: $table.rawPropertiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CharactersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTableTable> {
  $$CharactersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get systemId =>
      $composableBuilder(column: $table.systemId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get portraitUri => $composableBuilder(
    column: $table.portraitUri,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawPropertiesJson => $composableBuilder(
    column: $table.rawPropertiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> conditionsTableRefs<T extends Object>(
    Expression<T> Function($$ConditionsTableTableAnnotationComposer a) f,
  ) {
    final $$ConditionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.conditionsTable,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConditionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.conditionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventoryTableRefs<T extends Object>(
    Expression<T> Function($$InventoryTableTableAnnotationComposer a) f,
  ) {
    final $$InventoryTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventoryTable,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryTableTableAnnotationComposer(
            $db: $db,
            $table: $db.inventoryTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharactersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharactersTableTable,
          CharactersTableData,
          $$CharactersTableTableFilterComposer,
          $$CharactersTableTableOrderingComposer,
          $$CharactersTableTableAnnotationComposer,
          $$CharactersTableTableCreateCompanionBuilder,
          $$CharactersTableTableUpdateCompanionBuilder,
          (CharactersTableData, $$CharactersTableTableReferences),
          CharactersTableData,
          PrefetchHooks Function({
            bool conditionsTableRefs,
            bool inventoryTableRefs,
          })
        > {
  $$CharactersTableTableTableManager(
    _$AppDatabase db,
    $CharactersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> systemId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> portraitUri = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastPlayedAt = const Value.absent(),
                Value<String> rawPropertiesJson = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersTableCompanion(
                id: id,
                systemId: systemId,
                name: name,
                portraitUri: portraitUri,
                createdAt: createdAt,
                lastPlayedAt: lastPlayedAt,
                rawPropertiesJson: rawPropertiesJson,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> systemId = const Value.absent(),
                required String name,
                Value<String?> portraitUri = const Value.absent(),
                required DateTime createdAt,
                required DateTime lastPlayedAt,
                required String rawPropertiesJson,
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersTableCompanion.insert(
                id: id,
                systemId: systemId,
                name: name,
                portraitUri: portraitUri,
                createdAt: createdAt,
                lastPlayedAt: lastPlayedAt,
                rawPropertiesJson: rawPropertiesJson,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharactersTableTable, CharactersTableData>(
                    table,
                  ),
                  $$CharactersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({conditionsTableRefs = false, inventoryTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (conditionsTableRefs) db.conditionsTable,
                    if (inventoryTableRefs) db.inventoryTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (conditionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          CharactersTableData,
                          $CharactersTableTable,
                          ConditionsTableData,
                          $ConditionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableTableReferences
                              ._conditionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).conditionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'character_id',
                          typedResults: items,
                        ),
                      if (inventoryTableRefs)
                        await $_getPrefetchedDataByColumns<
                          CharactersTableData,
                          $CharactersTableTable,
                          InventoryTableData,
                          $InventoryTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableTableReferences
                              ._inventoryTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).inventoryTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'character_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CharactersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharactersTableTable,
      CharactersTableData,
      $$CharactersTableTableFilterComposer,
      $$CharactersTableTableOrderingComposer,
      $$CharactersTableTableAnnotationComposer,
      $$CharactersTableTableCreateCompanionBuilder,
      $$CharactersTableTableUpdateCompanionBuilder,
      (CharactersTableData, $$CharactersTableTableReferences),
      CharactersTableData,
      PrefetchHooks Function({
        bool conditionsTableRefs,
        bool inventoryTableRefs,
      })
    >;
typedef $$ConditionsTableTableCreateCompanionBuilder =
    ConditionsTableCompanion Function({
      required String id,
      required String characterId,
      required String conditionId,
      Value<int?> durationRounds,
      Value<String> customNotes,
      Value<int> rowid,
    });
typedef $$ConditionsTableTableUpdateCompanionBuilder =
    ConditionsTableCompanion Function({
      Value<String> id,
      Value<String> characterId,
      Value<String> conditionId,
      Value<int?> durationRounds,
      Value<String> customNotes,
      Value<int> rowid,
    });

final class $$ConditionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ConditionsTableTable,
          ConditionsTableData
        > {
  $$ConditionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTableTable _characterIdTable(_$AppDatabase db) => db
      .charactersTable
      .createAlias('conditions_table__character_id__characters_table__id');

  $$CharactersTableTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableTableManager(
      $_db,
      $_db.charactersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConditionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConditionsTableTable> {
  $$ConditionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionId => $composableBuilder(
    column: $table.conditionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationRounds => $composableBuilder(
    column: $table.durationRounds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customNotes => $composableBuilder(
    column: $table.customNotes,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableTableFilterComposer get characterId {
    final $$CharactersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.charactersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableTableFilterComposer(
            $db: $db,
            $table: $db.charactersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConditionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConditionsTableTable> {
  $$ConditionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionId => $composableBuilder(
    column: $table.conditionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationRounds => $composableBuilder(
    column: $table.durationRounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customNotes => $composableBuilder(
    column: $table.customNotes,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableTableOrderingComposer get characterId {
    final $$CharactersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.charactersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableTableOrderingComposer(
            $db: $db,
            $table: $db.charactersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConditionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConditionsTableTable> {
  $$ConditionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conditionId => $composableBuilder(
    column: $table.conditionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationRounds => $composableBuilder(
    column: $table.durationRounds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customNotes => $composableBuilder(
    column: $table.customNotes,
    builder: (column) => column,
  );

  $$CharactersTableTableAnnotationComposer get characterId {
    final $$CharactersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.charactersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.charactersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConditionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConditionsTableTable,
          ConditionsTableData,
          $$ConditionsTableTableFilterComposer,
          $$ConditionsTableTableOrderingComposer,
          $$ConditionsTableTableAnnotationComposer,
          $$ConditionsTableTableCreateCompanionBuilder,
          $$ConditionsTableTableUpdateCompanionBuilder,
          (ConditionsTableData, $$ConditionsTableTableReferences),
          ConditionsTableData,
          PrefetchHooks Function({bool characterId})
        > {
  $$ConditionsTableTableTableManager(
    _$AppDatabase db,
    $ConditionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConditionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConditionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConditionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> characterId = const Value.absent(),
                Value<String> conditionId = const Value.absent(),
                Value<int?> durationRounds = const Value.absent(),
                Value<String> customNotes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConditionsTableCompanion(
                id: id,
                characterId: characterId,
                conditionId: conditionId,
                durationRounds: durationRounds,
                customNotes: customNotes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String characterId,
                required String conditionId,
                Value<int?> durationRounds = const Value.absent(),
                Value<String> customNotes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConditionsTableCompanion.insert(
                id: id,
                characterId: characterId,
                conditionId: conditionId,
                durationRounds: durationRounds,
                customNotes: customNotes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConditionsTableTable, ConditionsTableData>(
                    table,
                  ),
                  $$ConditionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$ConditionsTableTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$ConditionsTableTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ConditionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConditionsTableTable,
      ConditionsTableData,
      $$ConditionsTableTableFilterComposer,
      $$ConditionsTableTableOrderingComposer,
      $$ConditionsTableTableAnnotationComposer,
      $$ConditionsTableTableCreateCompanionBuilder,
      $$ConditionsTableTableUpdateCompanionBuilder,
      (ConditionsTableData, $$ConditionsTableTableReferences),
      ConditionsTableData,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$InventoryTableTableCreateCompanionBuilder =
    InventoryTableCompanion Function({
      required String id,
      required String characterId,
      required String name,
      Value<int> quantity,
      Value<double> weight,
      Value<bool> isEquipped,
      Value<bool> isAttuned,
      Value<String> containerName,
      Value<String> itemDataJson,
      Value<int> rowid,
    });
typedef $$InventoryTableTableUpdateCompanionBuilder =
    InventoryTableCompanion Function({
      Value<String> id,
      Value<String> characterId,
      Value<String> name,
      Value<int> quantity,
      Value<double> weight,
      Value<bool> isEquipped,
      Value<bool> isAttuned,
      Value<String> containerName,
      Value<String> itemDataJson,
      Value<int> rowid,
    });

final class $$InventoryTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InventoryTableTable,
          InventoryTableData
        > {
  $$InventoryTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTableTable _characterIdTable(_$AppDatabase db) => db
      .charactersTable
      .createAlias('inventory_table__character_id__characters_table__id');

  $$CharactersTableTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableTableManager(
      $_db,
      $_db.charactersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InventoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryTableTable> {
  $$InventoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEquipped => $composableBuilder(
    column: $table.isEquipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAttuned => $composableBuilder(
    column: $table.isAttuned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get containerName => $composableBuilder(
    column: $table.containerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemDataJson => $composableBuilder(
    column: $table.itemDataJson,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableTableFilterComposer get characterId {
    final $$CharactersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.charactersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableTableFilterComposer(
            $db: $db,
            $table: $db.charactersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryTableTable> {
  $$InventoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEquipped => $composableBuilder(
    column: $table.isEquipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAttuned => $composableBuilder(
    column: $table.isAttuned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get containerName => $composableBuilder(
    column: $table.containerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemDataJson => $composableBuilder(
    column: $table.itemDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableTableOrderingComposer get characterId {
    final $$CharactersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.charactersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableTableOrderingComposer(
            $db: $db,
            $table: $db.charactersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryTableTable> {
  $$InventoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<bool> get isEquipped => $composableBuilder(
    column: $table.isEquipped,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAttuned =>
      $composableBuilder(column: $table.isAttuned, builder: (column) => column);

  GeneratedColumn<String> get containerName => $composableBuilder(
    column: $table.containerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemDataJson => $composableBuilder(
    column: $table.itemDataJson,
    builder: (column) => column,
  );

  $$CharactersTableTableAnnotationComposer get characterId {
    final $$CharactersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.charactersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.charactersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryTableTable,
          InventoryTableData,
          $$InventoryTableTableFilterComposer,
          $$InventoryTableTableOrderingComposer,
          $$InventoryTableTableAnnotationComposer,
          $$InventoryTableTableCreateCompanionBuilder,
          $$InventoryTableTableUpdateCompanionBuilder,
          (InventoryTableData, $$InventoryTableTableReferences),
          InventoryTableData,
          PrefetchHooks Function({bool characterId})
        > {
  $$InventoryTableTableTableManager(
    _$AppDatabase db,
    $InventoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> characterId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<bool> isEquipped = const Value.absent(),
                Value<bool> isAttuned = const Value.absent(),
                Value<String> containerName = const Value.absent(),
                Value<String> itemDataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryTableCompanion(
                id: id,
                characterId: characterId,
                name: name,
                quantity: quantity,
                weight: weight,
                isEquipped: isEquipped,
                isAttuned: isAttuned,
                containerName: containerName,
                itemDataJson: itemDataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String characterId,
                required String name,
                Value<int> quantity = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<bool> isEquipped = const Value.absent(),
                Value<bool> isAttuned = const Value.absent(),
                Value<String> containerName = const Value.absent(),
                Value<String> itemDataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryTableCompanion.insert(
                id: id,
                characterId: characterId,
                name: name,
                quantity: quantity,
                weight: weight,
                isEquipped: isEquipped,
                isAttuned: isAttuned,
                containerName: containerName,
                itemDataJson: itemDataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InventoryTableTable, InventoryTableData>(table),
                  $$InventoryTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable: $$InventoryTableTableReferences
                                    ._characterIdTable(db),
                                referencedColumn:
                                    $$InventoryTableTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InventoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryTableTable,
      InventoryTableData,
      $$InventoryTableTableFilterComposer,
      $$InventoryTableTableOrderingComposer,
      $$InventoryTableTableAnnotationComposer,
      $$InventoryTableTableCreateCompanionBuilder,
      $$InventoryTableTableUpdateCompanionBuilder,
      (InventoryTableData, $$InventoryTableTableReferences),
      InventoryTableData,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CompendiumTableTableCreateCompanionBuilder =
    CompendiumTableCompanion Function({
      required String id,
      required String systemId,
      required String category,
      required String name,
      Value<String> summary,
      Value<String> fullDataJson,
      Value<int> rowid,
    });
typedef $$CompendiumTableTableUpdateCompanionBuilder =
    CompendiumTableCompanion Function({
      Value<String> id,
      Value<String> systemId,
      Value<String> category,
      Value<String> name,
      Value<String> summary,
      Value<String> fullDataJson,
      Value<int> rowid,
    });

class $$CompendiumTableTableFilterComposer
    extends Composer<_$AppDatabase, $CompendiumTableTable> {
  $$CompendiumTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemId => $composableBuilder(
    column: $table.systemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullDataJson => $composableBuilder(
    column: $table.fullDataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompendiumTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CompendiumTableTable> {
  $$CompendiumTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemId => $composableBuilder(
    column: $table.systemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullDataJson => $composableBuilder(
    column: $table.fullDataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompendiumTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompendiumTableTable> {
  $$CompendiumTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get systemId =>
      $composableBuilder(column: $table.systemId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get fullDataJson => $composableBuilder(
    column: $table.fullDataJson,
    builder: (column) => column,
  );
}

class $$CompendiumTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompendiumTableTable,
          CompendiumTableData,
          $$CompendiumTableTableFilterComposer,
          $$CompendiumTableTableOrderingComposer,
          $$CompendiumTableTableAnnotationComposer,
          $$CompendiumTableTableCreateCompanionBuilder,
          $$CompendiumTableTableUpdateCompanionBuilder,
          (
            CompendiumTableData,
            BaseReferences<
              _$AppDatabase,
              $CompendiumTableTable,
              CompendiumTableData
            >,
          ),
          CompendiumTableData,
          PrefetchHooks Function()
        > {
  $$CompendiumTableTableTableManager(
    _$AppDatabase db,
    $CompendiumTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompendiumTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompendiumTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompendiumTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> systemId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> fullDataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompendiumTableCompanion(
                id: id,
                systemId: systemId,
                category: category,
                name: name,
                summary: summary,
                fullDataJson: fullDataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String systemId,
                required String category,
                required String name,
                Value<String> summary = const Value.absent(),
                Value<String> fullDataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompendiumTableCompanion.insert(
                id: id,
                systemId: systemId,
                category: category,
                name: name,
                summary: summary,
                fullDataJson: fullDataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CompendiumTableTable, CompendiumTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CompendiumTableTable,
                    CompendiumTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompendiumTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompendiumTableTable,
      CompendiumTableData,
      $$CompendiumTableTableFilterComposer,
      $$CompendiumTableTableOrderingComposer,
      $$CompendiumTableTableAnnotationComposer,
      $$CompendiumTableTableCreateCompanionBuilder,
      $$CompendiumTableTableUpdateCompanionBuilder,
      (
        CompendiumTableData,
        BaseReferences<
          _$AppDatabase,
          $CompendiumTableTable,
          CompendiumTableData
        >,
      ),
      CompendiumTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CharactersTableTableTableManager get charactersTable =>
      $$CharactersTableTableTableManager(_db, _db.charactersTable);
  $$ConditionsTableTableTableManager get conditionsTable =>
      $$ConditionsTableTableTableManager(_db, _db.conditionsTable);
  $$InventoryTableTableTableManager get inventoryTable =>
      $$InventoryTableTableTableManager(_db, _db.inventoryTable);
  $$CompendiumTableTableTableManager get compendiumTable =>
      $$CompendiumTableTableTableManager(_db, _db.compendiumTable);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, Character> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameJpMeta = const VerificationMeta('nameJp');
  @override
  late final GeneratedColumn<String> nameJp = GeneratedColumn<String>(
      'name_jp', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personalityMeta =
      const VerificationMeta('personality');
  @override
  late final GeneratedColumn<String> personality = GeneratedColumn<String>(
      'personality', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _spriteFolderMeta =
      const VerificationMeta('spriteFolder');
  @override
  late final GeneratedColumn<String> spriteFolder = GeneratedColumn<String>(
      'sprite_folder', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nameJp,
        nameEn,
        personality,
        avatarPath,
        spriteFolder,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(Insertable<Character> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_jp')) {
      context.handle(_nameJpMeta,
          nameJp.isAcceptableOrUnknown(data['name_jp']!, _nameJpMeta));
    } else if (isInserting) {
      context.missing(_nameJpMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('personality')) {
      context.handle(
          _personalityMeta,
          personality.isAcceptableOrUnknown(
              data['personality']!, _personalityMeta));
    } else if (isInserting) {
      context.missing(_personalityMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    } else if (isInserting) {
      context.missing(_avatarPathMeta);
    }
    if (data.containsKey('sprite_folder')) {
      context.handle(
          _spriteFolderMeta,
          spriteFolder.isAcceptableOrUnknown(
              data['sprite_folder']!, _spriteFolderMeta));
    } else if (isInserting) {
      context.missing(_spriteFolderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Character map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Character(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nameJp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_jp'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      personality: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}personality'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path'])!,
      spriteFolder: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sprite_folder'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }
}

class Character extends DataClass implements Insertable<Character> {
  /// Primary key
  final int id;

  /// Character's Japanese name
  final String nameJp;

  /// Character's English name
  final String nameEn;

  /// Brief personality description
  final String personality;

  /// Path to character avatar image
  final String avatarPath;

  /// Folder containing character sprites
  final String spriteFolder;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;
  const Character(
      {required this.id,
      required this.nameJp,
      required this.nameEn,
      required this.personality,
      required this.avatarPath,
      required this.spriteFolder,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_jp'] = Variable<String>(nameJp);
    map['name_en'] = Variable<String>(nameEn);
    map['personality'] = Variable<String>(personality);
    map['avatar_path'] = Variable<String>(avatarPath);
    map['sprite_folder'] = Variable<String>(spriteFolder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      id: Value(id),
      nameJp: Value(nameJp),
      nameEn: Value(nameEn),
      personality: Value(personality),
      avatarPath: Value(avatarPath),
      spriteFolder: Value(spriteFolder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Character.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Character(
      id: serializer.fromJson<int>(json['id']),
      nameJp: serializer.fromJson<String>(json['nameJp']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      personality: serializer.fromJson<String>(json['personality']),
      avatarPath: serializer.fromJson<String>(json['avatarPath']),
      spriteFolder: serializer.fromJson<String>(json['spriteFolder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameJp': serializer.toJson<String>(nameJp),
      'nameEn': serializer.toJson<String>(nameEn),
      'personality': serializer.toJson<String>(personality),
      'avatarPath': serializer.toJson<String>(avatarPath),
      'spriteFolder': serializer.toJson<String>(spriteFolder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Character copyWith(
          {int? id,
          String? nameJp,
          String? nameEn,
          String? personality,
          String? avatarPath,
          String? spriteFolder,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Character(
        id: id ?? this.id,
        nameJp: nameJp ?? this.nameJp,
        nameEn: nameEn ?? this.nameEn,
        personality: personality ?? this.personality,
        avatarPath: avatarPath ?? this.avatarPath,
        spriteFolder: spriteFolder ?? this.spriteFolder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Character copyWithCompanion(CharactersCompanion data) {
    return Character(
      id: data.id.present ? data.id.value : this.id,
      nameJp: data.nameJp.present ? data.nameJp.value : this.nameJp,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      personality:
          data.personality.present ? data.personality.value : this.personality,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      spriteFolder: data.spriteFolder.present
          ? data.spriteFolder.value
          : this.spriteFolder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Character(')
          ..write('id: $id, ')
          ..write('nameJp: $nameJp, ')
          ..write('nameEn: $nameEn, ')
          ..write('personality: $personality, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('spriteFolder: $spriteFolder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameJp, nameEn, personality, avatarPath,
      spriteFolder, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Character &&
          other.id == this.id &&
          other.nameJp == this.nameJp &&
          other.nameEn == this.nameEn &&
          other.personality == this.personality &&
          other.avatarPath == this.avatarPath &&
          other.spriteFolder == this.spriteFolder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CharactersCompanion extends UpdateCompanion<Character> {
  final Value<int> id;
  final Value<String> nameJp;
  final Value<String> nameEn;
  final Value<String> personality;
  final Value<String> avatarPath;
  final Value<String> spriteFolder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CharactersCompanion({
    this.id = const Value.absent(),
    this.nameJp = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.personality = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.spriteFolder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CharactersCompanion.insert({
    this.id = const Value.absent(),
    required String nameJp,
    required String nameEn,
    required String personality,
    required String avatarPath,
    required String spriteFolder,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : nameJp = Value(nameJp),
        nameEn = Value(nameEn),
        personality = Value(personality),
        avatarPath = Value(avatarPath),
        spriteFolder = Value(spriteFolder);
  static Insertable<Character> custom({
    Expression<int>? id,
    Expression<String>? nameJp,
    Expression<String>? nameEn,
    Expression<String>? personality,
    Expression<String>? avatarPath,
    Expression<String>? spriteFolder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameJp != null) 'name_jp': nameJp,
      if (nameEn != null) 'name_en': nameEn,
      if (personality != null) 'personality': personality,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (spriteFolder != null) 'sprite_folder': spriteFolder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CharactersCompanion copyWith(
      {Value<int>? id,
      Value<String>? nameJp,
      Value<String>? nameEn,
      Value<String>? personality,
      Value<String>? avatarPath,
      Value<String>? spriteFolder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CharactersCompanion(
      id: id ?? this.id,
      nameJp: nameJp ?? this.nameJp,
      nameEn: nameEn ?? this.nameEn,
      personality: personality ?? this.personality,
      avatarPath: avatarPath ?? this.avatarPath,
      spriteFolder: spriteFolder ?? this.spriteFolder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameJp.present) {
      map['name_jp'] = Variable<String>(nameJp.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (personality.present) {
      map['personality'] = Variable<String>(personality.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (spriteFolder.present) {
      map['sprite_folder'] = Variable<String>(spriteFolder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('id: $id, ')
          ..write('nameJp: $nameJp, ')
          ..write('nameEn: $nameEn, ')
          ..write('personality: $personality, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('spriteFolder: $spriteFolder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SaveGamesTable extends SaveGames
    with TableInfo<$SaveGamesTable, SaveGame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaveGamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _slotIdMeta = const VerificationMeta('slotId');
  @override
  late final GeneratedColumn<int> slotId = GeneratedColumn<int>(
      'slot_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _playerNameMeta =
      const VerificationMeta('playerName');
  @override
  late final GeneratedColumn<String> playerName = GeneratedColumn<String>(
      'player_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentChapterMeta =
      const VerificationMeta('currentChapter');
  @override
  late final GeneratedColumn<String> currentChapter = GeneratedColumn<String>(
      'current_chapter', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentSceneMeta =
      const VerificationMeta('currentScene');
  @override
  late final GeneratedColumn<String> currentScene = GeneratedColumn<String>(
      'current_scene', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _playTimeSecondsMeta =
      const VerificationMeta('playTimeSeconds');
  @override
  late final GeneratedColumn<int> playTimeSeconds = GeneratedColumn<int>(
      'play_time_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastSavedAtMeta =
      const VerificationMeta('lastSavedAt');
  @override
  late final GeneratedColumn<DateTime> lastSavedAt = GeneratedColumn<DateTime>(
      'last_saved_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _thumbnailPathMeta =
      const VerificationMeta('thumbnailPath');
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
      'thumbnail_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _settingsJsonMeta =
      const VerificationMeta('settingsJson');
  @override
  late final GeneratedColumn<String> settingsJson = GeneratedColumn<String>(
      'settings_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        slotId,
        playerName,
        currentChapter,
        currentScene,
        playTimeSeconds,
        lastSavedAt,
        thumbnailPath,
        settingsJson,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'save_games';
  @override
  VerificationContext validateIntegrity(Insertable<SaveGame> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slot_id')) {
      context.handle(_slotIdMeta,
          slotId.isAcceptableOrUnknown(data['slot_id']!, _slotIdMeta));
    } else if (isInserting) {
      context.missing(_slotIdMeta);
    }
    if (data.containsKey('player_name')) {
      context.handle(
          _playerNameMeta,
          playerName.isAcceptableOrUnknown(
              data['player_name']!, _playerNameMeta));
    } else if (isInserting) {
      context.missing(_playerNameMeta);
    }
    if (data.containsKey('current_chapter')) {
      context.handle(
          _currentChapterMeta,
          currentChapter.isAcceptableOrUnknown(
              data['current_chapter']!, _currentChapterMeta));
    } else if (isInserting) {
      context.missing(_currentChapterMeta);
    }
    if (data.containsKey('current_scene')) {
      context.handle(
          _currentSceneMeta,
          currentScene.isAcceptableOrUnknown(
              data['current_scene']!, _currentSceneMeta));
    } else if (isInserting) {
      context.missing(_currentSceneMeta);
    }
    if (data.containsKey('play_time_seconds')) {
      context.handle(
          _playTimeSecondsMeta,
          playTimeSeconds.isAcceptableOrUnknown(
              data['play_time_seconds']!, _playTimeSecondsMeta));
    }
    if (data.containsKey('last_saved_at')) {
      context.handle(
          _lastSavedAtMeta,
          lastSavedAt.isAcceptableOrUnknown(
              data['last_saved_at']!, _lastSavedAtMeta));
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
          _thumbnailPathMeta,
          thumbnailPath.isAcceptableOrUnknown(
              data['thumbnail_path']!, _thumbnailPathMeta));
    }
    if (data.containsKey('settings_json')) {
      context.handle(
          _settingsJsonMeta,
          settingsJson.isAcceptableOrUnknown(
              data['settings_json']!, _settingsJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {slotId},
      ];
  @override
  SaveGame map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaveGame(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      slotId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slot_id'])!,
      playerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}player_name'])!,
      currentChapter: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_chapter'])!,
      currentScene: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_scene'])!,
      playTimeSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}play_time_seconds'])!,
      lastSavedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_saved_at'])!,
      thumbnailPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_path']),
      settingsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}settings_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SaveGamesTable createAlias(String alias) {
    return $SaveGamesTable(attachedDatabase, alias);
  }
}

class SaveGame extends DataClass implements Insertable<SaveGame> {
  /// Primary key
  final int id;

  /// Save slot number (1-10)
  final int slotId;

  /// Player's chosen name
  final String playerName;

  /// Current chapter ID
  final String currentChapter;

  /// Current scene ID within the chapter
  final String currentScene;

  /// Total play time in seconds
  final int playTimeSeconds;

  /// Last time the game was saved
  final DateTime lastSavedAt;

  /// Path to save thumbnail image
  final String? thumbnailPath;

  /// Game settings as JSON string
  final String settingsJson;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;
  const SaveGame(
      {required this.id,
      required this.slotId,
      required this.playerName,
      required this.currentChapter,
      required this.currentScene,
      required this.playTimeSeconds,
      required this.lastSavedAt,
      this.thumbnailPath,
      required this.settingsJson,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slot_id'] = Variable<int>(slotId);
    map['player_name'] = Variable<String>(playerName);
    map['current_chapter'] = Variable<String>(currentChapter);
    map['current_scene'] = Variable<String>(currentScene);
    map['play_time_seconds'] = Variable<int>(playTimeSeconds);
    map['last_saved_at'] = Variable<DateTime>(lastSavedAt);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    map['settings_json'] = Variable<String>(settingsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SaveGamesCompanion toCompanion(bool nullToAbsent) {
    return SaveGamesCompanion(
      id: Value(id),
      slotId: Value(slotId),
      playerName: Value(playerName),
      currentChapter: Value(currentChapter),
      currentScene: Value(currentScene),
      playTimeSeconds: Value(playTimeSeconds),
      lastSavedAt: Value(lastSavedAt),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      settingsJson: Value(settingsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SaveGame.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaveGame(
      id: serializer.fromJson<int>(json['id']),
      slotId: serializer.fromJson<int>(json['slotId']),
      playerName: serializer.fromJson<String>(json['playerName']),
      currentChapter: serializer.fromJson<String>(json['currentChapter']),
      currentScene: serializer.fromJson<String>(json['currentScene']),
      playTimeSeconds: serializer.fromJson<int>(json['playTimeSeconds']),
      lastSavedAt: serializer.fromJson<DateTime>(json['lastSavedAt']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      settingsJson: serializer.fromJson<String>(json['settingsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slotId': serializer.toJson<int>(slotId),
      'playerName': serializer.toJson<String>(playerName),
      'currentChapter': serializer.toJson<String>(currentChapter),
      'currentScene': serializer.toJson<String>(currentScene),
      'playTimeSeconds': serializer.toJson<int>(playTimeSeconds),
      'lastSavedAt': serializer.toJson<DateTime>(lastSavedAt),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'settingsJson': serializer.toJson<String>(settingsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SaveGame copyWith(
          {int? id,
          int? slotId,
          String? playerName,
          String? currentChapter,
          String? currentScene,
          int? playTimeSeconds,
          DateTime? lastSavedAt,
          Value<String?> thumbnailPath = const Value.absent(),
          String? settingsJson,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SaveGame(
        id: id ?? this.id,
        slotId: slotId ?? this.slotId,
        playerName: playerName ?? this.playerName,
        currentChapter: currentChapter ?? this.currentChapter,
        currentScene: currentScene ?? this.currentScene,
        playTimeSeconds: playTimeSeconds ?? this.playTimeSeconds,
        lastSavedAt: lastSavedAt ?? this.lastSavedAt,
        thumbnailPath:
            thumbnailPath.present ? thumbnailPath.value : this.thumbnailPath,
        settingsJson: settingsJson ?? this.settingsJson,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SaveGame copyWithCompanion(SaveGamesCompanion data) {
    return SaveGame(
      id: data.id.present ? data.id.value : this.id,
      slotId: data.slotId.present ? data.slotId.value : this.slotId,
      playerName:
          data.playerName.present ? data.playerName.value : this.playerName,
      currentChapter: data.currentChapter.present
          ? data.currentChapter.value
          : this.currentChapter,
      currentScene: data.currentScene.present
          ? data.currentScene.value
          : this.currentScene,
      playTimeSeconds: data.playTimeSeconds.present
          ? data.playTimeSeconds.value
          : this.playTimeSeconds,
      lastSavedAt:
          data.lastSavedAt.present ? data.lastSavedAt.value : this.lastSavedAt,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      settingsJson: data.settingsJson.present
          ? data.settingsJson.value
          : this.settingsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaveGame(')
          ..write('id: $id, ')
          ..write('slotId: $slotId, ')
          ..write('playerName: $playerName, ')
          ..write('currentChapter: $currentChapter, ')
          ..write('currentScene: $currentScene, ')
          ..write('playTimeSeconds: $playTimeSeconds, ')
          ..write('lastSavedAt: $lastSavedAt, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      slotId,
      playerName,
      currentChapter,
      currentScene,
      playTimeSeconds,
      lastSavedAt,
      thumbnailPath,
      settingsJson,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaveGame &&
          other.id == this.id &&
          other.slotId == this.slotId &&
          other.playerName == this.playerName &&
          other.currentChapter == this.currentChapter &&
          other.currentScene == this.currentScene &&
          other.playTimeSeconds == this.playTimeSeconds &&
          other.lastSavedAt == this.lastSavedAt &&
          other.thumbnailPath == this.thumbnailPath &&
          other.settingsJson == this.settingsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SaveGamesCompanion extends UpdateCompanion<SaveGame> {
  final Value<int> id;
  final Value<int> slotId;
  final Value<String> playerName;
  final Value<String> currentChapter;
  final Value<String> currentScene;
  final Value<int> playTimeSeconds;
  final Value<DateTime> lastSavedAt;
  final Value<String?> thumbnailPath;
  final Value<String> settingsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SaveGamesCompanion({
    this.id = const Value.absent(),
    this.slotId = const Value.absent(),
    this.playerName = const Value.absent(),
    this.currentChapter = const Value.absent(),
    this.currentScene = const Value.absent(),
    this.playTimeSeconds = const Value.absent(),
    this.lastSavedAt = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.settingsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SaveGamesCompanion.insert({
    this.id = const Value.absent(),
    required int slotId,
    required String playerName,
    required String currentChapter,
    required String currentScene,
    this.playTimeSeconds = const Value.absent(),
    this.lastSavedAt = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.settingsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : slotId = Value(slotId),
        playerName = Value(playerName),
        currentChapter = Value(currentChapter),
        currentScene = Value(currentScene);
  static Insertable<SaveGame> custom({
    Expression<int>? id,
    Expression<int>? slotId,
    Expression<String>? playerName,
    Expression<String>? currentChapter,
    Expression<String>? currentScene,
    Expression<int>? playTimeSeconds,
    Expression<DateTime>? lastSavedAt,
    Expression<String>? thumbnailPath,
    Expression<String>? settingsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slotId != null) 'slot_id': slotId,
      if (playerName != null) 'player_name': playerName,
      if (currentChapter != null) 'current_chapter': currentChapter,
      if (currentScene != null) 'current_scene': currentScene,
      if (playTimeSeconds != null) 'play_time_seconds': playTimeSeconds,
      if (lastSavedAt != null) 'last_saved_at': lastSavedAt,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (settingsJson != null) 'settings_json': settingsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SaveGamesCompanion copyWith(
      {Value<int>? id,
      Value<int>? slotId,
      Value<String>? playerName,
      Value<String>? currentChapter,
      Value<String>? currentScene,
      Value<int>? playTimeSeconds,
      Value<DateTime>? lastSavedAt,
      Value<String?>? thumbnailPath,
      Value<String>? settingsJson,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return SaveGamesCompanion(
      id: id ?? this.id,
      slotId: slotId ?? this.slotId,
      playerName: playerName ?? this.playerName,
      currentChapter: currentChapter ?? this.currentChapter,
      currentScene: currentScene ?? this.currentScene,
      playTimeSeconds: playTimeSeconds ?? this.playTimeSeconds,
      lastSavedAt: lastSavedAt ?? this.lastSavedAt,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      settingsJson: settingsJson ?? this.settingsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slotId.present) {
      map['slot_id'] = Variable<int>(slotId.value);
    }
    if (playerName.present) {
      map['player_name'] = Variable<String>(playerName.value);
    }
    if (currentChapter.present) {
      map['current_chapter'] = Variable<String>(currentChapter.value);
    }
    if (currentScene.present) {
      map['current_scene'] = Variable<String>(currentScene.value);
    }
    if (playTimeSeconds.present) {
      map['play_time_seconds'] = Variable<int>(playTimeSeconds.value);
    }
    if (lastSavedAt.present) {
      map['last_saved_at'] = Variable<DateTime>(lastSavedAt.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (settingsJson.present) {
      map['settings_json'] = Variable<String>(settingsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaveGamesCompanion(')
          ..write('id: $id, ')
          ..write('slotId: $slotId, ')
          ..write('playerName: $playerName, ')
          ..write('currentChapter: $currentChapter, ')
          ..write('currentScene: $currentScene, ')
          ..write('playTimeSeconds: $playTimeSeconds, ')
          ..write('lastSavedAt: $lastSavedAt, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RelationshipsTable extends Relationships
    with TableInfo<$RelationshipsTable, Relationship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saveGameIdMeta =
      const VerificationMeta('saveGameId');
  @override
  late final GeneratedColumn<int> saveGameId = GeneratedColumn<int>(
      'save_game_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES save_games (id) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _characterIdMeta =
      const VerificationMeta('characterId');
  @override
  late final GeneratedColumn<int> characterId = GeneratedColumn<int>(
      'character_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES characters (id) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _kizunaPointsMeta =
      const VerificationMeta('kizunaPoints');
  @override
  late final GeneratedColumn<int> kizunaPoints = GeneratedColumn<int>(
      'kizuna_points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, saveGameId, characterId, kizunaPoints, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relationships';
  @override
  VerificationContext validateIntegrity(Insertable<Relationship> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('save_game_id')) {
      context.handle(
          _saveGameIdMeta,
          saveGameId.isAcceptableOrUnknown(
              data['save_game_id']!, _saveGameIdMeta));
    } else if (isInserting) {
      context.missing(_saveGameIdMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
          _characterIdMeta,
          characterId.isAcceptableOrUnknown(
              data['character_id']!, _characterIdMeta));
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('kizuna_points')) {
      context.handle(
          _kizunaPointsMeta,
          kizunaPoints.isAcceptableOrUnknown(
              data['kizuna_points']!, _kizunaPointsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {saveGameId, characterId},
      ];
  @override
  Relationship map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Relationship(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saveGameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}save_game_id'])!,
      characterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}character_id'])!,
      kizunaPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kizuna_points'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RelationshipsTable createAlias(String alias) {
    return $RelationshipsTable(attachedDatabase, alias);
  }
}

class Relationship extends DataClass implements Insertable<Relationship> {
  /// Primary key
  final int id;

  /// Reference to save game
  final int saveGameId;

  /// Reference to character
  final int characterId;

  /// Relationship points (Kizuna)
  final int kizunaPoints;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;
  const Relationship(
      {required this.id,
      required this.saveGameId,
      required this.characterId,
      required this.kizunaPoints,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['save_game_id'] = Variable<int>(saveGameId);
    map['character_id'] = Variable<int>(characterId);
    map['kizuna_points'] = Variable<int>(kizunaPoints);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RelationshipsCompanion toCompanion(bool nullToAbsent) {
    return RelationshipsCompanion(
      id: Value(id),
      saveGameId: Value(saveGameId),
      characterId: Value(characterId),
      kizunaPoints: Value(kizunaPoints),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Relationship.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Relationship(
      id: serializer.fromJson<int>(json['id']),
      saveGameId: serializer.fromJson<int>(json['saveGameId']),
      characterId: serializer.fromJson<int>(json['characterId']),
      kizunaPoints: serializer.fromJson<int>(json['kizunaPoints']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saveGameId': serializer.toJson<int>(saveGameId),
      'characterId': serializer.toJson<int>(characterId),
      'kizunaPoints': serializer.toJson<int>(kizunaPoints),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Relationship copyWith(
          {int? id,
          int? saveGameId,
          int? characterId,
          int? kizunaPoints,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Relationship(
        id: id ?? this.id,
        saveGameId: saveGameId ?? this.saveGameId,
        characterId: characterId ?? this.characterId,
        kizunaPoints: kizunaPoints ?? this.kizunaPoints,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Relationship copyWithCompanion(RelationshipsCompanion data) {
    return Relationship(
      id: data.id.present ? data.id.value : this.id,
      saveGameId:
          data.saveGameId.present ? data.saveGameId.value : this.saveGameId,
      characterId:
          data.characterId.present ? data.characterId.value : this.characterId,
      kizunaPoints: data.kizunaPoints.present
          ? data.kizunaPoints.value
          : this.kizunaPoints,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Relationship(')
          ..write('id: $id, ')
          ..write('saveGameId: $saveGameId, ')
          ..write('characterId: $characterId, ')
          ..write('kizunaPoints: $kizunaPoints, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, saveGameId, characterId, kizunaPoints, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Relationship &&
          other.id == this.id &&
          other.saveGameId == this.saveGameId &&
          other.characterId == this.characterId &&
          other.kizunaPoints == this.kizunaPoints &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RelationshipsCompanion extends UpdateCompanion<Relationship> {
  final Value<int> id;
  final Value<int> saveGameId;
  final Value<int> characterId;
  final Value<int> kizunaPoints;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RelationshipsCompanion({
    this.id = const Value.absent(),
    this.saveGameId = const Value.absent(),
    this.characterId = const Value.absent(),
    this.kizunaPoints = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RelationshipsCompanion.insert({
    this.id = const Value.absent(),
    required int saveGameId,
    required int characterId,
    this.kizunaPoints = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : saveGameId = Value(saveGameId),
        characterId = Value(characterId);
  static Insertable<Relationship> custom({
    Expression<int>? id,
    Expression<int>? saveGameId,
    Expression<int>? characterId,
    Expression<int>? kizunaPoints,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saveGameId != null) 'save_game_id': saveGameId,
      if (characterId != null) 'character_id': characterId,
      if (kizunaPoints != null) 'kizuna_points': kizunaPoints,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RelationshipsCompanion copyWith(
      {Value<int>? id,
      Value<int>? saveGameId,
      Value<int>? characterId,
      Value<int>? kizunaPoints,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return RelationshipsCompanion(
      id: id ?? this.id,
      saveGameId: saveGameId ?? this.saveGameId,
      characterId: characterId ?? this.characterId,
      kizunaPoints: kizunaPoints ?? this.kizunaPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saveGameId.present) {
      map['save_game_id'] = Variable<int>(saveGameId.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<int>(characterId.value);
    }
    if (kizunaPoints.present) {
      map['kizuna_points'] = Variable<int>(kizunaPoints.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipsCompanion(')
          ..write('id: $id, ')
          ..write('saveGameId: $saveGameId, ')
          ..write('characterId: $characterId, ')
          ..write('kizunaPoints: $kizunaPoints, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UnlockedVocabularyTable extends UnlockedVocabulary
    with TableInfo<$UnlockedVocabularyTable, UnlockedVocabularyItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockedVocabularyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saveGameIdMeta =
      const VerificationMeta('saveGameId');
  @override
  late final GeneratedColumn<int> saveGameId = GeneratedColumn<int>(
      'save_game_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES save_games (id) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _vocabularyIdMeta =
      const VerificationMeta('vocabularyId');
  @override
  late final GeneratedColumn<int> vocabularyId = GeneratedColumn<int>(
      'vocabulary_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _masteryLevelMeta =
      const VerificationMeta('masteryLevel');
  @override
  late final GeneratedColumn<int> masteryLevel = GeneratedColumn<int>(
      'mastery_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastReviewedMeta =
      const VerificationMeta('lastReviewed');
  @override
  late final GeneratedColumn<DateTime> lastReviewed = GeneratedColumn<DateTime>(
      'last_reviewed', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        saveGameId,
        vocabularyId,
        masteryLevel,
        unlockedAt,
        lastReviewed,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocked_vocabulary';
  @override
  VerificationContext validateIntegrity(
      Insertable<UnlockedVocabularyItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('save_game_id')) {
      context.handle(
          _saveGameIdMeta,
          saveGameId.isAcceptableOrUnknown(
              data['save_game_id']!, _saveGameIdMeta));
    } else if (isInserting) {
      context.missing(_saveGameIdMeta);
    }
    if (data.containsKey('vocabulary_id')) {
      context.handle(
          _vocabularyIdMeta,
          vocabularyId.isAcceptableOrUnknown(
              data['vocabulary_id']!, _vocabularyIdMeta));
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
    }
    if (data.containsKey('mastery_level')) {
      context.handle(
          _masteryLevelMeta,
          masteryLevel.isAcceptableOrUnknown(
              data['mastery_level']!, _masteryLevelMeta));
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    }
    if (data.containsKey('last_reviewed')) {
      context.handle(
          _lastReviewedMeta,
          lastReviewed.isAcceptableOrUnknown(
              data['last_reviewed']!, _lastReviewedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {saveGameId, vocabularyId},
      ];
  @override
  UnlockedVocabularyItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockedVocabularyItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saveGameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}save_game_id'])!,
      vocabularyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vocabulary_id'])!,
      masteryLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mastery_level'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
      lastReviewed: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UnlockedVocabularyTable createAlias(String alias) {
    return $UnlockedVocabularyTable(attachedDatabase, alias);
  }
}

class UnlockedVocabularyItem extends DataClass
    implements Insertable<UnlockedVocabularyItem> {
  /// Primary key
  final int id;

  /// Reference to save game
  final int saveGameId;

  /// Reference to vocabulary item ID (now just an integer, not a foreign key)
  final int vocabularyId;

  /// Mastery level (0: not learned, 1: learning, 2: learned, 3: mastered)
  final int masteryLevel;

  /// When this vocabulary item was first encountered
  final DateTime unlockedAt;

  /// When this vocabulary item was last reviewed
  final DateTime? lastReviewed;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;
  const UnlockedVocabularyItem(
      {required this.id,
      required this.saveGameId,
      required this.vocabularyId,
      required this.masteryLevel,
      required this.unlockedAt,
      this.lastReviewed,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['save_game_id'] = Variable<int>(saveGameId);
    map['vocabulary_id'] = Variable<int>(vocabularyId);
    map['mastery_level'] = Variable<int>(masteryLevel);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    if (!nullToAbsent || lastReviewed != null) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UnlockedVocabularyCompanion toCompanion(bool nullToAbsent) {
    return UnlockedVocabularyCompanion(
      id: Value(id),
      saveGameId: Value(saveGameId),
      vocabularyId: Value(vocabularyId),
      masteryLevel: Value(masteryLevel),
      unlockedAt: Value(unlockedAt),
      lastReviewed: lastReviewed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UnlockedVocabularyItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockedVocabularyItem(
      id: serializer.fromJson<int>(json['id']),
      saveGameId: serializer.fromJson<int>(json['saveGameId']),
      vocabularyId: serializer.fromJson<int>(json['vocabularyId']),
      masteryLevel: serializer.fromJson<int>(json['masteryLevel']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
      lastReviewed: serializer.fromJson<DateTime?>(json['lastReviewed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saveGameId': serializer.toJson<int>(saveGameId),
      'vocabularyId': serializer.toJson<int>(vocabularyId),
      'masteryLevel': serializer.toJson<int>(masteryLevel),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
      'lastReviewed': serializer.toJson<DateTime?>(lastReviewed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UnlockedVocabularyItem copyWith(
          {int? id,
          int? saveGameId,
          int? vocabularyId,
          int? masteryLevel,
          DateTime? unlockedAt,
          Value<DateTime?> lastReviewed = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UnlockedVocabularyItem(
        id: id ?? this.id,
        saveGameId: saveGameId ?? this.saveGameId,
        vocabularyId: vocabularyId ?? this.vocabularyId,
        masteryLevel: masteryLevel ?? this.masteryLevel,
        unlockedAt: unlockedAt ?? this.unlockedAt,
        lastReviewed:
            lastReviewed.present ? lastReviewed.value : this.lastReviewed,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UnlockedVocabularyItem copyWithCompanion(UnlockedVocabularyCompanion data) {
    return UnlockedVocabularyItem(
      id: data.id.present ? data.id.value : this.id,
      saveGameId:
          data.saveGameId.present ? data.saveGameId.value : this.saveGameId,
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      masteryLevel: data.masteryLevel.present
          ? data.masteryLevel.value
          : this.masteryLevel,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
      lastReviewed: data.lastReviewed.present
          ? data.lastReviewed.value
          : this.lastReviewed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedVocabularyItem(')
          ..write('id: $id, ')
          ..write('saveGameId: $saveGameId, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('masteryLevel: $masteryLevel, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, saveGameId, vocabularyId, masteryLevel,
      unlockedAt, lastReviewed, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockedVocabularyItem &&
          other.id == this.id &&
          other.saveGameId == this.saveGameId &&
          other.vocabularyId == this.vocabularyId &&
          other.masteryLevel == this.masteryLevel &&
          other.unlockedAt == this.unlockedAt &&
          other.lastReviewed == this.lastReviewed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UnlockedVocabularyCompanion
    extends UpdateCompanion<UnlockedVocabularyItem> {
  final Value<int> id;
  final Value<int> saveGameId;
  final Value<int> vocabularyId;
  final Value<int> masteryLevel;
  final Value<DateTime> unlockedAt;
  final Value<DateTime?> lastReviewed;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UnlockedVocabularyCompanion({
    this.id = const Value.absent(),
    this.saveGameId = const Value.absent(),
    this.vocabularyId = const Value.absent(),
    this.masteryLevel = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UnlockedVocabularyCompanion.insert({
    this.id = const Value.absent(),
    required int saveGameId,
    required int vocabularyId,
    this.masteryLevel = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.lastReviewed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : saveGameId = Value(saveGameId),
        vocabularyId = Value(vocabularyId);
  static Insertable<UnlockedVocabularyItem> custom({
    Expression<int>? id,
    Expression<int>? saveGameId,
    Expression<int>? vocabularyId,
    Expression<int>? masteryLevel,
    Expression<DateTime>? unlockedAt,
    Expression<DateTime>? lastReviewed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saveGameId != null) 'save_game_id': saveGameId,
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (masteryLevel != null) 'mastery_level': masteryLevel,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (lastReviewed != null) 'last_reviewed': lastReviewed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UnlockedVocabularyCompanion copyWith(
      {Value<int>? id,
      Value<int>? saveGameId,
      Value<int>? vocabularyId,
      Value<int>? masteryLevel,
      Value<DateTime>? unlockedAt,
      Value<DateTime?>? lastReviewed,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UnlockedVocabularyCompanion(
      id: id ?? this.id,
      saveGameId: saveGameId ?? this.saveGameId,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saveGameId.present) {
      map['save_game_id'] = Variable<int>(saveGameId.value);
    }
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<int>(vocabularyId.value);
    }
    if (masteryLevel.present) {
      map['mastery_level'] = Variable<int>(masteryLevel.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (lastReviewed.present) {
      map['last_reviewed'] = Variable<DateTime>(lastReviewed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedVocabularyCompanion(')
          ..write('id: $id, ')
          ..write('saveGameId: $saveGameId, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('masteryLevel: $masteryLevel, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('lastReviewed: $lastReviewed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UnlockedGrammarTable extends UnlockedGrammar
    with TableInfo<$UnlockedGrammarTable, UnlockedGrammarPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockedGrammarTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saveGameIdMeta =
      const VerificationMeta('saveGameId');
  @override
  late final GeneratedColumn<int> saveGameId = GeneratedColumn<int>(
      'save_game_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES save_games (id) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _grammarIdMeta =
      const VerificationMeta('grammarId');
  @override
  late final GeneratedColumn<int> grammarId = GeneratedColumn<int>(
      'grammar_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isMasteredMeta =
      const VerificationMeta('isMastered');
  @override
  late final GeneratedColumn<bool> isMastered = GeneratedColumn<bool>(
      'is_mastered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_mastered" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, saveGameId, grammarId, isMastered, unlockedAt, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocked_grammar';
  @override
  VerificationContext validateIntegrity(
      Insertable<UnlockedGrammarPoint> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('save_game_id')) {
      context.handle(
          _saveGameIdMeta,
          saveGameId.isAcceptableOrUnknown(
              data['save_game_id']!, _saveGameIdMeta));
    } else if (isInserting) {
      context.missing(_saveGameIdMeta);
    }
    if (data.containsKey('grammar_id')) {
      context.handle(_grammarIdMeta,
          grammarId.isAcceptableOrUnknown(data['grammar_id']!, _grammarIdMeta));
    } else if (isInserting) {
      context.missing(_grammarIdMeta);
    }
    if (data.containsKey('is_mastered')) {
      context.handle(
          _isMasteredMeta,
          isMastered.isAcceptableOrUnknown(
              data['is_mastered']!, _isMasteredMeta));
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {saveGameId, grammarId},
      ];
  @override
  UnlockedGrammarPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockedGrammarPoint(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saveGameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}save_game_id'])!,
      grammarId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grammar_id'])!,
      isMastered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_mastered'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UnlockedGrammarTable createAlias(String alias) {
    return $UnlockedGrammarTable(attachedDatabase, alias);
  }
}

class UnlockedGrammarPoint extends DataClass
    implements Insertable<UnlockedGrammarPoint> {
  /// Primary key
  final int id;

  /// Reference to save game
  final int saveGameId;

  /// Reference to grammar point ID (now just an integer, not a foreign key)
  final int grammarId;

  /// Whether this grammar point is mastered
  final bool isMastered;

  /// When this grammar point was first encountered
  final DateTime unlockedAt;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;
  const UnlockedGrammarPoint(
      {required this.id,
      required this.saveGameId,
      required this.grammarId,
      required this.isMastered,
      required this.unlockedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['save_game_id'] = Variable<int>(saveGameId);
    map['grammar_id'] = Variable<int>(grammarId);
    map['is_mastered'] = Variable<bool>(isMastered);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UnlockedGrammarCompanion toCompanion(bool nullToAbsent) {
    return UnlockedGrammarCompanion(
      id: Value(id),
      saveGameId: Value(saveGameId),
      grammarId: Value(grammarId),
      isMastered: Value(isMastered),
      unlockedAt: Value(unlockedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UnlockedGrammarPoint.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockedGrammarPoint(
      id: serializer.fromJson<int>(json['id']),
      saveGameId: serializer.fromJson<int>(json['saveGameId']),
      grammarId: serializer.fromJson<int>(json['grammarId']),
      isMastered: serializer.fromJson<bool>(json['isMastered']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saveGameId': serializer.toJson<int>(saveGameId),
      'grammarId': serializer.toJson<int>(grammarId),
      'isMastered': serializer.toJson<bool>(isMastered),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UnlockedGrammarPoint copyWith(
          {int? id,
          int? saveGameId,
          int? grammarId,
          bool? isMastered,
          DateTime? unlockedAt,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UnlockedGrammarPoint(
        id: id ?? this.id,
        saveGameId: saveGameId ?? this.saveGameId,
        grammarId: grammarId ?? this.grammarId,
        isMastered: isMastered ?? this.isMastered,
        unlockedAt: unlockedAt ?? this.unlockedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UnlockedGrammarPoint copyWithCompanion(UnlockedGrammarCompanion data) {
    return UnlockedGrammarPoint(
      id: data.id.present ? data.id.value : this.id,
      saveGameId:
          data.saveGameId.present ? data.saveGameId.value : this.saveGameId,
      grammarId: data.grammarId.present ? data.grammarId.value : this.grammarId,
      isMastered:
          data.isMastered.present ? data.isMastered.value : this.isMastered,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedGrammarPoint(')
          ..write('id: $id, ')
          ..write('saveGameId: $saveGameId, ')
          ..write('grammarId: $grammarId, ')
          ..write('isMastered: $isMastered, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, saveGameId, grammarId, isMastered, unlockedAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockedGrammarPoint &&
          other.id == this.id &&
          other.saveGameId == this.saveGameId &&
          other.grammarId == this.grammarId &&
          other.isMastered == this.isMastered &&
          other.unlockedAt == this.unlockedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UnlockedGrammarCompanion extends UpdateCompanion<UnlockedGrammarPoint> {
  final Value<int> id;
  final Value<int> saveGameId;
  final Value<int> grammarId;
  final Value<bool> isMastered;
  final Value<DateTime> unlockedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UnlockedGrammarCompanion({
    this.id = const Value.absent(),
    this.saveGameId = const Value.absent(),
    this.grammarId = const Value.absent(),
    this.isMastered = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UnlockedGrammarCompanion.insert({
    this.id = const Value.absent(),
    required int saveGameId,
    required int grammarId,
    this.isMastered = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : saveGameId = Value(saveGameId),
        grammarId = Value(grammarId);
  static Insertable<UnlockedGrammarPoint> custom({
    Expression<int>? id,
    Expression<int>? saveGameId,
    Expression<int>? grammarId,
    Expression<bool>? isMastered,
    Expression<DateTime>? unlockedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saveGameId != null) 'save_game_id': saveGameId,
      if (grammarId != null) 'grammar_id': grammarId,
      if (isMastered != null) 'is_mastered': isMastered,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UnlockedGrammarCompanion copyWith(
      {Value<int>? id,
      Value<int>? saveGameId,
      Value<int>? grammarId,
      Value<bool>? isMastered,
      Value<DateTime>? unlockedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UnlockedGrammarCompanion(
      id: id ?? this.id,
      saveGameId: saveGameId ?? this.saveGameId,
      grammarId: grammarId ?? this.grammarId,
      isMastered: isMastered ?? this.isMastered,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saveGameId.present) {
      map['save_game_id'] = Variable<int>(saveGameId.value);
    }
    if (grammarId.present) {
      map['grammar_id'] = Variable<int>(grammarId.value);
    }
    if (isMastered.present) {
      map['is_mastered'] = Variable<bool>(isMastered.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedGrammarCompanion(')
          ..write('id: $id, ')
          ..write('saveGameId: $saveGameId, ')
          ..write('grammarId: $grammarId, ')
          ..write('isMastered: $isMastered, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UnlockedCulturalNotesTable extends UnlockedCulturalNotes
    with TableInfo<$UnlockedCulturalNotesTable, UnlockedCulturalNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockedCulturalNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saveGameIdMeta =
      const VerificationMeta('saveGameId');
  @override
  late final GeneratedColumn<int> saveGameId = GeneratedColumn<int>(
      'save_game_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES save_games (id) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _culturalNoteIdMeta =
      const VerificationMeta('culturalNoteId');
  @override
  late final GeneratedColumn<int> culturalNoteId = GeneratedColumn<int>(
      'cultural_note_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        saveGameId,
        culturalNoteId,
        isRead,
        unlockedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocked_cultural_notes';
  @override
  VerificationContext validateIntegrity(
      Insertable<UnlockedCulturalNote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('save_game_id')) {
      context.handle(
          _saveGameIdMeta,
          saveGameId.isAcceptableOrUnknown(
              data['save_game_id']!, _saveGameIdMeta));
    } else if (isInserting) {
      context.missing(_saveGameIdMeta);
    }
    if (data.containsKey('cultural_note_id')) {
      context.handle(
          _culturalNoteIdMeta,
          culturalNoteId.isAcceptableOrUnknown(
              data['cultural_note_id']!, _culturalNoteIdMeta));
    } else if (isInserting) {
      context.missing(_culturalNoteIdMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {saveGameId, culturalNoteId},
      ];
  @override
  UnlockedCulturalNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockedCulturalNote(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saveGameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}save_game_id'])!,
      culturalNoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cultural_note_id'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UnlockedCulturalNotesTable createAlias(String alias) {
    return $UnlockedCulturalNotesTable(attachedDatabase, alias);
  }
}

class UnlockedCulturalNote extends DataClass
    implements Insertable<UnlockedCulturalNote> {
  /// Primary key
  final int id;

  /// Reference to save game
  final int saveGameId;

  /// Reference to cultural note ID (now just an integer, not a foreign key)
  final int culturalNoteId;

  /// Whether this cultural note has been read
  final bool isRead;

  /// When this cultural note was first encountered
  final DateTime unlockedAt;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;
  const UnlockedCulturalNote(
      {required this.id,
      required this.saveGameId,
      required this.culturalNoteId,
      required this.isRead,
      required this.unlockedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['save_game_id'] = Variable<int>(saveGameId);
    map['cultural_note_id'] = Variable<int>(culturalNoteId);
    map['is_read'] = Variable<bool>(isRead);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UnlockedCulturalNotesCompanion toCompanion(bool nullToAbsent) {
    return UnlockedCulturalNotesCompanion(
      id: Value(id),
      saveGameId: Value(saveGameId),
      culturalNoteId: Value(culturalNoteId),
      isRead: Value(isRead),
      unlockedAt: Value(unlockedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UnlockedCulturalNote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockedCulturalNote(
      id: serializer.fromJson<int>(json['id']),
      saveGameId: serializer.fromJson<int>(json['saveGameId']),
      culturalNoteId: serializer.fromJson<int>(json['culturalNoteId']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saveGameId': serializer.toJson<int>(saveGameId),
      'culturalNoteId': serializer.toJson<int>(culturalNoteId),
      'isRead': serializer.toJson<bool>(isRead),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UnlockedCulturalNote copyWith(
          {int? id,
          int? saveGameId,
          int? culturalNoteId,
          bool? isRead,
          DateTime? unlockedAt,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UnlockedCulturalNote(
        id: id ?? this.id,
        saveGameId: saveGameId ?? this.saveGameId,
        culturalNoteId: culturalNoteId ?? this.culturalNoteId,
        isRead: isRead ?? this.isRead,
        unlockedAt: unlockedAt ?? this.unlockedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UnlockedCulturalNote copyWithCompanion(UnlockedCulturalNotesCompanion data) {
    return UnlockedCulturalNote(
      id: data.id.present ? data.id.value : this.id,
      saveGameId:
          data.saveGameId.present ? data.saveGameId.value : this.saveGameId,
      culturalNoteId: data.culturalNoteId.present
          ? data.culturalNoteId.value
          : this.culturalNoteId,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedCulturalNote(')
          ..write('id: $id, ')
          ..write('saveGameId: $saveGameId, ')
          ..write('culturalNoteId: $culturalNoteId, ')
          ..write('isRead: $isRead, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, saveGameId, culturalNoteId, isRead, unlockedAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockedCulturalNote &&
          other.id == this.id &&
          other.saveGameId == this.saveGameId &&
          other.culturalNoteId == this.culturalNoteId &&
          other.isRead == this.isRead &&
          other.unlockedAt == this.unlockedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UnlockedCulturalNotesCompanion
    extends UpdateCompanion<UnlockedCulturalNote> {
  final Value<int> id;
  final Value<int> saveGameId;
  final Value<int> culturalNoteId;
  final Value<bool> isRead;
  final Value<DateTime> unlockedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UnlockedCulturalNotesCompanion({
    this.id = const Value.absent(),
    this.saveGameId = const Value.absent(),
    this.culturalNoteId = const Value.absent(),
    this.isRead = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UnlockedCulturalNotesCompanion.insert({
    this.id = const Value.absent(),
    required int saveGameId,
    required int culturalNoteId,
    this.isRead = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : saveGameId = Value(saveGameId),
        culturalNoteId = Value(culturalNoteId);
  static Insertable<UnlockedCulturalNote> custom({
    Expression<int>? id,
    Expression<int>? saveGameId,
    Expression<int>? culturalNoteId,
    Expression<bool>? isRead,
    Expression<DateTime>? unlockedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saveGameId != null) 'save_game_id': saveGameId,
      if (culturalNoteId != null) 'cultural_note_id': culturalNoteId,
      if (isRead != null) 'is_read': isRead,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UnlockedCulturalNotesCompanion copyWith(
      {Value<int>? id,
      Value<int>? saveGameId,
      Value<int>? culturalNoteId,
      Value<bool>? isRead,
      Value<DateTime>? unlockedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return UnlockedCulturalNotesCompanion(
      id: id ?? this.id,
      saveGameId: saveGameId ?? this.saveGameId,
      culturalNoteId: culturalNoteId ?? this.culturalNoteId,
      isRead: isRead ?? this.isRead,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saveGameId.present) {
      map['save_game_id'] = Variable<int>(saveGameId.value);
    }
    if (culturalNoteId.present) {
      map['cultural_note_id'] = Variable<int>(culturalNoteId.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockedCulturalNotesCompanion(')
          ..write('id: $id, ')
          ..write('saveGameId: $saveGameId, ')
          ..write('culturalNoteId: $culturalNoteId, ')
          ..write('isRead: $isRead, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CharactersTable characters = $CharactersTable(this);
  late final $SaveGamesTable saveGames = $SaveGamesTable(this);
  late final $RelationshipsTable relationships = $RelationshipsTable(this);
  late final $UnlockedVocabularyTable unlockedVocabulary =
      $UnlockedVocabularyTable(this);
  late final $UnlockedGrammarTable unlockedGrammar =
      $UnlockedGrammarTable(this);
  late final $UnlockedCulturalNotesTable unlockedCulturalNotes =
      $UnlockedCulturalNotesTable(this);
  late final CharacterDao characterDao = CharacterDao(this as AppDatabase);
  late final SaveGameDao saveGameDao = SaveGameDao(this as AppDatabase);
  late final PlayerProgressDao playerProgressDao =
      PlayerProgressDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        characters,
        saveGames,
        relationships,
        unlockedVocabulary,
        unlockedGrammar,
        unlockedCulturalNotes
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('save_games',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('relationships', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('save_games',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('relationships', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('characters',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('relationships', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('characters',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('relationships', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('save_games',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('unlocked_vocabulary', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('save_games',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('unlocked_vocabulary', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('save_games',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('unlocked_grammar', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('save_games',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('unlocked_grammar', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('save_games',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('unlocked_cultural_notes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('save_games',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('unlocked_cultural_notes', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$CharactersTableCreateCompanionBuilder = CharactersCompanion Function({
  Value<int> id,
  required String nameJp,
  required String nameEn,
  required String personality,
  required String avatarPath,
  required String spriteFolder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$CharactersTableUpdateCompanionBuilder = CharactersCompanion Function({
  Value<int> id,
  Value<String> nameJp,
  Value<String> nameEn,
  Value<String> personality,
  Value<String> avatarPath,
  Value<String> spriteFolder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$CharactersTableReferences
    extends BaseReferences<_$AppDatabase, $CharactersTable, Character> {
  $$CharactersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RelationshipsTable, List<Relationship>>
      _relationshipsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.relationships,
              aliasName: $_aliasNameGenerator(
                  db.characters.id, db.relationships.characterId));

  $$RelationshipsTableProcessedTableManager get relationshipsRefs {
    final manager = $$RelationshipsTableTableManager($_db, $_db.relationships)
        .filter((f) => f.characterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_relationshipsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameJp => $composableBuilder(
      column: $table.nameJp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personality => $composableBuilder(
      column: $table.personality, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get spriteFolder => $composableBuilder(
      column: $table.spriteFolder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> relationshipsRefs(
      Expression<bool> Function($$RelationshipsTableFilterComposer f) f) {
    final $$RelationshipsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationships,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipsTableFilterComposer(
              $db: $db,
              $table: $db.relationships,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameJp => $composableBuilder(
      column: $table.nameJp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personality => $composableBuilder(
      column: $table.personality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get spriteFolder => $composableBuilder(
      column: $table.spriteFolder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameJp =>
      $composableBuilder(column: $table.nameJp, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get personality => $composableBuilder(
      column: $table.personality, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<String> get spriteFolder => $composableBuilder(
      column: $table.spriteFolder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> relationshipsRefs<T extends Object>(
      Expression<T> Function($$RelationshipsTableAnnotationComposer a) f) {
    final $$RelationshipsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationships,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipsTableAnnotationComposer(
              $db: $db,
              $table: $db.relationships,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CharactersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CharactersTable,
    Character,
    $$CharactersTableFilterComposer,
    $$CharactersTableOrderingComposer,
    $$CharactersTableAnnotationComposer,
    $$CharactersTableCreateCompanionBuilder,
    $$CharactersTableUpdateCompanionBuilder,
    (Character, $$CharactersTableReferences),
    Character,
    PrefetchHooks Function({bool relationshipsRefs})> {
  $$CharactersTableTableManager(_$AppDatabase db, $CharactersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nameJp = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String> personality = const Value.absent(),
            Value<String> avatarPath = const Value.absent(),
            Value<String> spriteFolder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CharactersCompanion(
            id: id,
            nameJp: nameJp,
            nameEn: nameEn,
            personality: personality,
            avatarPath: avatarPath,
            spriteFolder: spriteFolder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nameJp,
            required String nameEn,
            required String personality,
            required String avatarPath,
            required String spriteFolder,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CharactersCompanion.insert(
            id: id,
            nameJp: nameJp,
            nameEn: nameEn,
            personality: personality,
            avatarPath: avatarPath,
            spriteFolder: spriteFolder,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CharactersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({relationshipsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (relationshipsRefs) db.relationships
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (relationshipsRefs)
                    await $_getPrefetchedData<Character, $CharactersTable,
                            Relationship>(
                        currentTable: table,
                        referencedTable: $$CharactersTableReferences
                            ._relationshipsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CharactersTableReferences(db, table, p0)
                                .relationshipsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.characterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CharactersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CharactersTable,
    Character,
    $$CharactersTableFilterComposer,
    $$CharactersTableOrderingComposer,
    $$CharactersTableAnnotationComposer,
    $$CharactersTableCreateCompanionBuilder,
    $$CharactersTableUpdateCompanionBuilder,
    (Character, $$CharactersTableReferences),
    Character,
    PrefetchHooks Function({bool relationshipsRefs})>;
typedef $$SaveGamesTableCreateCompanionBuilder = SaveGamesCompanion Function({
  Value<int> id,
  required int slotId,
  required String playerName,
  required String currentChapter,
  required String currentScene,
  Value<int> playTimeSeconds,
  Value<DateTime> lastSavedAt,
  Value<String?> thumbnailPath,
  Value<String> settingsJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$SaveGamesTableUpdateCompanionBuilder = SaveGamesCompanion Function({
  Value<int> id,
  Value<int> slotId,
  Value<String> playerName,
  Value<String> currentChapter,
  Value<String> currentScene,
  Value<int> playTimeSeconds,
  Value<DateTime> lastSavedAt,
  Value<String?> thumbnailPath,
  Value<String> settingsJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$SaveGamesTableReferences
    extends BaseReferences<_$AppDatabase, $SaveGamesTable, SaveGame> {
  $$SaveGamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RelationshipsTable, List<Relationship>>
      _relationshipsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.relationships,
              aliasName: $_aliasNameGenerator(
                  db.saveGames.id, db.relationships.saveGameId));

  $$RelationshipsTableProcessedTableManager get relationshipsRefs {
    final manager = $$RelationshipsTableTableManager($_db, $_db.relationships)
        .filter((f) => f.saveGameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_relationshipsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UnlockedVocabularyTable,
      List<UnlockedVocabularyItem>> _unlockedVocabularyRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.unlockedVocabulary,
          aliasName: $_aliasNameGenerator(
              db.saveGames.id, db.unlockedVocabulary.saveGameId));

  $$UnlockedVocabularyTableProcessedTableManager get unlockedVocabularyRefs {
    final manager =
        $$UnlockedVocabularyTableTableManager($_db, $_db.unlockedVocabulary)
            .filter((f) => f.saveGameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_unlockedVocabularyRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UnlockedGrammarTable, List<UnlockedGrammarPoint>>
      _unlockedGrammarRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.unlockedGrammar,
              aliasName: $_aliasNameGenerator(
                  db.saveGames.id, db.unlockedGrammar.saveGameId));

  $$UnlockedGrammarTableProcessedTableManager get unlockedGrammarRefs {
    final manager =
        $$UnlockedGrammarTableTableManager($_db, $_db.unlockedGrammar)
            .filter((f) => f.saveGameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_unlockedGrammarRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$UnlockedCulturalNotesTable,
      List<UnlockedCulturalNote>> _unlockedCulturalNotesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.unlockedCulturalNotes,
          aliasName: $_aliasNameGenerator(
              db.saveGames.id, db.unlockedCulturalNotes.saveGameId));

  $$UnlockedCulturalNotesTableProcessedTableManager
      get unlockedCulturalNotesRefs {
    final manager = $$UnlockedCulturalNotesTableTableManager(
            $_db, $_db.unlockedCulturalNotes)
        .filter((f) => f.saveGameId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_unlockedCulturalNotesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SaveGamesTableFilterComposer
    extends Composer<_$AppDatabase, $SaveGamesTable> {
  $$SaveGamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get slotId => $composableBuilder(
      column: $table.slotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get playerName => $composableBuilder(
      column: $table.playerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentChapter => $composableBuilder(
      column: $table.currentChapter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentScene => $composableBuilder(
      column: $table.currentScene, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playTimeSeconds => $composableBuilder(
      column: $table.playTimeSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSavedAt => $composableBuilder(
      column: $table.lastSavedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
      column: $table.thumbnailPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> relationshipsRefs(
      Expression<bool> Function($$RelationshipsTableFilterComposer f) f) {
    final $$RelationshipsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationships,
        getReferencedColumn: (t) => t.saveGameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipsTableFilterComposer(
              $db: $db,
              $table: $db.relationships,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> unlockedVocabularyRefs(
      Expression<bool> Function($$UnlockedVocabularyTableFilterComposer f) f) {
    final $$UnlockedVocabularyTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.unlockedVocabulary,
        getReferencedColumn: (t) => t.saveGameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnlockedVocabularyTableFilterComposer(
              $db: $db,
              $table: $db.unlockedVocabulary,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> unlockedGrammarRefs(
      Expression<bool> Function($$UnlockedGrammarTableFilterComposer f) f) {
    final $$UnlockedGrammarTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.unlockedGrammar,
        getReferencedColumn: (t) => t.saveGameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnlockedGrammarTableFilterComposer(
              $db: $db,
              $table: $db.unlockedGrammar,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> unlockedCulturalNotesRefs(
      Expression<bool> Function($$UnlockedCulturalNotesTableFilterComposer f)
          f) {
    final $$UnlockedCulturalNotesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.unlockedCulturalNotes,
            getReferencedColumn: (t) => t.saveGameId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$UnlockedCulturalNotesTableFilterComposer(
                  $db: $db,
                  $table: $db.unlockedCulturalNotes,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SaveGamesTableOrderingComposer
    extends Composer<_$AppDatabase, $SaveGamesTable> {
  $$SaveGamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get slotId => $composableBuilder(
      column: $table.slotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get playerName => $composableBuilder(
      column: $table.playerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentChapter => $composableBuilder(
      column: $table.currentChapter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentScene => $composableBuilder(
      column: $table.currentScene,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playTimeSeconds => $composableBuilder(
      column: $table.playTimeSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSavedAt => $composableBuilder(
      column: $table.lastSavedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
      column: $table.thumbnailPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SaveGamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaveGamesTable> {
  $$SaveGamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get slotId =>
      $composableBuilder(column: $table.slotId, builder: (column) => column);

  GeneratedColumn<String> get playerName => $composableBuilder(
      column: $table.playerName, builder: (column) => column);

  GeneratedColumn<String> get currentChapter => $composableBuilder(
      column: $table.currentChapter, builder: (column) => column);

  GeneratedColumn<String> get currentScene => $composableBuilder(
      column: $table.currentScene, builder: (column) => column);

  GeneratedColumn<int> get playTimeSeconds => $composableBuilder(
      column: $table.playTimeSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSavedAt => $composableBuilder(
      column: $table.lastSavedAt, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
      column: $table.thumbnailPath, builder: (column) => column);

  GeneratedColumn<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> relationshipsRefs<T extends Object>(
      Expression<T> Function($$RelationshipsTableAnnotationComposer a) f) {
    final $$RelationshipsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationships,
        getReferencedColumn: (t) => t.saveGameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipsTableAnnotationComposer(
              $db: $db,
              $table: $db.relationships,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> unlockedVocabularyRefs<T extends Object>(
      Expression<T> Function($$UnlockedVocabularyTableAnnotationComposer a) f) {
    final $$UnlockedVocabularyTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.unlockedVocabulary,
            getReferencedColumn: (t) => t.saveGameId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$UnlockedVocabularyTableAnnotationComposer(
                  $db: $db,
                  $table: $db.unlockedVocabulary,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> unlockedGrammarRefs<T extends Object>(
      Expression<T> Function($$UnlockedGrammarTableAnnotationComposer a) f) {
    final $$UnlockedGrammarTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.unlockedGrammar,
        getReferencedColumn: (t) => t.saveGameId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UnlockedGrammarTableAnnotationComposer(
              $db: $db,
              $table: $db.unlockedGrammar,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> unlockedCulturalNotesRefs<T extends Object>(
      Expression<T> Function($$UnlockedCulturalNotesTableAnnotationComposer a)
          f) {
    final $$UnlockedCulturalNotesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.unlockedCulturalNotes,
            getReferencedColumn: (t) => t.saveGameId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$UnlockedCulturalNotesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.unlockedCulturalNotes,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SaveGamesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaveGamesTable,
    SaveGame,
    $$SaveGamesTableFilterComposer,
    $$SaveGamesTableOrderingComposer,
    $$SaveGamesTableAnnotationComposer,
    $$SaveGamesTableCreateCompanionBuilder,
    $$SaveGamesTableUpdateCompanionBuilder,
    (SaveGame, $$SaveGamesTableReferences),
    SaveGame,
    PrefetchHooks Function(
        {bool relationshipsRefs,
        bool unlockedVocabularyRefs,
        bool unlockedGrammarRefs,
        bool unlockedCulturalNotesRefs})> {
  $$SaveGamesTableTableManager(_$AppDatabase db, $SaveGamesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaveGamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaveGamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaveGamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> slotId = const Value.absent(),
            Value<String> playerName = const Value.absent(),
            Value<String> currentChapter = const Value.absent(),
            Value<String> currentScene = const Value.absent(),
            Value<int> playTimeSeconds = const Value.absent(),
            Value<DateTime> lastSavedAt = const Value.absent(),
            Value<String?> thumbnailPath = const Value.absent(),
            Value<String> settingsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SaveGamesCompanion(
            id: id,
            slotId: slotId,
            playerName: playerName,
            currentChapter: currentChapter,
            currentScene: currentScene,
            playTimeSeconds: playTimeSeconds,
            lastSavedAt: lastSavedAt,
            thumbnailPath: thumbnailPath,
            settingsJson: settingsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int slotId,
            required String playerName,
            required String currentChapter,
            required String currentScene,
            Value<int> playTimeSeconds = const Value.absent(),
            Value<DateTime> lastSavedAt = const Value.absent(),
            Value<String?> thumbnailPath = const Value.absent(),
            Value<String> settingsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SaveGamesCompanion.insert(
            id: id,
            slotId: slotId,
            playerName: playerName,
            currentChapter: currentChapter,
            currentScene: currentScene,
            playTimeSeconds: playTimeSeconds,
            lastSavedAt: lastSavedAt,
            thumbnailPath: thumbnailPath,
            settingsJson: settingsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SaveGamesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {relationshipsRefs = false,
              unlockedVocabularyRefs = false,
              unlockedGrammarRefs = false,
              unlockedCulturalNotesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (relationshipsRefs) db.relationships,
                if (unlockedVocabularyRefs) db.unlockedVocabulary,
                if (unlockedGrammarRefs) db.unlockedGrammar,
                if (unlockedCulturalNotesRefs) db.unlockedCulturalNotes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (relationshipsRefs)
                    await $_getPrefetchedData<SaveGame, $SaveGamesTable,
                            Relationship>(
                        currentTable: table,
                        referencedTable: $$SaveGamesTableReferences
                            ._relationshipsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SaveGamesTableReferences(db, table, p0)
                                .relationshipsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.saveGameId == item.id),
                        typedResults: items),
                  if (unlockedVocabularyRefs)
                    await $_getPrefetchedData<SaveGame, $SaveGamesTable, UnlockedVocabularyItem>(
                        currentTable: table,
                        referencedTable: $$SaveGamesTableReferences
                            ._unlockedVocabularyRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SaveGamesTableReferences(db, table, p0)
                                .unlockedVocabularyRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.saveGameId == item.id),
                        typedResults: items),
                  if (unlockedGrammarRefs)
                    await $_getPrefetchedData<SaveGame, $SaveGamesTable,
                            UnlockedGrammarPoint>(
                        currentTable: table,
                        referencedTable: $$SaveGamesTableReferences
                            ._unlockedGrammarRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SaveGamesTableReferences(db, table, p0)
                                .unlockedGrammarRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.saveGameId == item.id),
                        typedResults: items),
                  if (unlockedCulturalNotesRefs)
                    await $_getPrefetchedData<SaveGame, $SaveGamesTable,
                            UnlockedCulturalNote>(
                        currentTable: table,
                        referencedTable: $$SaveGamesTableReferences
                            ._unlockedCulturalNotesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SaveGamesTableReferences(db, table, p0)
                                .unlockedCulturalNotesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.saveGameId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SaveGamesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SaveGamesTable,
    SaveGame,
    $$SaveGamesTableFilterComposer,
    $$SaveGamesTableOrderingComposer,
    $$SaveGamesTableAnnotationComposer,
    $$SaveGamesTableCreateCompanionBuilder,
    $$SaveGamesTableUpdateCompanionBuilder,
    (SaveGame, $$SaveGamesTableReferences),
    SaveGame,
    PrefetchHooks Function(
        {bool relationshipsRefs,
        bool unlockedVocabularyRefs,
        bool unlockedGrammarRefs,
        bool unlockedCulturalNotesRefs})>;
typedef $$RelationshipsTableCreateCompanionBuilder = RelationshipsCompanion
    Function({
  Value<int> id,
  required int saveGameId,
  required int characterId,
  Value<int> kizunaPoints,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$RelationshipsTableUpdateCompanionBuilder = RelationshipsCompanion
    Function({
  Value<int> id,
  Value<int> saveGameId,
  Value<int> characterId,
  Value<int> kizunaPoints,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$RelationshipsTableReferences
    extends BaseReferences<_$AppDatabase, $RelationshipsTable, Relationship> {
  $$RelationshipsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SaveGamesTable _saveGameIdTable(_$AppDatabase db) =>
      db.saveGames.createAlias(
          $_aliasNameGenerator(db.relationships.saveGameId, db.saveGames.id));

  $$SaveGamesTableProcessedTableManager get saveGameId {
    final $_column = $_itemColumn<int>('save_game_id')!;

    final manager = $$SaveGamesTableTableManager($_db, $_db.saveGames)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saveGameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
          $_aliasNameGenerator(db.relationships.characterId, db.characters.id));

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<int>('character_id')!;

    final manager = $$CharactersTableTableManager($_db, $_db.characters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RelationshipsTableFilterComposer
    extends Composer<_$AppDatabase, $RelationshipsTable> {
  $$RelationshipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kizunaPoints => $composableBuilder(
      column: $table.kizunaPoints, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$SaveGamesTableFilterComposer get saveGameId {
    final $$SaveGamesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableFilterComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.characters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableFilterComposer(
              $db: $db,
              $table: $db.characters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $RelationshipsTable> {
  $$RelationshipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kizunaPoints => $composableBuilder(
      column: $table.kizunaPoints,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$SaveGamesTableOrderingComposer get saveGameId {
    final $$SaveGamesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableOrderingComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.characters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableOrderingComposer(
              $db: $db,
              $table: $db.characters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelationshipsTable> {
  $$RelationshipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get kizunaPoints => $composableBuilder(
      column: $table.kizunaPoints, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SaveGamesTableAnnotationComposer get saveGameId {
    final $$SaveGamesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableAnnotationComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.characters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableAnnotationComposer(
              $db: $db,
              $table: $db.characters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RelationshipsTable,
    Relationship,
    $$RelationshipsTableFilterComposer,
    $$RelationshipsTableOrderingComposer,
    $$RelationshipsTableAnnotationComposer,
    $$RelationshipsTableCreateCompanionBuilder,
    $$RelationshipsTableUpdateCompanionBuilder,
    (Relationship, $$RelationshipsTableReferences),
    Relationship,
    PrefetchHooks Function({bool saveGameId, bool characterId})> {
  $$RelationshipsTableTableManager(_$AppDatabase db, $RelationshipsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationshipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationshipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelationshipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saveGameId = const Value.absent(),
            Value<int> characterId = const Value.absent(),
            Value<int> kizunaPoints = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              RelationshipsCompanion(
            id: id,
            saveGameId: saveGameId,
            characterId: characterId,
            kizunaPoints: kizunaPoints,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saveGameId,
            required int characterId,
            Value<int> kizunaPoints = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              RelationshipsCompanion.insert(
            id: id,
            saveGameId: saveGameId,
            characterId: characterId,
            kizunaPoints: kizunaPoints,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RelationshipsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({saveGameId = false, characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (saveGameId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saveGameId,
                    referencedTable:
                        $$RelationshipsTableReferences._saveGameIdTable(db),
                    referencedColumn:
                        $$RelationshipsTableReferences._saveGameIdTable(db).id,
                  ) as T;
                }
                if (characterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.characterId,
                    referencedTable:
                        $$RelationshipsTableReferences._characterIdTable(db),
                    referencedColumn:
                        $$RelationshipsTableReferences._characterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RelationshipsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RelationshipsTable,
    Relationship,
    $$RelationshipsTableFilterComposer,
    $$RelationshipsTableOrderingComposer,
    $$RelationshipsTableAnnotationComposer,
    $$RelationshipsTableCreateCompanionBuilder,
    $$RelationshipsTableUpdateCompanionBuilder,
    (Relationship, $$RelationshipsTableReferences),
    Relationship,
    PrefetchHooks Function({bool saveGameId, bool characterId})>;
typedef $$UnlockedVocabularyTableCreateCompanionBuilder
    = UnlockedVocabularyCompanion Function({
  Value<int> id,
  required int saveGameId,
  required int vocabularyId,
  Value<int> masteryLevel,
  Value<DateTime> unlockedAt,
  Value<DateTime?> lastReviewed,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UnlockedVocabularyTableUpdateCompanionBuilder
    = UnlockedVocabularyCompanion Function({
  Value<int> id,
  Value<int> saveGameId,
  Value<int> vocabularyId,
  Value<int> masteryLevel,
  Value<DateTime> unlockedAt,
  Value<DateTime?> lastReviewed,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UnlockedVocabularyTableReferences extends BaseReferences<
    _$AppDatabase, $UnlockedVocabularyTable, UnlockedVocabularyItem> {
  $$UnlockedVocabularyTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SaveGamesTable _saveGameIdTable(_$AppDatabase db) =>
      db.saveGames.createAlias($_aliasNameGenerator(
          db.unlockedVocabulary.saveGameId, db.saveGames.id));

  $$SaveGamesTableProcessedTableManager get saveGameId {
    final $_column = $_itemColumn<int>('save_game_id')!;

    final manager = $$SaveGamesTableTableManager($_db, $_db.saveGames)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saveGameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UnlockedVocabularyTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockedVocabularyTable> {
  $$UnlockedVocabularyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get vocabularyId => $composableBuilder(
      column: $table.vocabularyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get masteryLevel => $composableBuilder(
      column: $table.masteryLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewed => $composableBuilder(
      column: $table.lastReviewed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$SaveGamesTableFilterComposer get saveGameId {
    final $$SaveGamesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableFilterComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedVocabularyTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockedVocabularyTable> {
  $$UnlockedVocabularyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get vocabularyId => $composableBuilder(
      column: $table.vocabularyId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get masteryLevel => $composableBuilder(
      column: $table.masteryLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewed => $composableBuilder(
      column: $table.lastReviewed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$SaveGamesTableOrderingComposer get saveGameId {
    final $$SaveGamesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableOrderingComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedVocabularyTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockedVocabularyTable> {
  $$UnlockedVocabularyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get vocabularyId => $composableBuilder(
      column: $table.vocabularyId, builder: (column) => column);

  GeneratedColumn<int> get masteryLevel => $composableBuilder(
      column: $table.masteryLevel, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewed => $composableBuilder(
      column: $table.lastReviewed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SaveGamesTableAnnotationComposer get saveGameId {
    final $$SaveGamesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableAnnotationComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedVocabularyTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnlockedVocabularyTable,
    UnlockedVocabularyItem,
    $$UnlockedVocabularyTableFilterComposer,
    $$UnlockedVocabularyTableOrderingComposer,
    $$UnlockedVocabularyTableAnnotationComposer,
    $$UnlockedVocabularyTableCreateCompanionBuilder,
    $$UnlockedVocabularyTableUpdateCompanionBuilder,
    (UnlockedVocabularyItem, $$UnlockedVocabularyTableReferences),
    UnlockedVocabularyItem,
    PrefetchHooks Function({bool saveGameId})> {
  $$UnlockedVocabularyTableTableManager(
      _$AppDatabase db, $UnlockedVocabularyTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockedVocabularyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlockedVocabularyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnlockedVocabularyTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saveGameId = const Value.absent(),
            Value<int> vocabularyId = const Value.absent(),
            Value<int> masteryLevel = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<DateTime?> lastReviewed = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UnlockedVocabularyCompanion(
            id: id,
            saveGameId: saveGameId,
            vocabularyId: vocabularyId,
            masteryLevel: masteryLevel,
            unlockedAt: unlockedAt,
            lastReviewed: lastReviewed,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saveGameId,
            required int vocabularyId,
            Value<int> masteryLevel = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<DateTime?> lastReviewed = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UnlockedVocabularyCompanion.insert(
            id: id,
            saveGameId: saveGameId,
            vocabularyId: vocabularyId,
            masteryLevel: masteryLevel,
            unlockedAt: unlockedAt,
            lastReviewed: lastReviewed,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UnlockedVocabularyTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({saveGameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (saveGameId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saveGameId,
                    referencedTable: $$UnlockedVocabularyTableReferences
                        ._saveGameIdTable(db),
                    referencedColumn: $$UnlockedVocabularyTableReferences
                        ._saveGameIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UnlockedVocabularyTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnlockedVocabularyTable,
    UnlockedVocabularyItem,
    $$UnlockedVocabularyTableFilterComposer,
    $$UnlockedVocabularyTableOrderingComposer,
    $$UnlockedVocabularyTableAnnotationComposer,
    $$UnlockedVocabularyTableCreateCompanionBuilder,
    $$UnlockedVocabularyTableUpdateCompanionBuilder,
    (UnlockedVocabularyItem, $$UnlockedVocabularyTableReferences),
    UnlockedVocabularyItem,
    PrefetchHooks Function({bool saveGameId})>;
typedef $$UnlockedGrammarTableCreateCompanionBuilder = UnlockedGrammarCompanion
    Function({
  Value<int> id,
  required int saveGameId,
  required int grammarId,
  Value<bool> isMastered,
  Value<DateTime> unlockedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UnlockedGrammarTableUpdateCompanionBuilder = UnlockedGrammarCompanion
    Function({
  Value<int> id,
  Value<int> saveGameId,
  Value<int> grammarId,
  Value<bool> isMastered,
  Value<DateTime> unlockedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UnlockedGrammarTableReferences extends BaseReferences<
    _$AppDatabase, $UnlockedGrammarTable, UnlockedGrammarPoint> {
  $$UnlockedGrammarTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SaveGamesTable _saveGameIdTable(_$AppDatabase db) =>
      db.saveGames.createAlias(
          $_aliasNameGenerator(db.unlockedGrammar.saveGameId, db.saveGames.id));

  $$SaveGamesTableProcessedTableManager get saveGameId {
    final $_column = $_itemColumn<int>('save_game_id')!;

    final manager = $$SaveGamesTableTableManager($_db, $_db.saveGames)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saveGameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UnlockedGrammarTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockedGrammarTable> {
  $$UnlockedGrammarTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get grammarId => $composableBuilder(
      column: $table.grammarId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMastered => $composableBuilder(
      column: $table.isMastered, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$SaveGamesTableFilterComposer get saveGameId {
    final $$SaveGamesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableFilterComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedGrammarTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockedGrammarTable> {
  $$UnlockedGrammarTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get grammarId => $composableBuilder(
      column: $table.grammarId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMastered => $composableBuilder(
      column: $table.isMastered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$SaveGamesTableOrderingComposer get saveGameId {
    final $$SaveGamesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableOrderingComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedGrammarTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockedGrammarTable> {
  $$UnlockedGrammarTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get grammarId =>
      $composableBuilder(column: $table.grammarId, builder: (column) => column);

  GeneratedColumn<bool> get isMastered => $composableBuilder(
      column: $table.isMastered, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SaveGamesTableAnnotationComposer get saveGameId {
    final $$SaveGamesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableAnnotationComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedGrammarTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnlockedGrammarTable,
    UnlockedGrammarPoint,
    $$UnlockedGrammarTableFilterComposer,
    $$UnlockedGrammarTableOrderingComposer,
    $$UnlockedGrammarTableAnnotationComposer,
    $$UnlockedGrammarTableCreateCompanionBuilder,
    $$UnlockedGrammarTableUpdateCompanionBuilder,
    (UnlockedGrammarPoint, $$UnlockedGrammarTableReferences),
    UnlockedGrammarPoint,
    PrefetchHooks Function({bool saveGameId})> {
  $$UnlockedGrammarTableTableManager(
      _$AppDatabase db, $UnlockedGrammarTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockedGrammarTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlockedGrammarTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnlockedGrammarTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saveGameId = const Value.absent(),
            Value<int> grammarId = const Value.absent(),
            Value<bool> isMastered = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UnlockedGrammarCompanion(
            id: id,
            saveGameId: saveGameId,
            grammarId: grammarId,
            isMastered: isMastered,
            unlockedAt: unlockedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saveGameId,
            required int grammarId,
            Value<bool> isMastered = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UnlockedGrammarCompanion.insert(
            id: id,
            saveGameId: saveGameId,
            grammarId: grammarId,
            isMastered: isMastered,
            unlockedAt: unlockedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UnlockedGrammarTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({saveGameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (saveGameId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saveGameId,
                    referencedTable:
                        $$UnlockedGrammarTableReferences._saveGameIdTable(db),
                    referencedColumn: $$UnlockedGrammarTableReferences
                        ._saveGameIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UnlockedGrammarTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnlockedGrammarTable,
    UnlockedGrammarPoint,
    $$UnlockedGrammarTableFilterComposer,
    $$UnlockedGrammarTableOrderingComposer,
    $$UnlockedGrammarTableAnnotationComposer,
    $$UnlockedGrammarTableCreateCompanionBuilder,
    $$UnlockedGrammarTableUpdateCompanionBuilder,
    (UnlockedGrammarPoint, $$UnlockedGrammarTableReferences),
    UnlockedGrammarPoint,
    PrefetchHooks Function({bool saveGameId})>;
typedef $$UnlockedCulturalNotesTableCreateCompanionBuilder
    = UnlockedCulturalNotesCompanion Function({
  Value<int> id,
  required int saveGameId,
  required int culturalNoteId,
  Value<bool> isRead,
  Value<DateTime> unlockedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$UnlockedCulturalNotesTableUpdateCompanionBuilder
    = UnlockedCulturalNotesCompanion Function({
  Value<int> id,
  Value<int> saveGameId,
  Value<int> culturalNoteId,
  Value<bool> isRead,
  Value<DateTime> unlockedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UnlockedCulturalNotesTableReferences extends BaseReferences<
    _$AppDatabase, $UnlockedCulturalNotesTable, UnlockedCulturalNote> {
  $$UnlockedCulturalNotesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SaveGamesTable _saveGameIdTable(_$AppDatabase db) =>
      db.saveGames.createAlias($_aliasNameGenerator(
          db.unlockedCulturalNotes.saveGameId, db.saveGames.id));

  $$SaveGamesTableProcessedTableManager get saveGameId {
    final $_column = $_itemColumn<int>('save_game_id')!;

    final manager = $$SaveGamesTableTableManager($_db, $_db.saveGames)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saveGameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UnlockedCulturalNotesTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockedCulturalNotesTable> {
  $$UnlockedCulturalNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get culturalNoteId => $composableBuilder(
      column: $table.culturalNoteId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$SaveGamesTableFilterComposer get saveGameId {
    final $$SaveGamesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableFilterComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedCulturalNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockedCulturalNotesTable> {
  $$UnlockedCulturalNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get culturalNoteId => $composableBuilder(
      column: $table.culturalNoteId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$SaveGamesTableOrderingComposer get saveGameId {
    final $$SaveGamesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableOrderingComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedCulturalNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockedCulturalNotesTable> {
  $$UnlockedCulturalNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get culturalNoteId => $composableBuilder(
      column: $table.culturalNoteId, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SaveGamesTableAnnotationComposer get saveGameId {
    final $$SaveGamesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saveGameId,
        referencedTable: $db.saveGames,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaveGamesTableAnnotationComposer(
              $db: $db,
              $table: $db.saveGames,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UnlockedCulturalNotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnlockedCulturalNotesTable,
    UnlockedCulturalNote,
    $$UnlockedCulturalNotesTableFilterComposer,
    $$UnlockedCulturalNotesTableOrderingComposer,
    $$UnlockedCulturalNotesTableAnnotationComposer,
    $$UnlockedCulturalNotesTableCreateCompanionBuilder,
    $$UnlockedCulturalNotesTableUpdateCompanionBuilder,
    (UnlockedCulturalNote, $$UnlockedCulturalNotesTableReferences),
    UnlockedCulturalNote,
    PrefetchHooks Function({bool saveGameId})> {
  $$UnlockedCulturalNotesTableTableManager(
      _$AppDatabase db, $UnlockedCulturalNotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockedCulturalNotesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlockedCulturalNotesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnlockedCulturalNotesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saveGameId = const Value.absent(),
            Value<int> culturalNoteId = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UnlockedCulturalNotesCompanion(
            id: id,
            saveGameId: saveGameId,
            culturalNoteId: culturalNoteId,
            isRead: isRead,
            unlockedAt: unlockedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saveGameId,
            required int culturalNoteId,
            Value<bool> isRead = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UnlockedCulturalNotesCompanion.insert(
            id: id,
            saveGameId: saveGameId,
            culturalNoteId: culturalNoteId,
            isRead: isRead,
            unlockedAt: unlockedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UnlockedCulturalNotesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({saveGameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (saveGameId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saveGameId,
                    referencedTable: $$UnlockedCulturalNotesTableReferences
                        ._saveGameIdTable(db),
                    referencedColumn: $$UnlockedCulturalNotesTableReferences
                        ._saveGameIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UnlockedCulturalNotesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UnlockedCulturalNotesTable,
        UnlockedCulturalNote,
        $$UnlockedCulturalNotesTableFilterComposer,
        $$UnlockedCulturalNotesTableOrderingComposer,
        $$UnlockedCulturalNotesTableAnnotationComposer,
        $$UnlockedCulturalNotesTableCreateCompanionBuilder,
        $$UnlockedCulturalNotesTableUpdateCompanionBuilder,
        (UnlockedCulturalNote, $$UnlockedCulturalNotesTableReferences),
        UnlockedCulturalNote,
        PrefetchHooks Function({bool saveGameId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
  $$SaveGamesTableTableManager get saveGames =>
      $$SaveGamesTableTableManager(_db, _db.saveGames);
  $$RelationshipsTableTableManager get relationships =>
      $$RelationshipsTableTableManager(_db, _db.relationships);
  $$UnlockedVocabularyTableTableManager get unlockedVocabulary =>
      $$UnlockedVocabularyTableTableManager(_db, _db.unlockedVocabulary);
  $$UnlockedGrammarTableTableManager get unlockedGrammar =>
      $$UnlockedGrammarTableTableManager(_db, _db.unlockedGrammar);
  $$UnlockedCulturalNotesTableTableManager get unlockedCulturalNotes =>
      $$UnlockedCulturalNotesTableTableManager(_db, _db.unlockedCulturalNotes);
}

import 'package:equatable/equatable.dart';

/// Model for a dialogue line in the visual novel
class DialogueLine extends Equatable {
  /// Unique identifier for this dialogue line
  final String id;

  /// ID of the character speaking (null for narrator)
  final String? characterId;

  /// Character name (for display)
  final String? speakerName;

  /// Japanese text
  final String textJp;

  /// Furigana version of Japanese text (optional)
  final String? furiganaJp;

  /// Romaji transliteration (optional)
  final String? romajiJp;

  /// English translation
  final String textEn;

  /// Character sprite to display (e.g., "happy", "sad")
  final String? sprite;

  /// Character sprite position (left, center, right)
  final String? position;

  /// Background image to use
  final String? background;

  /// Sound effect to play
  final String? soundEffect;

  /// Voice clip to play
  final String? voiceClip;

  /// Whether this is a choice option
  final bool isChoice;

  /// Next dialogue ID (if not a choice)
  final String? nextId;

  /// Tags for special effects or triggers
  final List<String> tags;

  /// Create a dialogue line
  const DialogueLine({
    required this.id,
    this.characterId,
    this.speakerName,
    required this.textJp,
    this.furiganaJp,
    this.romajiJp,
    required this.textEn,
    this.sprite,
    this.position,
    this.background,
    this.soundEffect,
    this.voiceClip,
    this.isChoice = false,
    this.nextId,
    this.tags = const [],
  });

  /// Create from JSON map
  factory DialogueLine.fromJson(Map<String, dynamic> json) {
    return DialogueLine(
      id: json['id'] as String,
      characterId: json['characterId'] as String?,
      speakerName: json['speakerName'] as String?,
      textJp: json['textJp'] as String,
      furiganaJp: json['furiganaJp'] as String?,
      romajiJp: json['romajiJp'] as String?,
      textEn: json['textEn'] as String,
      sprite: json['sprite'] as String?,
      position: json['position'] as String?,
      background: json['background'] as String?,
      soundEffect: json['soundEffect'] as String?,
      voiceClip: json['voiceClip'] as String?,
      isChoice: json['isChoice'] as bool? ?? false,
      nextId: json['nextId'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'speakerName': speakerName,
      'textJp': textJp,
      'furiganaJp': furiganaJp,
      'romajiJp': romajiJp,
      'textEn': textEn,
      'sprite': sprite,
      'position': position,
      'background': background,
      'soundEffect': soundEffect,
      'voiceClip': voiceClip,
      'isChoice': isChoice,
      'nextId': nextId,
      'tags': tags,
    };
  }

  /// Check if this dialogue has a specific tag
  bool hasTag(String tag) => tags.contains(tag);

  /// Get all vocabulary IDs mentioned in this dialogue
  List<String> get vocabularyIds =>
      tags.where((tag) => tag.startsWith('vocab:')).map((tag) => tag.substring(6)).toList();

  /// Get all grammar point IDs mentioned in this dialogue
  List<String> get grammarIds =>
      tags.where((tag) => tag.startsWith('grammar:')).map((tag) => tag.substring(8)).toList();

  /// Get all cultural note IDs mentioned in this dialogue
  List<String> get culturalNoteIds =>
      tags.where((tag) => tag.startsWith('culture:')).map((tag) => tag.substring(8)).toList();

  /// Copy with new values
  DialogueLine copyWith({
    String? id,
    String? characterId,
    String? speakerName,
    String? textJp,
    String? furiganaJp,
    String? romajiJp,
    String? textEn,
    String? sprite,
    String? position,
    String? background,
    String? soundEffect,
    String? voiceClip,
    bool? isChoice,
    String? nextId,
    List<String>? tags,
  }) {
    return DialogueLine(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      speakerName: speakerName ?? this.speakerName,
      textJp: textJp ?? this.textJp,
      furiganaJp: furiganaJp ?? this.furiganaJp,
      romajiJp: romajiJp ?? this.romajiJp,
      textEn: textEn ?? this.textEn,
      sprite: sprite ?? this.sprite,
      position: position ?? this.position,
      background: background ?? this.background,
      soundEffect: soundEffect ?? this.soundEffect,
      voiceClip: voiceClip ?? this.voiceClip,
      isChoice: isChoice ?? this.isChoice,
      nextId: nextId ?? this.nextId,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        characterId,
        speakerName,
        textJp,
        furiganaJp,
        romajiJp,
        textEn,
        sprite,
        position,
        background,
        soundEffect,
        voiceClip,
        isChoice,
        nextId,
        tags,
      ];
}

/// Model for a choice option
class DialogueChoice extends Equatable {
  /// Unique identifier for this choice
  final String id;

  /// Japanese text for this choice
  final String textJp;

  /// English text for this choice
  final String textEn;

  /// Furigana version of Japanese text (optional)
  final String? furiganaJp;

  /// What this choice means or communicates in English
  final String meaning;

  /// ID of the dialogue to go to if this choice is selected
  final String nextId;

  /// Required mastery level to see this choice (0 = always visible)
  final int requiredLevel;

  /// Required items to see this choice (empty = always visible)
  final List<String> requiredItems;

  /// Character relationship changes (characterId: points)
  final Map<String, int> relationshipChanges;

  /// Tags for special effects or triggers
  final List<String> tags;

  /// Create a dialogue choice
  const DialogueChoice({
    required this.id,
    required this.textJp,
    required this.textEn,
    this.furiganaJp,
    required this.meaning,
    required this.nextId,
    this.requiredLevel = 0,
    this.requiredItems = const [],
    this.relationshipChanges = const {},
    this.tags = const [],
  });

  /// Create from JSON map
  factory DialogueChoice.fromJson(Map<String, dynamic> json) {
    return DialogueChoice(
      id: json['id'] as String,
      textJp: json['textJp'] as String,
      textEn: json['textEn'] as String,
      furiganaJp: json['furiganaJp'] as String?,
      meaning: json['meaning'] as String,
      nextId: json['nextId'] as String,
      requiredLevel: json['requiredLevel'] as int? ?? 0,
      requiredItems: (json['requiredItems'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      relationshipChanges: (json['relationshipChanges'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as int),
          ) ??
          {},
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'textJp': textJp,
      'textEn': textEn,
      'furiganaJp': furiganaJp,
      'meaning': meaning,
      'nextId': nextId,
      'requiredLevel': requiredLevel,
      'requiredItems': requiredItems,
      'relationshipChanges': relationshipChanges,
      'tags': tags,
    };
  }

  /// Check if this choice is available with the given level and items
  bool isAvailable(int playerLevel, List<String> playerItems) {
    if (playerLevel < requiredLevel) return false;

    // Check if player has all required items
    for (final item in requiredItems) {
      if (!playerItems.contains(item)) return false;
    }

    return true;
  }

  /// Copy with new values
  DialogueChoice copyWith({
    String? id,
    String? textJp,
    String? textEn,
    String? furiganaJp,
    String? meaning,
    String? nextId,
    int? requiredLevel,
    List<String>? requiredItems,
    Map<String, int>? relationshipChanges,
    List<String>? tags,
  }) {
    return DialogueChoice(
      id: id ?? this.id,
      textJp: textJp ?? this.textJp,
      textEn: textEn ?? this.textEn,
      furiganaJp: furiganaJp ?? this.furiganaJp,
      meaning: meaning ?? this.meaning,
      nextId: nextId ?? this.nextId,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      requiredItems: requiredItems ?? this.requiredItems,
      relationshipChanges: relationshipChanges ?? this.relationshipChanges,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        textJp,
        textEn,
        furiganaJp,
        meaning,
        nextId,
        requiredLevel,
        requiredItems,
        relationshipChanges,
        tags,
      ];
}

/// Model for a dialogue node (line + choices)
class DialogueNode extends Equatable {
  /// The main dialogue line
  final DialogueLine line;

  /// Possible choices for this dialogue (empty if not a choice node)
  final List<DialogueChoice> choices;

  /// Create a dialogue node
  const DialogueNode({
    required this.line,
    this.choices = const [],
  });

  /// Create from JSON map
  factory DialogueNode.fromJson(Map<String, dynamic> json) {
    return DialogueNode(
      line: DialogueLine.fromJson(json['line'] as Map<String, dynamic>),
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => DialogueChoice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'line': line.toJson(),
      'choices': choices.map((c) => c.toJson()).toList(),
    };
  }

  /// Is this a choice node (has choices)
  bool get isChoiceNode => choices.isNotEmpty;

  /// Copy with new values
  DialogueNode copyWith({
    DialogueLine? line,
    List<DialogueChoice>? choices,
  }) {
    return DialogueNode(
      line: line ?? this.line,
      choices: choices ?? this.choices,
    );
  }

  @override
  List<Object> get props => [line, choices];
}

/// Model for a scene in the game
class GameScene extends Equatable {
  /// Unique identifier for this scene
  final String id;

  /// Title of the scene
  final String title;

  /// All dialogue nodes in this scene
  final Map<String, DialogueNode> nodes;

  /// ID of the starting node
  final String startNodeId;

  /// Background image to use for this scene
  final String? defaultBackground;

  /// Tags for this scene
  final List<String> tags;

  /// Create a game scene
  const GameScene({
    required this.id,
    required this.title,
    required this.nodes,
    required this.startNodeId,
    this.defaultBackground,
    this.tags = const [],
  });

  /// Create from JSON map
  factory GameScene.fromJson(Map<String, dynamic> json) {
    final nodesJson = json['nodes'] as Map<String, dynamic>;
    final nodes = <String, DialogueNode>{};

    for (final entry in nodesJson.entries) {
      nodes[entry.key] = DialogueNode.fromJson(entry.value as Map<String, dynamic>);
    }

    return GameScene(
      id: json['id'] as String,
      title: json['title'] as String,
      nodes: nodes,
      startNodeId: json['startNodeId'] as String,
      defaultBackground: json['defaultBackground'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    final nodesJson = <String, dynamic>{};

    for (final entry in nodes.entries) {
      nodesJson[entry.key] = entry.value.toJson();
    }

    return {
      'id': id,
      'title': title,
      'nodes': nodesJson,
      'startNodeId': startNodeId,
      'defaultBackground': defaultBackground,
      'tags': tags,
    };
  }

  /// Get the first dialogue node
  DialogueNode? get startNode => nodes[startNodeId];

  /// Get a dialogue node by ID
  DialogueNode? getNode(String nodeId) => nodes[nodeId];

  /// Check if this scene has a specific tag
  bool hasTag(String tag) => tags.contains(tag);

  @override
  List<Object?> get props => [
        id,
        title,
        nodes,
        startNodeId,
        defaultBackground,
        tags,
      ];
}

/// Model for a chapter in the game
class GameChapter extends Equatable {
  /// Unique identifier for this chapter
  final String id;

  /// Title of the chapter
  final String title;

  /// Description of the chapter
  final String description;

  /// IDs of scenes in this chapter
  final List<String> sceneIds;

  /// ID of the starting scene
  final String startSceneId;

  /// Prerequisites to unlock this chapter
  final List<String> prerequisites;

  /// Create a game chapter
  const GameChapter({
    required this.id,
    required this.title,
    required this.description,
    required this.sceneIds,
    required this.startSceneId,
    this.prerequisites = const [],
  });

  /// Create from JSON map
  factory GameChapter.fromJson(Map<String, dynamic> json) {
    return GameChapter(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      sceneIds: (json['sceneIds'] as List<dynamic>).map((e) => e as String).toList(),
      startSceneId: json['startSceneId'] as String,
      prerequisites: (json['prerequisites'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'sceneIds': sceneIds,
      'startSceneId': startSceneId,
      'prerequisites': prerequisites,
    };
  }

  /// Check if this chapter is available with completed chapters
  bool isAvailable(List<String> completedChapters) {
    // If no prerequisites, it's always available
    if (prerequisites.isEmpty) return true;

    // Check if all prerequisites are completed
    for (final prereq in prerequisites) {
      if (!completedChapters.contains(prereq)) return false;
    }

    return true;
  }

  @override
  List<Object> get props => [
        id,
        title,
        description,
        sceneIds,
        startSceneId,
        prerequisites,
      ];
}

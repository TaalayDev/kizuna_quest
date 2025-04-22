import 'package:equatable/equatable.dart';
import 'package:tsuzuki_connect/core/database/app_database.dart';

/// Domain model for a character with relationship information
class CharacterModel extends Equatable {
  /// Character ID
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

  /// Relationship (Kizuna) points with this character (optional)
  final int? kizunaPoints;

  /// Whether this character has a relationship entry
  final bool hasRelationship;

  /// Create a character model
  const CharacterModel({
    required this.id,
    required this.nameJp,
    required this.nameEn,
    required this.personality,
    required this.avatarPath,
    required this.spriteFolder,
    this.kizunaPoints,
    this.hasRelationship = false,
  });

  /// Create from database Character entity
  factory CharacterModel.fromEntity(Character character, {Relationship? relationship}) {
    return CharacterModel(
      id: character.id,
      nameJp: character.nameJp,
      nameEn: character.nameEn,
      personality: character.personality,
      avatarPath: character.avatarPath,
      spriteFolder: character.spriteFolder,
      kizunaPoints: relationship?.kizunaPoints,
      hasRelationship: relationship != null,
    );
  }

  /// Create from map (can be used with PlayerProgressDao.getCharactersWithRelationships)
  factory CharacterModel.fromMap(Map<String, dynamic> map) {
    final character = map['character'] as Character;
    final relationship = map['relationship'] as Relationship?;

    return CharacterModel.fromEntity(character, relationship: relationship);
  }

  /// Convert to database Character entity
  Character toEntity() {
    return Character(
      id: id,
      nameJp: nameJp,
      nameEn: nameEn,
      personality: personality,
      avatarPath: avatarPath,
      spriteFolder: spriteFolder,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get relationship level description
  String get relationshipLevel {
    if (kizunaPoints == null) return 'Unknown';

    if (kizunaPoints! >= 75) return 'Very Close';
    if (kizunaPoints! >= 50) return 'Close';
    if (kizunaPoints! >= 25) return 'Friendly';
    if (kizunaPoints! >= 10) return 'Acquaintance';
    return 'Stranger';
  }

  /// Copy with new values
  CharacterModel copyWith({
    int? id,
    String? nameJp,
    String? nameEn,
    String? personality,
    String? avatarPath,
    String? spriteFolder,
    int? kizunaPoints,
    bool? hasRelationship,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      nameJp: nameJp ?? this.nameJp,
      nameEn: nameEn ?? this.nameEn,
      personality: personality ?? this.personality,
      avatarPath: avatarPath ?? this.avatarPath,
      spriteFolder: spriteFolder ?? this.spriteFolder,
      kizunaPoints: kizunaPoints ?? this.kizunaPoints,
      hasRelationship: hasRelationship ?? this.hasRelationship,
    );
  }

  @override
  List<Object?> get props => [id, nameJp, nameEn, personality, avatarPath, spriteFolder, kizunaPoints, hasRelationship];
}

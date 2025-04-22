import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:tsuzuki_connect/core/database/app_database.dart';

/// Domain model for a save game
class SaveGameModel extends Equatable {
  /// Save game ID
  final int id;

  /// Save slot number (1-10, or 0 for quick save)
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

  /// Game settings as Map
  final Map<String, dynamic> settings;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  /// Create a save game model
  const SaveGameModel({
    required this.id,
    required this.slotId,
    required this.playerName,
    required this.currentChapter,
    required this.currentScene,
    required this.playTimeSeconds,
    required this.lastSavedAt,
    this.thumbnailPath,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from database SaveGame entity
  factory SaveGameModel.fromEntity(SaveGame saveGame) {
    // Parse settings JSON
    Map<String, dynamic> settingsMap;
    try {
      settingsMap = jsonDecode(saveGame.settingsJson) as Map<String, dynamic>;
    } catch (e) {
      settingsMap = {};
    }

    return SaveGameModel(
      id: saveGame.id,
      slotId: saveGame.slotId,
      playerName: saveGame.playerName,
      currentChapter: saveGame.currentChapter,
      currentScene: saveGame.currentScene,
      playTimeSeconds: saveGame.playTimeSeconds,
      lastSavedAt: saveGame.lastSavedAt,
      thumbnailPath: saveGame.thumbnailPath,
      settings: settingsMap,
      createdAt: saveGame.createdAt,
      updatedAt: saveGame.updatedAt,
    );
  }

  /// Convert to database SaveGame entity
  SaveGame toEntity() {
    return SaveGame(
      id: id,
      slotId: slotId,
      playerName: playerName,
      currentChapter: currentChapter,
      currentScene: currentScene,
      playTimeSeconds: playTimeSeconds,
      lastSavedAt: lastSavedAt,
      thumbnailPath: thumbnailPath,
      settingsJson: jsonEncode(settings),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert to SaveGamesCompanion for insertion/update
  SaveGamesCompanion toCompanion() {
    return SaveGamesCompanion.insert(
      slotId: slotId,
      playerName: playerName,
      currentChapter: currentChapter,
      currentScene: currentScene,
      playTimeSeconds: Value(playTimeSeconds),
      lastSavedAt: Value(lastSavedAt),
      thumbnailPath: Value(thumbnailPath),
      settingsJson: Value(jsonEncode(settings)),
    );
  }

  /// Get formatted play time (e.g., "2h 30m")
  String get formattedPlayTime {
    final hours = playTimeSeconds ~/ 3600;
    final minutes = (playTimeSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get slot display name
  String get slotDisplayName {
    if (slotId == 0) return 'Quick Save';
    return 'Slot $slotId';
  }

  /// Get formatted save date
  String get formattedSaveDate {
    return '${lastSavedAt.year}/${lastSavedAt.month.toString().padLeft(2, '0')}/${lastSavedAt.day.toString().padLeft(2, '0')} ${lastSavedAt.hour.toString().padLeft(2, '0')}:${lastSavedAt.minute.toString().padLeft(2, '0')}';
  }

  /// Copy with new values
  SaveGameModel copyWith({
    int? id,
    int? slotId,
    String? playerName,
    String? currentChapter,
    String? currentScene,
    int? playTimeSeconds,
    DateTime? lastSavedAt,
    String? thumbnailPath,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SaveGameModel(
      id: id ?? this.id,
      slotId: slotId ?? this.slotId,
      playerName: playerName ?? this.playerName,
      currentChapter: currentChapter ?? this.currentChapter,
      currentScene: currentScene ?? this.currentScene,
      playTimeSeconds: playTimeSeconds ?? this.playTimeSeconds,
      lastSavedAt: lastSavedAt ?? this.lastSavedAt,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Create new save game
  factory SaveGameModel.create({
    required int slotId,
    required String playerName,
    required String currentChapter,
    required String currentScene,
    int playTimeSeconds = 0,
    String? thumbnailPath,
    Map<String, dynamic>? settings,
  }) {
    final now = DateTime.now();
    return SaveGameModel(
      id: 0, // ID will be assigned by database
      slotId: slotId,
      playerName: playerName,
      currentChapter: currentChapter,
      currentScene: currentScene,
      playTimeSeconds: playTimeSeconds,
      lastSavedAt: now,
      thumbnailPath: thumbnailPath,
      settings: settings ?? {},
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  List<Object?> get props => [
        id,
        slotId,
        playerName,
        currentChapter,
        currentScene,
        playTimeSeconds,
        lastSavedAt,
        thumbnailPath,
        settings,
        createdAt,
        updatedAt,
      ];
}

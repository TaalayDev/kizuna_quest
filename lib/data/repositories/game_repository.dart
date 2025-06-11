import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:tsuzuki_connect/core/database/app_database.dart';
import 'package:tsuzuki_connect/core/database/daos/character_dao.dart';
import 'package:tsuzuki_connect/core/database/daos/player_progress_dao.dart';
import 'package:tsuzuki_connect/core/database/daos/save_game_dao.dart';
import 'package:tsuzuki_connect/data/datasources/vocabulary_data_source.dart';
import 'package:tsuzuki_connect/data/datasources/grammar_data_source.dart';
import 'package:tsuzuki_connect/data/datasources/cultural_notes_data_source.dart';
import 'package:tsuzuki_connect/data/models/character_model.dart';
import 'package:tsuzuki_connect/data/models/cultural_note_model.dart';
import 'package:tsuzuki_connect/data/models/dialogue_model.dart';
import 'package:tsuzuki_connect/data/models/game_progress_model.dart';
import 'package:tsuzuki_connect/data/models/grammar_point_model.dart';
import 'package:tsuzuki_connect/data/models/save_game_model.dart';
import 'package:tsuzuki_connect/data/models/vocabulary_model.dart';
import 'package:tsuzuki_connect/core/utils/app_logger.dart';
import 'package:path/path.dart' as path;

/// Repository for all game-related data access
class GameRepository {
  final AppDatabase _db;
  final CharacterDao _characterDao;
  final SaveGameDao _saveGameDao;
  final PlayerProgressDao _playerProgressDao;

  // Data sources for JSON content
  final VocabularyDataSource _vocabularyDataSource;
  final GrammarDataSource _grammarDataSource;
  final CulturalNotesDataSource _culturalNotesDataSource;

  /// Cache for loaded scenes
  final Map<String, GameScene> _sceneCache = {};

  /// Cache for loaded chapters
  final Map<String, GameChapter> _chapterCache = {};

  /// Create a new GameRepository
  GameRepository(
    this._db,
    this._vocabularyDataSource,
    this._grammarDataSource,
    this._culturalNotesDataSource,
  )   : _characterDao = CharacterDao(_db),
        _saveGameDao = SaveGameDao(_db),
        _playerProgressDao = PlayerProgressDao(_db);

  // ==================== Save Game Methods ====================

  /// Get all save games
  Stream<List<SaveGameModel>> getAllSaveGames() {
    final saves = _saveGameDao.watchAllSaveGames().map((saves) => saves.map(SaveGameModel.fromEntity).toList());
    return saves;
  }

  /// Get save game by ID
  Future<SaveGameModel?> getSaveGameById(int id) async {
    final save = await _saveGameDao.getSaveGameById(id);
    return save != null ? SaveGameModel.fromEntity(save) : null;
  }

  /// Get save game by slot
  Future<SaveGameModel?> getSaveGameBySlot(int slotId) async {
    final save = await _saveGameDao.getSaveGameBySlot(slotId);
    return save != null ? SaveGameModel.fromEntity(save) : null;
  }

  /// Create a new save game
  Future<int> createSaveGame(SaveGameModel saveGame) async {
    final saveId = await _saveGameDao.insertSaveGame(saveGame.toCompanion());

    // Initialize character relationships for the new save
    await _playerProgressDao.initializeRelationships(saveId);

    return saveId;
  }

  /// Update an existing save game
  Future<bool> updateSaveGame(SaveGameModel saveGame) async {
    return _saveGameDao.updateSaveGame(saveGame.toEntity());
  }

  /// Delete a save game
  Future<bool> deleteSaveGame(int id) async {
    final result = await _saveGameDao.deleteSaveGame(id);
    return result > 0;
  }

  /// Get available save slot
  Future<int?> getAvailableSaveSlot() {
    return _saveGameDao.getAvailableSaveSlot();
  }

  /// Watch all save games for changes
  Stream<List<SaveGameModel>> watchAllSaveGames() {
    return _saveGameDao.watchAllSaveGames().map((saves) => saves.map(SaveGameModel.fromEntity).toList());
  }

  /// Create a quick save
  Future<int> createQuickSave({
    required int currentSaveId,
    String? playerName,
    String? currentChapter,
    String? currentScene,
    int? playTimeSeconds,
    String? thumbnailPath,
    Map<String, dynamic>? settings,
  }) {
    return _saveGameDao.createQuickSave(
      currentSaveId: currentSaveId,
      playerName: playerName,
      currentChapter: currentChapter,
      currentScene: currentScene,
      playTimeSeconds: playTimeSeconds,
      thumbnailPath: thumbnailPath,
      settings: settings,
    );
  }

  // ==================== Character Methods ====================

  /// Get all characters
  Future<List<CharacterModel>> getAllCharacters() async {
    final characters = await _characterDao.getAllCharacters();
    return characters.map((c) => CharacterModel.fromEntity(c)).toList();
  }

  /// Get character by ID
  Future<CharacterModel?> getCharacterById(int id) async {
    final character = await _characterDao.getCharacterById(id);
    return character != null ? CharacterModel.fromEntity(character) : null;
  }

  /// Get characters with relationships for a save game
  Stream<List<CharacterModel>> getCharactersWithRelationships(int saveId) {
    final results = _playerProgressDao.watchCharactersWithRelationships(saveId).map((characters) {
      return characters.map(CharacterModel.fromMap).toList();
    });
    return results;
  }

  /// Get a specific character relationship
  Future<int> getRelationshipPoints(int saveId, int characterId) async {
    final relationship = await _playerProgressDao.getRelationship(saveId, characterId);
    return relationship?.kizunaPoints ?? 0;
  }

  /// Update relationship points
  Future<bool> updateRelationshipPoints(int saveId, int characterId, int deltaPoints) {
    return _playerProgressDao.updateKizunaPoints(saveId, characterId, deltaPoints);
  }

  Future<bool> unlockCharacter(int saveId, int characterId) async {
    return _playerProgressDao.unlockCharacter(saveId, characterId);
  }

  // ==================== Vocabulary Methods ====================

  /// Get all vocabulary items
  Future<List<VocabularyModel>> getAllVocabulary() async {
    return _vocabularyDataSource.getAll();
  }

  /// Get vocabulary item by ID
  Future<VocabularyModel?> getVocabularyById(int id, String chapter) async {
    return _vocabularyDataSource.getById(id, chapter);
  }

  /// Get vocabulary items by JLPT level
  Future<List<VocabularyModel>> getVocabularyByJlptLevel(String level, String chapter) async {
    return _vocabularyDataSource.getByJlptLevel(level, chapter);
  }

  /// Search vocabulary items
  Future<List<VocabularyModel>> searchVocabulary(String query, String chapter) async {
    return _vocabularyDataSource.search(query, chapter);
  }

  /// Get vocabulary with unlocked status for a save game
  Future<List<VocabularyModel>> getVocabularyWithStatus(int saveId) async {
    // Get all vocabulary
    final allVocabulary = await getAllVocabulary();

    // Get unlocked status from database
    final unlockedItems = await _playerProgressDao.getUnlockedVocabulary(saveId);

    // Create a map of vocabulary ID to unlocked info
    final Map<int, UnlockedVocabularyItem> unlockedMap = {};
    for (final item in unlockedItems) {
      unlockedMap[item.vocabularyId] = item;
    }

    // Combine vocabulary with unlocked status
    return allVocabulary.map((vocab) {
      final unlocked = unlockedMap[vocab.id];
      if (unlocked != null) {
        return vocab.copyWith(
          isUnlocked: true,
          masteryLevel: unlocked.masteryLevel,
          unlockedAt: unlocked.unlockedAt,
          lastReviewed: unlocked.lastReviewed,
        );
      }
      return vocab;
    }).toList();
  }

  /// Unlock a vocabulary item for a save game
  Future<bool> unlockVocabulary(int saveId, int vocabularyId) async {
    final result = await _playerProgressDao.unlockVocabulary(saveId, vocabularyId);
    return result > 0;
  }

  /// Update vocabulary mastery level
  Future<bool> updateVocabularyMastery(int saveId, int vocabularyId, int masteryLevel) {
    return _playerProgressDao.updateVocabularyMastery(saveId, vocabularyId, masteryLevel);
  }

  // ==================== Grammar Methods ====================

  /// Get all grammar points
  Future<List<GrammarPointModel>> getAllGrammarPoints() async {
    return _grammarDataSource.getAll();
  }

  /// Get grammar point by ID
  Future<GrammarPointModel?> getGrammarPointById(int id, String chapter) async {
    return _grammarDataSource.getById(id, chapter);
  }

  /// Get grammar points by JLPT level
  Future<List<GrammarPointModel>> getGrammarByJlptLevel(String level, String chapter) async {
    return _grammarDataSource.getByJlptLevel(level, chapter);
  }

  /// Search grammar points
  Future<List<GrammarPointModel>> searchGrammar(String query, String chapter) async {
    return _grammarDataSource.search(query, chapter);
  }

  /// Get grammar points with unlocked status for a save game
  Future<List<GrammarPointModel>> getGrammarWithStatus(int saveId) async {
    // Get all grammar points
    final allGrammar = await getAllGrammarPoints();

    // Get unlocked status from database
    final unlockedItems = await _playerProgressDao.getUnlockedGrammar(saveId);

    // Create a map of grammar ID to unlocked info
    final Map<int, UnlockedGrammarPoint> unlockedMap = {};
    for (final item in unlockedItems) {
      unlockedMap[item.grammarId] = item;
    }

    // Combine grammar with unlocked status
    return allGrammar.map((grammar) {
      final unlocked = unlockedMap[grammar.id];
      if (unlocked != null) {
        return grammar.copyWith(
          isUnlocked: true,
          isMastered: unlocked.isMastered,
          unlockedAt: unlocked.unlockedAt,
        );
      }
      return grammar;
    }).toList();
  }

  /// Unlock a grammar point for a save game
  Future<bool> unlockGrammar(int saveId, int grammarId) async {
    final result = await _playerProgressDao.unlockGrammar(saveId, grammarId);
    return result > 0;
  }

  /// Update grammar mastery status
  Future<bool> updateGrammarMastery(int saveId, int grammarId, bool isMastered) {
    return _playerProgressDao.updateGrammarMastery(saveId, grammarId, isMastered);
  }

  // ==================== Cultural Notes Methods ====================

  /// Get all cultural notes
  Future<List<CulturalNoteModel>> getAllCulturalNotes() async {
    return _culturalNotesDataSource.getAll();
  }

  /// Get cultural note by ID
  Future<CulturalNoteModel?> getCulturalNoteById(int id, String chapter) async {
    return _culturalNotesDataSource.getById(id, chapter);
  }

  /// Get cultural notes by category
  Future<List<CulturalNoteModel>> getCulturalNotesByCategory(String category) async {
    return _culturalNotesDataSource.getByCategory(category);
  }

  /// Search cultural notes
  Future<List<CulturalNoteModel>> searchCulturalNotes(String query) async {
    return _culturalNotesDataSource.search(query);
  }

  /// Get cultural notes with unlocked status for a save game
  Future<List<CulturalNoteModel>> getCulturalNotesWithStatus(int saveId) async {
    // Get all cultural notes
    final allNotes = await getAllCulturalNotes();

    // Get unlocked status from database
    final unlockedItems = await _playerProgressDao.getUnlockedCulturalNotes(saveId);

    // Create a map of cultural note ID to unlocked info
    final Map<int, UnlockedCulturalNote> unlockedMap = {};
    for (final item in unlockedItems) {
      unlockedMap[item.culturalNoteId] = item;
    }

    // Combine cultural notes with unlocked status
    return allNotes.map((note) {
      final unlocked = unlockedMap[note.id];
      if (unlocked != null) {
        return note.copyWith(
          isUnlocked: true,
          isRead: unlocked.isRead,
          unlockedAt: unlocked.unlockedAt,
        );
      }
      return note;
    }).toList();
  }

  /// Unlock a cultural note for a save game
  Future<bool> unlockCulturalNote(int saveId, int noteId) async {
    final result = await _playerProgressDao.unlockCulturalNote(saveId, noteId);
    return result > 0;
  }

  /// Mark cultural note as read
  Future<bool> markCulturalNoteAsRead(int saveId, int noteId) {
    return _playerProgressDao.markCulturalNoteAsRead(saveId, noteId);
  }

  // ==================== Game Progress Methods ====================

  /// Get overall game progress statistics
  Future<GameProgressModel> getGameProgress(int saveId) async {
    // Get vocabulary with status
    final vocabularyWithStatus = await getVocabularyWithStatus(saveId);

    // Get grammar with status
    final grammarWithStatus = await getGrammarWithStatus(saveId);

    // Get cultural notes with status
    final culturalNotesWithStatus = await getCulturalNotesWithStatus(saveId);

    // Calculate vocabulary statistics
    final VocabularyProgressStats vocabStats = _calculateVocabularyStats(vocabularyWithStatus);

    // Calculate grammar statistics
    final GrammarProgressStats grammarStats = _calculateGrammarStats(grammarWithStatus);

    // Calculate cultural notes statistics
    final CulturalNotesProgressStats culturalNotesStats = _calculateCulturalNotesStats(culturalNotesWithStatus);

    // Get relationship statistics
    final relationshipStats = await _getRelationshipStats(saveId);

    // Calculate total progress
    final totalProgress = _calculateTotalProgress(vocabStats, grammarStats, culturalNotesStats, relationshipStats);

    return GameProgressModel(
      vocabularyStats: vocabStats,
      grammarStats: grammarStats,
      culturalNotesStats: culturalNotesStats,
      relationshipStats: relationshipStats,
      totalProgressPercentage: totalProgress,
    );
  }

  // Helper methods to calculate statistics
  VocabularyProgressStats _calculateVocabularyStats(List<VocabularyModel> vocabulary) {
    final int total = vocabulary.length;
    final int unlocked = vocabulary.where((v) => v.isUnlocked).length;
    final int learning = vocabulary.where((v) => v.isUnlocked && v.masteryLevel == 1).length;
    final int learned = vocabulary.where((v) => v.isUnlocked && v.masteryLevel == 2).length;
    final int mastered = vocabulary.where((v) => v.isUnlocked && v.masteryLevel == 3).length;

    final double progressPercentage = total > 0 ? (unlocked / total) * 100.0 : 0.0;

    return VocabularyProgressStats(
      total: total,
      unlocked: unlocked,
      learning: learning,
      learned: learned,
      mastered: mastered,
      progressPercentage: progressPercentage,
    );
  }

  GrammarProgressStats _calculateGrammarStats(List<GrammarPointModel> grammar) {
    final int total = grammar.length;
    final int unlocked = grammar.where((g) => g.isUnlocked).length;
    final int mastered = grammar.where((g) => g.isUnlocked && g.isMastered).length;

    final double progressPercentage = total > 0 ? (unlocked / total) * 100.0 : 0.0;

    return GrammarProgressStats(
      total: total,
      unlocked: unlocked,
      mastered: mastered,
      progressPercentage: progressPercentage,
    );
  }

  CulturalNotesProgressStats _calculateCulturalNotesStats(List<CulturalNoteModel> notes) {
    final int total = notes.length;
    final int unlocked = notes.where((n) => n.isUnlocked).length;
    final int read = notes.where((n) => n.isUnlocked && n.isRead).length;

    final double progressPercentage = total > 0 ? (unlocked / total) * 100.0 : 0.0;

    return CulturalNotesProgressStats(
      total: total,
      unlocked: unlocked,
      read: read,
      progressPercentage: progressPercentage,
    );
  }

  /// Get relationship statistics for a save game
  Future<RelationshipProgressStats> _getRelationshipStats(int saveId) async {
    // Count total characters
    final allCharacters = await getAllCharacters();
    final totalCharacters = allCharacters.length;

    // Get all relationships
    final relationships = await _playerProgressDao.getRelationshipsForSave(saveId);

    // Count relationship levels
    int lowCount = 0; // 0-25 points
    int mediumCount = 0; // 26-50 points
    int highCount = 0; // 51+ points

    for (final relationship in relationships) {
      if (relationship.kizunaPoints <= 25) {
        lowCount++;
      } else if (relationship.kizunaPoints <= 50) {
        mediumCount++;
      } else {
        highCount++;
      }
    }

    // Calculate average relationship points
    double averagePoints = relationships.isNotEmpty
        ? relationships.map((r) => r.kizunaPoints).reduce((a, b) => a + b) / relationships.length
        : 0.0;

    return RelationshipProgressStats(
      totalCharacters: totalCharacters,
      lowRelationships: lowCount,
      mediumRelationships: mediumCount,
      highRelationships: highCount,
      averagePoints: averagePoints,
    );
  }

  /// Calculate overall progress percentage
  double _calculateTotalProgress(
    VocabularyProgressStats vocabStats,
    GrammarProgressStats grammarStats,
    CulturalNotesProgressStats culturalNotesStats,
    RelationshipProgressStats relationshipStats,
  ) {
    // Weights for different aspects of progress
    const double vocabWeight = 0.4;
    const double grammarWeight = 0.3;
    const double culturalNotesWeight = 0.2;
    const double relationshipWeight = 0.1;

    // Calculate weighted progress
    double weightedProgress = (vocabStats.progressPercentage * vocabWeight) +
        (grammarStats.progressPercentage * grammarWeight) +
        (culturalNotesStats.progressPercentage * culturalNotesWeight);

    // For relationships, use a different metric since it's not about unlocking
    int totalCharacters = relationshipStats.totalCharacters;
    int highRelationships = relationshipStats.highRelationships;
    int mediumRelationships = relationshipStats.mediumRelationships;

    // Give full weight to high relationships, half weight to medium
    double relationshipProgress = ((highRelationships + (mediumRelationships * 0.5)) / totalCharacters) * 100;

    weightedProgress += relationshipProgress * relationshipWeight;

    return weightedProgress;
  }

  // ==================== Script/Dialogue Methods ====================

  /// Load a chapter from assets
  Future<GameChapter?> loadChapter(String chapterId) async {
    // Check cache first
    if (_chapterCache.containsKey(chapterId)) {
      return _chapterCache[chapterId];
    }

    try {
      // Load chapter JSON from assets
      final chapterPath = 'assets/scripts/$chapterId/chapter.json';
      final jsonString = await rootBundle.loadString(chapterPath);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      // Create chapter object
      final chapter = GameChapter.fromJson(json);

      // Cache it
      _chapterCache[chapterId] = chapter;

      return chapter;
    } catch (e, stack) {
      AppLogger.error('Failed to load chapter $chapterId', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Load a scene from assets
  Future<GameScene?> loadScene(String chapterId, String sceneId) async {
    // Check cache first
    final cacheKey = '$chapterId/$sceneId';
    if (_sceneCache.containsKey(cacheKey)) {
      return _sceneCache[cacheKey];
    }

    try {
      // Load scene JSON from assets
      final scenePath = 'assets/scripts/$chapterId/scenes/$sceneId.json';
      final jsonString = await rootBundle.loadString(scenePath);
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      // Create scene object
      final scene = GameScene.fromJson(json);

      // Cache it
      _sceneCache[cacheKey] = scene;

      return scene;
    } catch (e, stack) {
      AppLogger.error('Failed to load scene $sceneId in chapter $chapterId', error: e, stackTrace: stack);
      return null;
    }
  }

  /// Clear script caches
  void clearScriptCaches() {
    _sceneCache.clear();
    _chapterCache.clear();
  }

  /// Get a list of all available chapters
  Future<List<GameChapter>> getAllChapters() async {
    try {
      // Get list of chapter directories
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

      // Find all chapter.json files
      final chapterPaths =
          manifestMap.keys.where((key) => key.startsWith('assets/scripts/') && key.endsWith('/chapter.json')).toList();

      // Load all chapters
      final chapters = <GameChapter>[];
      for (final path in chapterPaths) {
        // Extract chapter ID from path
        final chapterId = path.split('/')[2];
        final chapter = await loadChapter(chapterId);
        if (chapter != null) {
          chapters.add(chapter);
        }
      }

      return chapters;
    } catch (e, stack) {
      AppLogger.error('Failed to get all chapters', error: e, stackTrace: stack);
      return [];
    }
  }

  /// Dispose and close the database
  Future<void> dispose() async {
    await _db.close();
  }
}

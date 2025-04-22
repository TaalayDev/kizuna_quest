import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:tsuzuki_connect/core/database/app_database.dart';
import 'package:tsuzuki_connect/core/database/tables/save_games_table.dart';
import 'package:tsuzuki_connect/core/utils/app_logger.dart';
import 'package:tsuzuki_connect/core/utils/constants.dart';

part 'save_game_dao.g.dart';

/// Data Access Object for SaveGames table
@DriftAccessor(tables: [SaveGames])
class SaveGameDao extends DatabaseAccessor<AppDatabase> with _$SaveGameDaoMixin {
  /// Constructor
  SaveGameDao(super.db);

  /// Get all save games
  Future<List<SaveGame>> getAllSaveGames() {
    return (select(saveGames)..orderBy([(t) => OrderingTerm(expression: t.lastSavedAt, mode: OrderingMode.desc)]))
        .get();
  }

  Stream<List<SaveGame>> watchAllSaveGamesStream() {
    return (select(saveGames)..orderBy([(t) => OrderingTerm(expression: t.lastSavedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  /// Get save game by ID
  Future<SaveGame?> getSaveGameById(int id) {
    return (select(saveGames)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  /// Get save game by slot ID
  Future<SaveGame?> getSaveGameBySlot(int slotId) {
    return (select(saveGames)..where((s) => s.slotId.equals(slotId))).getSingleOrNull();
  }

  /// Get available (empty) save slot
  Future<int?> getAvailableSaveSlot() async {
    final usedSlots =
        await (select(saveGames)..orderBy([(t) => OrderingTerm(expression: t.slotId)])).map((row) => row.slotId).get();

    // Find the first available slot from 1 to maxSaveSlots
    for (int i = 1; i <= AppConstants.maxSaveSlots; i++) {
      if (!usedSlots.contains(i)) {
        return i;
      }
    }

    // All slots are used
    return null;
  }

  /// Insert a new save game
  Future<int> insertSaveGame(SaveGamesCompanion saveGame) {
    return into(saveGames).insert(saveGame);
  }

  /// Update a save game
  Future<bool> updateSaveGame(SaveGame saveGame) {
    return update(saveGames).replace(saveGame.copyWith(
      updatedAt: DateTime.now(),
      lastSavedAt: DateTime.now(),
    ));
  }

  /// Delete a save game
  Future<int> deleteSaveGame(int id) {
    return (delete(saveGames)..where((s) => s.id.equals(id))).go();
  }

  /// Delete a save game by slot ID
  Future<int> deleteSaveGameBySlot(int slotId) {
    return (delete(saveGames)..where((s) => s.slotId.equals(slotId))).go();
  }

  /// Watch for changes to all save games
  Stream<List<SaveGame>> watchAllSaveGames() {
    return (select(saveGames)..orderBy([(t) => OrderingTerm(expression: t.lastSavedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  /// Update game settings
  Future<bool> updateGameSettings(int saveId, Map<String, dynamic> settings) async {
    final saveGame = await getSaveGameById(saveId);
    if (saveGame == null) {
      return false;
    }

    final settingsJson = jsonEncode(settings);
    return updateSaveGame(saveGame.copyWith(settingsJson: settingsJson));
  }

  /// Get game settings
  Future<Map<String, dynamic>> getGameSettings(int saveId) async {
    final saveGame = await getSaveGameById(saveId);
    if (saveGame == null) {
      return {};
    }

    try {
      return jsonDecode(saveGame.settingsJson) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Failed to parse game settings', error: e);
      return {};
    }
  }

  /// Update play time
  Future<bool> updatePlayTime(int saveId, int additionalSeconds) async {
    final saveGame = await getSaveGameById(saveId);
    if (saveGame == null) {
      return false;
    }

    final newPlayTime = saveGame.playTimeSeconds + additionalSeconds;
    return updateSaveGame(saveGame.copyWith(playTimeSeconds: newPlayTime));
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
  }) async {
    try {
      // Get data from the current save if available
      final currentSave = await getSaveGameById(currentSaveId);

      if (currentSave == null) {
        throw Exception('Current save not found');
      }
      final savePlayerName = playerName ?? currentSave.playerName;
      final saveChapter = currentChapter ?? currentSave.currentChapter;
      final saveScene = currentScene ?? currentSave.currentScene;
      final savePlayTime = playTimeSeconds ?? currentSave.playTimeSeconds;
      final saveSettings = settings ?? await getGameSettings(currentSaveId);
      final thumbPath = thumbnailPath ?? currentSave.thumbnailPath;

      // Create new quick save
      await updateSaveGame(SaveGame(
        id: currentSave.id,
        slotId: currentSave.slotId,
        playerName: savePlayerName,
        currentChapter: saveChapter,
        currentScene: saveScene,
        playTimeSeconds: savePlayTime,
        thumbnailPath: thumbPath,
        settingsJson: jsonEncode(saveSettings),
        updatedAt: DateTime.now(),
        lastSavedAt: DateTime.now(),
        createdAt: currentSave.createdAt,
      ));

      return currentSave.id;
    } catch (e) {
      // Use slot 0 for quick save
      const quickSaveSlotId = 0;

      // Check if quick save exists and delete it
      await deleteSaveGameBySlot(quickSaveSlotId);

      AppLogger.error('Failed to create quick save', error: e);
      return insertSaveGame(SaveGamesCompanion.insert(
        slotId: quickSaveSlotId,
        playerName: playerName ?? "Player",
        currentChapter: currentChapter ?? "chapter_1",
        currentScene: currentScene ?? "scene_1",
        playTimeSeconds: Value(playTimeSeconds ?? 0),
        thumbnailPath: Value(thumbnailPath),
        settingsJson: Value(settings != null ? jsonEncode(settings) : '{}'),
      ));
    }
  }
}

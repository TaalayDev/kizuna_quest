import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kizuna_quest/core/database/app_database.dart';
import 'package:kizuna_quest/data/repositories/game_repository.dart';
import 'package:kizuna_quest/utils/app_logger.dart';
import 'package:kizuna_quest/data/datasources/vocabulary_data_source.dart';
import 'package:kizuna_quest/data/datasources/grammar_data_source.dart';
import 'package:kizuna_quest/data/datasources/cultural_notes_data_source.dart';

import '../data/models/character_model.dart';
import '../data/models/cultural_note_model.dart';
import '../data/models/grammar_point_model.dart';
import '../data/models/save_game_model.dart';
import '../data/models/vocabulary_model.dart';

/// Provider for the AppDatabase
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  // Dispose the database when the provider is disposed
  ref.onDispose(() async {
    AppLogger.info('Closing database connection');
    await db.close();
  });

  return db;
});

/// Provider for the VocabularyDataSource
final vocabularyDataSourceProvider = Provider<VocabularyDataSource>((ref) {
  return VocabularyDataSource();
});

/// Provider for the GrammarDataSource
final grammarDataSourceProvider = Provider<GrammarDataSource>((ref) {
  return GrammarDataSource();
});

/// Provider for the CulturalNotesDataSource
final culturalNotesDataSourceProvider = Provider<CulturalNotesDataSource>((ref) {
  return CulturalNotesDataSource();
});

/// Provider for the GameRepository
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final vocabularyDataSource = ref.watch(vocabularyDataSourceProvider);
  final grammarDataSource = ref.watch(grammarDataSourceProvider);
  final culturalNotesDataSource = ref.watch(culturalNotesDataSourceProvider);

  final repository = GameRepository(db, vocabularyDataSource, grammarDataSource, culturalNotesDataSource);

  // Dispose the repository when the provider is disposed
  ref.onDispose(() async {
    AppLogger.info('Disposing game repository');
    await repository.dispose();
  });

  return repository;
});

/// Provider for the current active save game ID
final activeSaveIdProvider = StateProvider<int?>((ref) => null);

/// Provider for watching the current active save game
final activeSaveGameProvider = StreamProvider((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return Stream.value(null);
  }

  return gameRepository.watchAllSaveGames().map((saveGames) {
    return saveGames.firstWhere(
      (save) => save.id == activeSaveId,
      orElse: () => throw StateError('Active save game not found'),
    );
  });
});

/// Provider for character relationships in the active save
final characterRelationshipsProvider = FutureProvider<List<CharacterModel>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return <CharacterModel>[];
  }

  return gameRepository.getCharactersWithRelationships(activeSaveId);
});

/// Provider for vocabulary with status in the active save
final vocabularyWithStatusProvider = FutureProvider<List<VocabularyModel>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return <VocabularyModel>[];
  }

  return gameRepository.getVocabularyWithStatus(activeSaveId);
});

/// Provider for grammar points with status in the active save
final grammarWithStatusProvider = FutureProvider<List<GrammarPointModel>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return <GrammarPointModel>[];
  }

  return gameRepository.getGrammarWithStatus(activeSaveId);
});

/// Provider for cultural notes with status in the active save
final culturalNotesWithStatusProvider = FutureProvider<List<CulturalNoteModel>>((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return <CulturalNoteModel>[];
  }

  return gameRepository.getCulturalNotesWithStatus(activeSaveId);
});

/// Provider for overall game progress in the active save
final gameProgressProvider = FutureProvider((ref) async {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final activeSaveId = ref.watch(activeSaveIdProvider);

  if (activeSaveId == null) {
    return null;
  }

  return gameRepository.getGameProgress(activeSaveId);
});

/// Provider for all available chapters
final allChaptersProvider = FutureProvider((ref) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  return gameRepository.getAllChapters();
});

/// Provider for the current chapter
final currentChapterProvider = FutureProvider.family<dynamic, String>((ref, chapterId) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  return gameRepository.loadChapter(chapterId);
});

/// Provider for a specific scene
final sceneProvider = FutureProvider.family<dynamic, (String, String)>((ref, params) {
  final gameRepository = ref.watch(gameRepositoryProvider);
  final (chapterId, sceneId) = params;
  return gameRepository.loadScene(chapterId, sceneId);
});

final allSaveGamesProvider = FutureProvider<List<SaveGameModel>>((ref) async {
  final gameRepository = ref.watch(gameRepositoryProvider);
  return gameRepository.getAllSaveGames();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuzuki_connect/data/models/dialogue_model.dart';
import 'package:tsuzuki_connect/providers/database_provider.dart';

/// Provider for the current active chapter ID
final activeChapterIdProvider = StateProvider<String?>((ref) => null);

/// Provider for the current active scene ID
final activeSceneIdProvider = StateProvider<String?>((ref) => null);

/// Provider for the current dialogue node ID
final currentDialogueIdProvider = StateProvider<String?>((ref) => null);

/// Provider for tracking total play time
final currentPlayTimeProvider = StateProvider<int>((ref) => 0);

/// Provider for tracking if dialogue is currently loading
final isLoadingDialogueProvider = StateProvider<bool>((ref) => false);

/// Provider for the active chapter data
final activeChapterProvider = FutureProvider<GameChapter?>((ref) {
  final chapterId = ref.watch(activeChapterIdProvider);
  if (chapterId == null) return null;

  final gameRepository = ref.watch(gameRepositoryProvider);
  return gameRepository.loadChapter(chapterId);
});

/// Provider for the active scene data
final activeSceneProvider = FutureProvider<GameScene?>((ref) {
  final chapterId = ref.watch(activeChapterIdProvider);
  final sceneId = ref.watch(activeSceneIdProvider);

  if (chapterId == null || sceneId == null) return null;

  final gameRepository = ref.watch(gameRepositoryProvider);
  return gameRepository.loadScene(chapterId, sceneId);
});

/// Provider for the current dialogue node
final currentDialogueProvider = FutureProvider<DialogueNode?>((ref) async {
  final dialogueId = ref.watch(currentDialogueIdProvider);
  final scene = await ref.watch(activeSceneProvider.future);

  // If no dialogue ID is set, use the start node of the scene
  if (dialogueId == null && scene != null) {
    // Set the dialogue ID to the start node
    ref.read(currentDialogueIdProvider.notifier).state = scene.startNodeId;

    // Set loading flag
    ref.read(isLoadingDialogueProvider.notifier).state = true;

    // Get the start node
    final startNode = scene.getNode(scene.startNodeId);

    // Clear loading flag
    ref.read(isLoadingDialogueProvider.notifier).state = false;

    return startNode;
  }

  // If we have a dialogue ID, get that specific node
  if (dialogueId != null && scene != null) {
    // Set loading flag
    ref.read(isLoadingDialogueProvider.notifier).state = true;

    // Get the node
    final node = scene.getNode(dialogueId);

    // Clear loading flag
    ref.read(isLoadingDialogueProvider.notifier).state = false;

    return node;
  }

  return null;
});

/// Provider for dialogue history (last 20 lines)
final dialogueHistoryProvider = StateProvider<List<DialogueLine>>((ref) => []);

/// Provider to track if auto mode is enabled
final isAutoModeEnabledProvider = StateProvider<bool>((ref) => false);

/// Provider to track if skip mode is enabled
final isSkipModeEnabledProvider = StateProvider<bool>((ref) => false);

/// Provider to track if game menu is open
final isGameMenuOpenProvider = StateProvider<bool>((ref) => false);

/// Provider to track currently active character sprites
final characterSpritesProvider = StateProvider<Map<String, String>>((ref) => {});

/// Provider to add dialogue to history
final addToHistoryProvider = (DialogueLine line) => (ref) {
      final history = ref.read(dialogueHistoryProvider);

      // Add line to history, maintaining max size of 20
      final newHistory = [...history, line];
      if (newHistory.length > 20) {
        newHistory.removeAt(0);
      }

      ref.read(dialogueHistoryProvider.notifier).state = newHistory;
    };

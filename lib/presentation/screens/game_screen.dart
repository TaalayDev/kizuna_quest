import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kizuna_quest/core/services/settings_service.dart';
import 'package:kizuna_quest/data/models/character_model.dart';
import 'package:kizuna_quest/data/models/dialogue_model.dart';
import 'package:kizuna_quest/data/models/save_game_model.dart';
import 'package:kizuna_quest/presentation/widgets/game/character_sprite.dart';
import 'package:kizuna_quest/presentation/widgets/game/choice_button.dart';
import 'package:kizuna_quest/presentation/widgets/game/dialogue_box.dart';
import 'package:kizuna_quest/presentation/widgets/game/game_menu.dart';
import 'package:kizuna_quest/presentation/widgets/game/grammar_popup.dart';
import 'package:kizuna_quest/presentation/widgets/game/vocabulary_popup.dart';
import 'package:kizuna_quest/providers/database_provider.dart';
import 'package:kizuna_quest/providers/game_providers.dart';
import 'package:kizuna_quest/core/utils/app_logger.dart';
import 'package:kizuna_quest/core/utils/constants.dart';
import 'package:kizuna_quest/core/utils/extensions.dart';
import 'package:kizuna_quest/core/utils/screenshot_helper.dart';
import 'package:screenshot/screenshot.dart';

import '../widgets/game/cultural_note_popup.dart';

/// Main game screen for the visual novel
class GameScreen extends ConsumerStatefulWidget {
  /// ID of the chapter to load
  final String? chapterId;

  /// ID of the save game to load (optional)
  final String? saveId;

  /// Creates a GameScreen
  const GameScreen({
    super.key,
    this.chapterId,
    this.saveId,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> with TickerProviderStateMixin {
  final ScreenshotController _screenshotController = ScreenshotController();

  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _dialogueController;
  late AnimationController _spriteController;
  late AnimationController _choicesController;

  // Game state
  bool _isMenuOpen = false;
  bool _isSkipping = false;
  bool _isAutoMode = false;
  Timer? _autoModeTimer;
  int _elapsedPlayTime = 0;
  Timer? _playTimeTimer;
  bool _isTextComplete = false;
  String _currentBackground = '';

  // UI state for animations
  bool _showChoices = false;
  bool _showVocabPopup = false;
  bool _showGrammarPopup = false;
  bool _showCulturalNotePopup = false;
  bool _isCapturingScreenshot = false;

  // UI state for scene transitions
  bool _isSceneTransitioning = false;
  bool _isChapterTransitioning = false;
  String _nextChapterTitle = '';

  // Dynamic content
  Map<String, CharacterModel> _characters = {};
  List<Widget> _characterSprites = [];

  @override
  void initState() {
    super.initState();

    _initializeAnimationControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGameSession();

      // Start the play time counter
      _startPlayTimeTimer();
    });
  }

  @override
  void dispose() {
    // Dispose animation controllers
    _backgroundController.dispose();
    _dialogueController.dispose();
    _spriteController.dispose();
    _choicesController.dispose();

    // Cancel timers
    _autoModeTimer?.cancel();
    _playTimeTimer?.cancel();

    super.dispose();
  }

  void _initializeAnimationControllers() {
    // Background transition animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Dialogue box animation
    _dialogueController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Character sprite animation
    _spriteController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Choices animation
    _choicesController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  Future<void> _initializeGameSession() async {
    // Set active chapter in provider
    if (widget.chapterId != null) {
      ref.read(activeChapterIdProvider.notifier).state = widget.chapterId;
    }

    // If a save ID is provided, load that save
    if (widget.saveId != null) {
      final saveId = int.tryParse(widget.saveId!);
      if (saveId != null) {
        await ref.read(activeSaveIdProvider.notifier).setActiveSaveId(saveId);

        // Initialize game from save
        await _loadFromSave(saveId);
      }
    } else {
      // New game, start from beginning
      await _initializeNewGame();
    }

    // Pre-load character data for this chapter
    await _loadCharactersForChapter();
  }

  Future<void> _loadFromSave(int saveId) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final saveGame = await gameRepository.getSaveGameById(saveId);

    if (saveGame != null) {
      // Load chapter and scene from save
      final chapterId = saveGame.currentChapter;
      final sceneId = saveGame.currentScene;

      ref.read(activeChapterIdProvider.notifier).state = chapterId;
      ref.read(activeSceneIdProvider.notifier).state = sceneId;
      ref.read(currentPlayTimeProvider.notifier).state = saveGame.playTimeSeconds;

      _elapsedPlayTime = saveGame.playTimeSeconds;
    }
  }

  Future<void> _initializeNewGame() async {
    // For a new game, we need to:
    // 1. Create a new save game record
    // 2. Load the first chapter and scene
    final gameRepository = ref.read(gameRepositoryProvider);

    final chapterId = widget.chapterId ?? 'chapter_1';
    final chapter = await gameRepository.loadChapter(chapterId);

    if (chapter != null) {
      // Set initial scene
      ref.read(activeSceneIdProvider.notifier).state = chapter.startSceneId;

      // Create a new save game entry
      final availableSlot = await gameRepository.getAvailableSaveSlot() ?? 1;
      final playerName = "Player"; // This would come from a name entry screen

      final newSaveGame = SaveGameModel.create(
        slotId: availableSlot,
        playerName: playerName,
        currentChapter: chapterId,
        currentScene: chapter.startSceneId,
      );

      final saveId = await gameRepository.createSaveGame(newSaveGame);

      // Set as active save
      await ref.read(activeSaveIdProvider.notifier).setActiveSaveId(saveId);
    }
  }

  Future<void> _loadCharactersForChapter() async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final characters = await gameRepository.getAllCharacters();

    // Create a map for easy access
    Map<String, CharacterModel> characterMap = {};
    for (var character in characters) {
      characterMap[character.id.toString()] = character;
    }

    setState(() {
      _characters = characterMap;
    });
  }

  void _startPlayTimeTimer() {
    _playTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedPlayTime++;
      });

      // Update provider
      ref.read(currentPlayTimeProvider.notifier).state = _elapsedPlayTime;
    });
  }

  Future<String?> _captureScreenshot() async {
    // Don't capture if we're already capturing or if menus/popups are open
    if (_isCapturingScreenshot || _isMenuOpen || _showVocabPopup || _showGrammarPopup || _showCulturalNotePopup) {
      return null;
    }

    setState(() {
      _isCapturingScreenshot = true;
    });

    try {
      // Use a delay to ensure the UI is fully rendered
      await Future.delayed(const Duration(milliseconds: 100));

      // Capture and save screenshot
      final activeSaveId = ref.read(activeSaveIdProvider);
      final currentSceneId = ref.read(activeSceneIdProvider);

      final fileName = 'save_${activeSaveId}_${currentSceneId ?? 'unknown'}';
      final screenshotPath = await ScreenshotHelper.takeAndSaveScreenshot(
        controller: _screenshotController,
        fileName: fileName,
      );

      if (screenshotPath != null) {
        // Generate a thumbnail for the save game
        final thumbnailPath = await ScreenshotHelper.generateThumbnail(
          screenshotPath: screenshotPath,
          thumbnailName: 'thumb_$fileName',
          width: 320,
          height: 180,
        );

        return thumbnailPath;
      }
    } catch (e, stack) {
      AppLogger.error('Error capturing screenshot', error: e, stackTrace: stack);
    } finally {
      setState(() {
        _isCapturingScreenshot = false;
      });
    }

    return null;
  }

  Future<void> _quickSave() async {
    setState(() {
      _isMenuOpen = false;
    });

    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId != null) {
      final save = await gameRepository.getSaveGameById(activeSaveId);

      if (save != null) {
        final currentChapterId = ref.read(activeChapterIdProvider) ?? save.currentChapter;
        final currentSceneId = ref.read(activeSceneIdProvider) ?? save.currentScene;

        final thumbnailPath = await _captureScreenshot();

        await gameRepository.createQuickSave(
          playerName: save.playerName,
          currentChapter: currentChapterId,
          currentScene: currentSceneId,
          playTimeSeconds: _elapsedPlayTime,
          thumbnailPath: thumbnailPath,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Game saved successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _advanceDialogue() {
    final currentDialogue = ref.read(currentDialogueProvider).valueOrNull;

    if (currentDialogue == null) return;

    if (!_isTextComplete) {
      // If text is still typing, complete it immediately
      setState(() {
        _isTextComplete = true;
      });
      return;
    }

    // If this is a choice node and choices are shown, do nothing
    if (currentDialogue.isChoiceNode && _showChoices) {
      return;
    }

    // If current node has choices but we haven't shown them yet, show them
    if (currentDialogue.isChoiceNode && !_showChoices) {
      _showDialogueChoices();
      return;
    }

    // Otherwise, advance to next dialogue
    _nextDialogue();
  }

  /// Checks if the current dialogue node is the end of a scene
  bool _isEndOfScene(DialogueNode? dialogueNode) {
    if (dialogueNode == null) return false;

    // If it's a choice node, it's not the end
    if (dialogueNode.isChoiceNode) return false;

    // If it has a next dialogue ID, it's not the end
    if (dialogueNode.line.nextId != null) return false;

    // Otherwise, we're at the end of the scene
    return true;
  }

  void _nextDialogue() {
    final currentDialogue = ref.read(currentDialogueProvider).valueOrNull;

    if (currentDialogue == null) return;

    // Reset UI state
    setState(() {
      _isTextComplete = false;
      _showChoices = false;
    });

    if (!currentDialogue.isChoiceNode && currentDialogue.line.nextId != null) {
      // Proceed to next dialogue node
      ref.read(currentDialogueIdProvider.notifier).state = currentDialogue.line.nextId;
    } else {
      // End of scene reached, load the next scene
      AppLogger.info('End of current dialogue path reached');
      _loadNextScene();
    }
  }

  void _makeChoice(DialogueChoice choice) {
    // Check if user meets requirements for this choice
    if (_canMakeChoice(choice)) {
      // Hide choices
      setState(() {
        _showChoices = false;
      });

      // Process relationship changes
      _processRelationshipChanges(choice);

      // Navigate to next dialogue
      ref.read(currentDialogueIdProvider.notifier).state = choice.nextId;
    } else {
      // Show message that requirements are not met
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You need to learn more Japanese to understand this option.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool _canMakeChoice(DialogueChoice choice) {
    // This would check language level requirements
    final userLanguageLevel = SettingsService.getLanguageLevel();

    return choice.requiredLevel <= userLanguageLevel;
  }

  Future<void> _loadNextScene() async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final currentChapterId = ref.read(activeChapterIdProvider);
    final currentSceneId = ref.read(activeSceneIdProvider);

    if (currentChapterId == null || currentSceneId == null) {
      AppLogger.error('Cannot load next scene: chapter or scene ID is null');
      return;
    }

    try {
      // Get current chapter data
      final chapter = await gameRepository.loadChapter(currentChapterId);
      if (chapter == null) {
        AppLogger.error('Cannot load next scene: chapter $currentChapterId not found');
        return;
      }

      // Find the index of the current scene in the chapter
      final currentSceneIndex = chapter.sceneIds.indexOf(currentSceneId);
      if (currentSceneIndex == -1) {
        AppLogger.error('Current scene $currentSceneId not found in chapter $currentChapterId');
        return;
      }

      // Check if there is a next scene
      if (currentSceneIndex < chapter.sceneIds.length - 1) {
        // Get the next scene ID
        final nextSceneId = chapter.sceneIds[currentSceneIndex + 1];

        // Display scene transition UI
        await _showSceneTransition();

        // Update the active scene ID
        ref.read(activeSceneIdProvider.notifier).state = nextSceneId;

        // Reset dialogue ID to null so it will start from the beginning of the new scene
        ref.read(currentDialogueIdProvider.notifier).state = null;

        // Save progress
        _saveProgress(currentChapterId, nextSceneId);

        AppLogger.info('Loaded next scene: $nextSceneId');
      } else {
        // This is the last scene in the chapter
        await _handleChapterEnd(currentChapterId);
      }
    } catch (e, stack) {
      AppLogger.error('Error loading next scene', error: e, stackTrace: stack);

      // Show error message to the user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error loading next scene'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Handles the end of a chapter
  Future<void> _handleChapterEnd(String currentChapterId) async {
    final gameRepository = ref.read(gameRepositoryProvider);

    try {
      // Get all chapters to find the next one
      final allChapters = await gameRepository.getAllChapters();

      // Find current chapter by ID
      final currentChapterIndex = allChapters.indexWhere((c) => c.id == currentChapterId);
      if (currentChapterIndex == -1) {
        AppLogger.error('Current chapter $currentChapterId not found in all chapters');
        return;
      }

      // Check if there is a next chapter
      if (currentChapterIndex < allChapters.length - 1) {
        // Get the next chapter
        final nextChapter = allChapters[currentChapterIndex + 1];

        // Show chapter transition UI
        await _showChapterTransition(nextChapter.id, nextChapter.title);

        // Prompt user to continue to next chapter
        if (context.mounted) {
          final goToNextChapter = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Chapter Complete'),
                  content: Text('Do you want to continue to ${nextChapter.title}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Return to Menu'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ) ??
              false;

          if (goToNextChapter) {
            // Update the active chapter and scene IDs
            ref.read(activeChapterIdProvider.notifier).state = nextChapter.id;
            ref.read(activeSceneIdProvider.notifier).state = nextChapter.startSceneId;

            // Reset dialogue ID
            ref.read(currentDialogueIdProvider.notifier).state = null;

            // Save progress
            _saveProgress(nextChapter.id, nextChapter.startSceneId);

            AppLogger.info('Started next chapter: ${nextChapter.id}');
          } else {
            // Return to home screen
            if (context.mounted) {
              context.go(AppConstants.routeHome);
            }
          }
        }
      } else {
        // This is the last chapter in the game
        await _showGameCompleteScreen();
      }
    } catch (e, stack) {
      AppLogger.error('Error handling chapter end', error: e, stackTrace: stack);
    }
  }

  /// Saves the current progress
  Future<void> _saveProgress(String chapterId, String sceneId) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId == null) {
      AppLogger.warning('Cannot save progress: no active save ID');
      return;
    }

    try {
      final saveGame = await gameRepository.getSaveGameById(activeSaveId);
      if (saveGame != null) {
        // Update save game with new chapter and scene
        final updatedSave = saveGame.copyWith(
          currentChapter: chapterId,
          currentScene: sceneId,
          playTimeSeconds: _elapsedPlayTime,
          lastSavedAt: DateTime.now(),
        );

        // Save the updated game state
        await gameRepository.updateSaveGame(updatedSave);

        AppLogger.info('Progress saved: chapter=$chapterId, scene=$sceneId');
      }
    } catch (e, stack) {
      AppLogger.error('Failed to save progress', error: e, stackTrace: stack);
    }
  }

  /// Shows a transition animation between scenes
  Future<void> _showSceneTransition() async {
    setState(() {
      _isSceneTransitioning = true;
    });

    // Wait for the fade-out animation to complete
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isSceneTransitioning = false;
    });

    // Reset character sprites when transitioning to a new scene
    setState(() {
      _characterSprites = [];
      _currentBackground = '';
    });
  }

  /// Shows a transition animation between chapters
  Future<void> _showChapterTransition(String nextChapterId, String chapterTitle) async {
    setState(() {
      _isChapterTransitioning = true;
      _nextChapterTitle = chapterTitle;
    });

    // Wait for the transition animation to complete
    await Future.delayed(const Duration(milliseconds: 2000));

    setState(() {
      _isChapterTransitioning = false;
      _nextChapterTitle = '';
    });

    // Reset character sprites and background when transitioning to a new chapter
    setState(() {
      _characterSprites = [];
      _currentBackground = '';
    });
  }

  /// Shows the game complete screen
  Future<void> _showGameCompleteScreen() async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You have completed all available chapters of Kizuna Quest. Thank you for playing!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppConstants.routeHome);
            },
            child: const Text('Return to Menu'),
          ),
        ],
      ),
    );
  }

  Future<void> _processRelationshipChanges(DialogueChoice choice) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId == null) return;

    // Apply relationship changes
    for (final entry in choice.relationshipChanges.entries) {
      final characterId = int.tryParse(entry.key);
      final pointChange = entry.value;

      if (characterId != null) {
        await gameRepository.updateRelationshipPoints(
          activeSaveId,
          characterId,
          pointChange,
        );
      }
    }
  }

  void _showDialogueChoices() {
    setState(() {
      _showChoices = true;
    });

    // Animate choices appearing
    _choicesController.forward(from: 0.0);
  }

  void _toggleAutoMode() {
    setState(() {
      _isAutoMode = !_isAutoMode;
      _isSkipping = false; // Turn off skipping if enabled
    });

    if (_isAutoMode) {
      _startAutoMode();
    } else {
      _autoModeTimer?.cancel();
    }
  }

  void _startAutoMode() {
    final autoDelay = SettingsService.getAutoplayDelay();

    _autoModeTimer?.cancel();
    _autoModeTimer = Timer.periodic(
      Duration(milliseconds: autoDelay),
      (timer) {
        final currentDialogue = ref.read(currentDialogueProvider).valueOrNull;

        // Only advance if text is complete and no choices are shown
        if (_isTextComplete && !_showChoices) {
          // If we're at the end of a scene, use a longer delay
          if (_isEndOfScene(currentDialogue)) {
            // Cancel the current timer
            timer.cancel();

            // Wait a bit longer before advancing to next scene
            Future.delayed(const Duration(seconds: 2), () {
              if (_isAutoMode) {
                _advanceDialogue();
                // Restart auto mode
                _startAutoMode();
              }
            });
          } else {
            // Normal dialogue advancement
            _advanceDialogue();
          }
        }
      },
    );
  }

  void _toggleSkipMode() {
    setState(() {
      _isSkipping = !_isSkipping;
      _isAutoMode = false; // Turn off auto mode if enabled
    });

    if (_isSkipping) {
      _startSkipping();
    }
  }

  void _startSkipping() {
    // Skip mode just rapidly advances through dialogue
    // This is a simplified implementation
    _autoModeTimer?.cancel();
    _autoModeTimer = Timer.periodic(
      const Duration(milliseconds: 300),
      (timer) {
        if (!_showChoices) {
          _advanceDialogue();
        } else {
          // Stop skipping when choices are encountered
          setState(() {
            _isSkipping = false;
          });
          _autoModeTimer?.cancel();
        }
      },
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _updateCharacterSprites(DialogueLine? currentLine) {
    if (currentLine == null) return;

    // Process background change if needed
    if (currentLine.background != null && currentLine.background != _currentBackground) {
      setState(() {
        _currentBackground = currentLine.background!;
      });

      // Animate background change
      _backgroundController.forward(from: 0.0);
    }

    // Process character sprites
    List<Widget> sprites = [];

    // This is simplified - a full implementation would track which characters
    // are on screen and animate entrances/exits/position changes
    if (currentLine.characterId != null && currentLine.sprite != null) {
      final character = _characters[currentLine.characterId];
      final position = currentLine.position ?? 'center';

      if (character != null) {
        sprites.add(
          CharacterSprite(
            character: character,
            expression: currentLine.sprite!,
            position: position,
            isSpeaking: true,
            key: ValueKey('${character.id}_${currentLine.sprite}'),
          ),
        );
      }
    }

    setState(() {
      _characterSprites = sprites;
    });

    // Animate character sprite changes
    _spriteController.forward(from: 0.0);
  }

  void _checkForLearningMoments(DialogueLine? currentLine) {
    if (currentLine == null) return;

    // Check if this line has vocabulary to learn
    if (currentLine.vocabularyIds.isNotEmpty) {
      setState(() {
        _showVocabPopup = true;
      });

      _unlockVocabularyItems(currentLine.vocabularyIds);
    }

    // Check if this line introduces grammar points
    if (currentLine.grammarIds.isNotEmpty) {
      setState(() {
        _showGrammarPopup = true;
      });

      _unlockGrammarPoints(currentLine.grammarIds);
    }

    if (currentLine.culturalNoteIds.isNotEmpty) {
      setState(() {
        _showCulturalNotePopup = true; // Added cultural notes popup
      });

      // Ensure cultural notes are unlocked even if popup is dismissed
      _unlockCulturalNotes(currentLine.culturalNoteIds);
    }
  }

  void _closePopups() {
    setState(() {
      _showVocabPopup = false;
      _showGrammarPopup = false;
      _showCulturalNotePopup = false; // Added cultural notes popup
    });
  }

  Future<void> _unlockVocabularyItems(List<String> vocabIds) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId == null) return;

    for (final id in vocabIds) {
      final vocabId = int.tryParse(id);
      if (vocabId != null) {
        await gameRepository.unlockVocabulary(activeSaveId, vocabId);
      }
    }
  }

  Future<void> _unlockCulturalNotes(List<String> noteIds) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId == null) return;

    for (final id in noteIds) {
      final noteId = int.tryParse(id);
      if (noteId != null) {
        await gameRepository.unlockCulturalNote(activeSaveId, noteId);
      }
    }
  }

  Future<void> _unlockGrammarPoints(List<String> grammarIds) async {
    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId == null) return;

    for (final id in grammarIds) {
      final grammarId = int.tryParse(id);
      if (grammarId != null) {
        await gameRepository.unlockGrammar(activeSaveId, grammarId);
      }
    }
  }

  Future<void> _checkAndUnlockCharacter(DialogueLine? line) async {
    if (line?.characterId == null) return;

    final characterId = int.tryParse(line!.characterId!);
    if (characterId == null) return;

    final gameRepository = ref.read(gameRepositoryProvider);
    final activeSaveId = ref.read(activeSaveIdProvider);

    if (activeSaveId != null) {
      final result = await gameRepository.unlockCharacter(activeSaveId, characterId);

      if (result) {
        AppLogger.info('Unlocked new character with ID $characterId');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to dialogue changes
    final currentDialogue = ref.watch(currentDialogueProvider).valueOrNull;
    final isLoading = ref.watch(isLoadingDialogueProvider);

    ref.listen(
      currentDialogueProvider,
      (previous, next) {
        if (next.valueOrNull != null) {
          // Update background and character sprites
          _updateCharacterSprites(next.value!.line);

          // Check and unlock the character if this is first encounter
          _checkAndUnlockCharacter(next.value!.line);

          // Check for vocabulary or grammar learning moments
          _checkForLearningMoments(next.value!.line);

          // Reset text complete state
          setState(() {
            _isTextComplete = false;
            _showChoices = false;
          });

          // Animate dialogue box
          _dialogueController.forward(from: 0.0);
        } else {
          // Hide choices if no dialogue
          setState(() {
            _showChoices = false;
          });
        }
      },
    );

    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image - with fade transition animation
            _buildBackgroundLayer(),

            // Character sprites
            ..._characterSprites,

            // Dialogue and UI elements
            Column(
              children: [
                // Top UI bar
                _buildTopUI(),

                // Flexible space between top and bottom
                const Spacer(),

                // Dialogue box at the bottom
                _buildDialogueBox(currentDialogue, isLoading),
              ],
            ),

            // Dialogue choices (conditionally shown)
            if (_showChoices && currentDialogue != null && currentDialogue.choices.isNotEmpty)
              _buildChoices(currentDialogue.choices),

            // Game menu (conditionally shown)
            if (_isMenuOpen) _buildGameMenu(),

            // Learning popups (vocabulary, grammar)
            if (_showVocabPopup)
              _buildVocabularyPopup(currentDialogue)
            else if (_showGrammarPopup)
              _buildGrammarPopup(currentDialogue),
            if (_showCulturalNotePopup) _buildCulturalNotePopup(currentDialogue),

            // Scene transition overlay
            if (_isSceneTransitioning)
              AnimatedOpacity(
                opacity: _isSceneTransitioning ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ),

            if (_isChapterTransitioning)
              AnimatedOpacity(
                opacity: _isChapterTransitioning ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CHAPTER',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _nextChapterTitle,
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 800.ms),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundLayer() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Container(
        key: ValueKey(_currentBackground),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              //_currentBackground.isNotEmpty ? _currentBackground :
              'assets/images/backgrounds/car_interior.webp',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTopUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            // Back button (opens exit confirmation)
            IconButton(
              onPressed: () => _showExitConfirmation(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 5,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // History button
            IconButton(
              onPressed: () => _showHistoryLog(),
              icon: Icon(
                Icons.history,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 5,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              tooltip: 'History',
            ),

            // Skip button
            IconButton(
              onPressed: _toggleSkipMode,
              icon: Icon(
                Icons.fast_forward,
                color: _isSkipping ? context.theme.colorScheme.primary : Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 5,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              tooltip: 'Skip',
            ),

            // Auto mode button
            IconButton(
              onPressed: _toggleAutoMode,
              icon: Icon(
                Icons.play_circle,
                color: _isAutoMode ? context.theme.colorScheme.primary : Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 5,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              tooltip: 'Auto',
            ),

            // Menu button
            IconButton(
              onPressed: _toggleMenu,
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 5,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              tooltip: 'Menu',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogueBox(DialogueNode? currentDialogue, bool isLoading) {
    if (isLoading || currentDialogue == null) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return GestureDetector(
      onTap: _advanceDialogue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: _dialogueController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - _dialogueController.value) * 50),
              child: Opacity(
                opacity: _dialogueController.value,
                child: DialogueBox(
                  line: currentDialogue.line,
                  character:
                      currentDialogue.line.characterId != null ? _characters[currentDialogue.line.characterId] : null,
                  onTextComplete: () {
                    setState(() {
                      _isTextComplete = true;
                    });
                  },
                  textSpeed: SettingsService.getTextSpeed(),
                  showFurigana: SettingsService.isShowFurigana(),
                  showRomaji: SettingsService.isShowRomaji(),
                  instantComplete: _isSkipping,
                ),
              ),
            );
          },
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(
            begin: 0.2,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOutQuad,
          ),
    );
  }

  Widget _buildChoices(List<DialogueChoice> choices) {
    return Positioned(
      bottom: 220, // Position above dialogue box
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _choicesController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.9 + (_choicesController.value * 0.1),
            child: Opacity(
              opacity: _choicesController.value,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < choices.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ChoiceButton(
                    choice: choices[i],
                    onTap: () => _makeChoice(choices[i]),
                    showFurigana: SettingsService.isShowFurigana(),
                    canMakeChoice: _canMakeChoice(choices[i]),
                    index: i,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameMenu() {
    return GameMenu(
      onClose: _toggleMenu,
      onSave: _quickSave,
      onLoad: () {
        // Load game logic
      },
      onSettings: () {
        // Navigate to settings
        context.push(AppConstants.routeSettings);
      },
      onExit: () {
        // Exit to main menu
        context.go(AppConstants.routeHome);
      },
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildVocabularyPopup(DialogueNode? currentDialogue) {
    if (currentDialogue == null) return const SizedBox.shrink();

    final vocabIds = currentDialogue.line.vocabularyIds;
    if (vocabIds.isEmpty) return const SizedBox.shrink();

    return VocabularyPopup(
      vocabularyIds: vocabIds,
      onClose: _closePopups,
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildGrammarPopup(DialogueNode? currentDialogue) {
    if (currentDialogue == null) return const SizedBox.shrink();

    final grammarIds = currentDialogue.line.grammarIds;
    if (grammarIds.isEmpty) return const SizedBox.shrink();

    return GrammarPopup(
      grammarIds: grammarIds,
      onClose: _closePopups,
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildCulturalNotePopup(DialogueNode? currentDialogue) {
    if (currentDialogue == null) return const SizedBox.shrink();

    final noteIds = currentDialogue.line.culturalNoteIds;
    if (noteIds.isEmpty) return const SizedBox.shrink();

    return CulturalNotePopup(
      culturalNoteIds: noteIds,
      onClose: _closePopups,
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Game?'),
        content: const Text('Do you want to save your progress before exiting?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppConstants.routeHome);
            },
            child: const Text('Exit Without Saving'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _quickSave();
              if (context.mounted) {
                context.go(AppConstants.routeHome);
              }
            },
            child: const Text('Save and Exit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showHistoryLog() {
    // This would show a scrollable log of recent dialogue
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: context.screenHeight * 0.7,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dialogue History',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                // This would contain the dialogue history
                children: [
                  // Placeholder for history items
                  Text(
                    'History feature coming soon...',
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

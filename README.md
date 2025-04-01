kizuna_quest/
├── android/                 # Android specific platform files (Requires Firebase setup - google-services.json)
├── ios/                     # iOS specific platform files (Requires Firebase setup - GoogleService-Info.plist)
├── linux/                   # Linux Desktop specific platform files (Firebase setup might vary)
├── macos/                   # macOS Desktop specific platform files (Firebase setup might vary)
├── web/                     # Web specific platform files (Requires Firebase JS SDK setup)
├── windows/                 # Windows Desktop specific platform files (Firebase setup might vary)
├── assets/                  # Contains all game assets (MUST be declared in pubspec.yaml)
│   ├── images/              # Backgrounds, character sprites, UI elements
│   │   ├── backgrounds/
│   │   ├── characters/      # Sprites grouped by character
│   │   └── ui/              # Buttons, icons, etc.
│   ├── scripts/             # Narrative scripts (e.g., JSON or YAML format)
│   │   ├── chapter_1/       # Example: Group scripts by chapter or module
│   │   └── common/          # Common script elements or shared events
│   ├── fonts/               # Custom fonts used in the game
│   └── audio/               # Optional: Sound effects (if used)
├── lib/                     # Main application source code (Dart)
│   ├── main.dart            # App entry point, initialization (Firebase.initializeApp, setup Riverpod Scope)
│   ├── core/                # Core logic, independent of UI
│   │   ├── engine/          # Visual Novel engine logic
│   │   │   ├── narrative_parser.dart  # Logic to parse script files
│   │   │   └── game_controller.dart # Manages game flow, state transitions
│   │   ├── database/        # Local database setup and operations (using Drift)
│   │   │   ├── app_database.dart    # Drift database class definition (*.g.dart generated)
│   │   │   ├── daos/              # Optional: Data Access Objects for complex queries
│   │   │   └── tables/            # Optional: Define tables in separate files or .drift files
│   │   └── services/        # Other background services
│   │       ├── analytics_service.dart # Service to wrap Firebase Analytics calls
│   │       └── settings_service.dart  # Example: For settings persistence
│   ├── data/                # Data models and potentially repositories (interact w/ Drift DAOs)
│   │   └── models/          # Application domain models (distinct from Drift table companions)
│   │       ├── character_model.dart
│   │       ├── dialogue_model.dart  # Represents lines, choices
│   │       ├── vocab_entry_model.dart
│   │       └── save_game_model.dart
│   ├── presentation/        # UI related code (Widgets, Screens, State Management)
│   │   ├── state/           # State management logic (using Riverpod Providers)
│   │   │   ├── game_providers.dart    # Riverpod providers related to game state
│   │   │   └── menu_providers.dart    # Riverpod providers related to menus
│   │   ├── screens/         # Major application screens/views (often ConsumerWidgets/StatefulWidgets)
│   │   │   ├── splash_screen.dart
│   │   │   ├── main_menu_screen.dart
│   │   │   ├── game_screen.dart     # The core visual novel gameplay screen
│   │   │   ├── kotoba_log_screen.dart # Screen to view unlocked vocabulary
│   │   │   └── settings_screen.dart
│   │   └── widgets/         # Reusable UI components (often StatelessWidget or ConsumerWidget)
│   │       ├── common/          # General reusable widgets (e.g., custom buttons)
│   │       ├── game/            # Widgets specific to the game screen (dialogue box, sprites)
│   │       └── menu/            # Widgets specific to menu screens
│   ├── utils/               # Utility functions, constants, helpers
│   │   ├── constants.dart     # App-wide constants (colors, keys, etc.)
│   │   └── extensions.dart    # Dart extension methods
│   └── config/              # Application configuration
│       ├── routes.dart        # Navigation routes setup
│       └── theme.dart         # Application theme data
├── test/                    # Automated tests
│   ├── core/                # Tests for core logic
│   ├── presentation/        # Widget tests (may need ProviderScope setup)
│   └── ...                  # Other test categories
├── pubspec.yaml             # Flutter project configuration (dependencies, assets)
└── README.md                # Project overview, setup instructions
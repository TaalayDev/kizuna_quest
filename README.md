# Tsuzuki Connect

A Japanese language learning adventure in the form of an interactive visual novel, built with Flutter.

## Screenshots

<!-- Screenshots table -->
| ![Screenshot 1](https://is2-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/f8/73/4a/f8734aac-769a-7fce-e408-a2afb71c96a7/1255@3x__U00281_U0029__U00281_U0029.png/0x0ss.png) | ![Screenshot 2](https://is2-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/39/86/51/39865143-d090-8fa5-da67-91a6821f1181/1256@3x__U00282_U0029__U00281_U0029.png/0x0ss.png) | ![Screenshot 3](https://is2-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/4a/2a/b0/4a2ab09c-4b34-ff74-1a59-f8856ffe472c/1258@3x__U00282_U0029__U00281_U0029.png/0x0ss.png) |

## Overview

Tsuzuki Connect (続きコネクト) is an educational visual novel that combines language learning with immersive storytelling. Players navigate through daily life scenarios in Tokyo, building relationships with characters while learning Japanese through context-driven gameplay.

The app uniquely integrates language acquisition directly into the gameplay - your ability to understand and correctly use Japanese is your key to progress.

## Key Features

### Interactive Language Learning
- **Choice-Based Dialogue System**: Make meaningful communication choices based on your understanding of Japanese
- **Integrated Learning System**: New vocabulary and grammar points are highlighted in context and added to your personal learning journal
- **Progressive Difficulty**: Language complexity naturally increases as you progress through the story

### Visual Novel Experience
- **Immersive Storytelling**: Engaging narrative set in modern Tokyo with memorable characters
- **Character Relationships**: Build "Kizuna" (bonds) with characters through your dialogue choices
- **Branching Storylines**: Your choices affect relationships, scenes, and story development

### Learning Tools
- **Kotoba Log (言葉帳)**: Review vocabulary you've encountered organized by JLPT level and categories
- **Grammar Points**: Learn new grammar structures through natural dialogue
- **Cultural Notes**: Discover insights about Japanese culture, customs, and daily life

### Technical Features
- **Cross-Platform**: Built with Flutter for Android, iOS, Desktop (Windows, macOS, Linux), and Web
- **Offline Mode**: Fully functional without internet connection after initial download
- **Progress Tracking**: Multiple save slots and automatic save functionality
- **Customizable Settings**: Adjust text speed, toggle furigana/romaji, and more

## Development Setup

### Prerequisites
- Flutter SDK (>=3.3.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter plugins
- Git

### Getting Started

1. Clone the repository
   ```bash
   git clone https://github.com/TaalayDev/tsuzuki_connect.git
   cd tsuzuki_connect
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the code generator for Drift, Riverpod, etc.
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the app
   ```bash
   flutter run
   ```

For different build targets:
```bash
# Run the script to build for specific platforms
./manage.sh build apk       # For Android APK
./manage.sh build appbundle # For Android App Bundle
./manage.sh build ipa       # For iOS
```

### Project Structure

The project follows a clean architecture approach:

```
kizuna_quest/
├── lib/
│   ├── core/               # Core functionality
│   │   ├── database/       # Local database with Drift
│   │   ├── services/       # Application services
│   │   └── utils/          # Utility functions
│   ├── data/               # Data layer
│   │   ├── datasources/    # Data sources and repositories
│   │   └── models/         # Domain models
│   ├── presentation/       # UI layer
│   │   ├── screens/        # App screens
│   │   └── widgets/        # Reusable widgets
│   ├── providers/          # State management with Riverpod
│   └── config/             # App configuration
├── assets/                 # Game assets
│   ├── images/             # Images and sprites
│   ├── scripts/            # Game scripts in JSON
│   └── data/               # Game data files
└── test/                   # Automated tests
```

## Architectural Details

### State Management
The app uses **Riverpod** for state management, with providers organized by feature:
- `GameProviders`: Manages the game state, dialogue, and scenes
- `DatabaseProviders`: Handles database access and game progress
- `SettingsProviders`: Manages user preferences
- `ThemeProviders`: Controls app theme settings

### Database
The app uses **Drift** (formerly Moor) for local SQLite database functionality:
- Character data
- Save games
- Player progress (vocabulary, grammar, cultural notes)
- Relationship tracking

### Navigation
**GoRouter** is used for navigation between screens, with route definitions in `app_router.dart`.

## Game Content Structure

Game content is structured in JSON files:
- **Chapters**: Contain metadata and scene lists
- **Scenes**: Collections of dialogue nodes and choices
- **Dialogue**: Individual lines with associated data (speaker, text, etc.)
- **Choices**: Player options with consequences

Example script structure:
```json
{
  "id": "scene_1",
  "title": "First Day",
  "nodes": {
    "node_1": {
      "line": {
        "id": "line_1",
        "characterId": "1",
        "textJp": "こんにちは！",
        "textEn": "Hello!",
        "nextId": "line_2",
        "tags": ["vocab:1", "grammar:2"]
      }
    }
  },
  "startNodeId": "node_1"
}
```

## Contributing

We welcome contributions! Please check the [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Implement your changes
4. Add tests where applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Tsuzuki Connect - Learn Japanese through adventure!*
# Contributing to Tsuzuki Connect

Thank you for your interest in contributing to Tsuzuki Connect! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Workflow](#workflow)
- [Coding Guidelines](#coding-guidelines)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Content Contribution Guidelines](#content-contribution-guidelines)
- [Translation Contributions](#translation-contributions)

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone. Please be considerate and respectful in your communications and actions.

## Getting Started

1. Fork the repository on GitHub
2. Clone your forked repository to your local machine
3. Set the original repository as an upstream remote:

## Development Setup

1. Install Flutter SDK (>=3.3.0)
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Make sure all tests pass:
   ```bash
   flutter test
   ```

## Workflow

1. Create a new branch for your feature/bugfix:
   ```bash
   git checkout -b feature/your-feature
   # or
   git checkout -b fix/your-bugfix
   ```
2. Make your changes
3. Run the formatter and linter:
   ```bash
   dart format .
   flutter analyze
   ```
4. Run tests to ensure nothing broke:
   ```bash
   flutter test
   ```
5. Commit your changes (see [Commit Guidelines](#commit-guidelines))
6. Push to your fork:
   ```bash
   git push origin feature/your-feature
   ```
7. Create a pull request

## Coding Guidelines

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use consistent and meaningful naming conventions
- Add meaningful comments where necessary
- Write unit tests for new features
- Follow the existing project architecture

### Flutter Specific Guidelines

- Keep widgets focused on a single responsibility
- Extract reusable widgets into their own files
- Use const constructors where possible
- Prefer using Riverpod for state management
- Follow existing state management patterns
- Ensure UI elements are accessible

## Commit Guidelines

Please follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for your commit messages:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

Types include:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (formatting, etc.)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

Example:
```
feat(dialogue): add support for furigana in choice text

- Add furigana parsing to choice buttons
- Update UI to display furigana above kanji
- Add toggle in settings
```

## Pull Request Process

1. Update the README.md or documentation with details of changes if appropriate
2. Make sure all tests pass and new code is covered by tests
3. The pull request will be reviewed by project maintainers
4. Address any requested changes
5. Once approved, a maintainer will merge your PR

## Content Contribution Guidelines

### Game Scripts

If you're contributing game scripts:

1. Follow the existing JSON format for scenes and dialogues
2. Ensure Japanese text is grammatically correct
3. Provide accurate English translations
4. Add appropriate JLPT tags to vocabulary and grammar points
5. Test your script in the game to ensure it flows correctly

### Character and Background Art

1. Match the existing art style
2. Follow the naming conventions in the `assets` folder
3. Optimize images appropriately
4. Include character sprites with necessary expressions
5. Provide source files (e.g., .psd, .ai) where possible

## Translation Contributions

We welcome translations into other languages:

1. For new language support, create an issue first to discuss implementation
2. Follow the existing localization structure
3. Ensure translations capture cultural nuances
4. Test your translations in the app

---

Thank you for contributing to Tsuzuki Connect! Your efforts help make this educational game better for language learners around the world.
/// Application-wide constants
class AppConstants {
  // App info
  static const String appName = 'Tsuzuki Connect';
  static const String appDescription = 'A visual novel language learning adventure';

  // Routes
  static const String routeSplash = '/';
  static const String routeHome = '/home';
  static const String routeGame = '/game';
  static const String routeSettings = '/settings';
  static const String routeKotobaLog = '/kotoba';
  static const String routeCultureNotes = '/culture';
  static const String onboardingRoute = '/onboarding';

  // Animation durations
  static const Duration animFast = Duration(milliseconds: 250);
  static const Duration animNormal = Duration(milliseconds: 500);
  static const Duration animSlow = Duration(milliseconds: 800);
  static const Duration splashDuration = Duration(seconds: 2);

  // Storage
  static const String saveGamePrefix = 'savegame_';
  static const int maxSaveSlots = 10;

  // Asset paths
  static const String assetsBackground = 'assets/images/backgrounds';
  static const String assetsCharacters = 'assets/images/characters';
  static const String assetsUI = 'assets/images/ui';
  static const String assetsScripts = 'assets/scripts';

  // Game settings
  static const int defaultTextSpeed = 40; // ms per character
  static const bool defaultAutoplayEnabled = false;
  static const int defaultAutoplayDelay = 2000; // ms
  static const double defaultTextSize = 16.0;

  // Audio
  static const double defaultMusicVolume = 0.7;
  static const double defaultSfxVolume = 1.0;
  static const bool defaultAudioEnabled = true;

  static const String privacyPolicyUrl = 'https://taalaydev.github.io/kizuna-quest/privacy-policy.html';
  static const String termsOfServiceUrl = 'https://taalaydev.github.io/kizuna-quest/terms-of-service.html';

  const AppConstants._();
}

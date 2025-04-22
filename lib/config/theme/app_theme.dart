import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tsuzuki_connect/config/theme/custom_colors.dart';

/// Application theme configurations
class AppTheme {
  // Private constructor to prevent instantiation
  const AppTheme._();

  // Font families
  static const String _japaneseFont = 'NotoSansJP';
  static const String _defaultFont = 'Mochiy';

  // Light theme
  static final ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.deepPurple,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // Customize with our own text theme
    textTheme: _createTextTheme(
      GoogleFonts.notoSansJpTextTheme(),
      Colors.black,
    ),
    // Add custom colors
    extensions: [lightCustomColors],
  ).copyWith(
    // Custom theme overrides
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: _defaultFont,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardTheme(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
    ),
    chipTheme: const ChipThemeData(
      elevation: 1,
      side: BorderSide.none,
    ),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
        fontFamily: _defaultFont,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.deepPurple,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 10,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // Customize with our own text theme
    textTheme: _createTextTheme(
      GoogleFonts.notoSansJpTextTheme(),
      Colors.white,
    ),
    // Add custom colors
    extensions: [darkCustomColors],
  ).copyWith(
    // Custom theme overrides (same as light theme)
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: _defaultFont,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardTheme(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
    ),
    chipTheme: const ChipThemeData(
      elevation: 1,
      side: BorderSide.none,
    ),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
        fontFamily: _defaultFont,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Create custom text theme
  static TextTheme _createTextTheme(TextTheme baseTheme, Color textColor) {
    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(
        fontFamily: _defaultFont,
        color: textColor,
      ),
      displayMedium: baseTheme.displayMedium?.copyWith(
        fontFamily: _defaultFont,
        color: textColor,
      ),
      displaySmall: baseTheme.displaySmall?.copyWith(
        fontFamily: _defaultFont,
        color: textColor,
      ),
      headlineLarge: baseTheme.headlineLarge?.copyWith(
        fontFamily: _defaultFont,
        color: textColor,
      ),
      headlineMedium: baseTheme.headlineMedium?.copyWith(
        fontFamily: _defaultFont,
        color: textColor,
      ),
      headlineSmall: baseTheme.headlineSmall?.copyWith(
        fontFamily: _defaultFont,
        color: textColor,
      ),
      titleLarge: baseTheme.titleLarge?.copyWith(
        fontFamily: _defaultFont,
        color: textColor,
      ),
      titleMedium: baseTheme.titleMedium?.copyWith(
        fontFamily: _japaneseFont,
        color: textColor,
      ),
      titleSmall: baseTheme.titleSmall?.copyWith(
        fontFamily: _japaneseFont,
        color: textColor,
      ),
      bodyLarge: baseTheme.bodyLarge?.copyWith(
        fontFamily: _japaneseFont,
        color: textColor,
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        fontFamily: _japaneseFont,
        color: textColor,
      ),
      bodySmall: baseTheme.bodySmall?.copyWith(
        fontFamily: _japaneseFont,
        color: textColor,
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        fontFamily: _japaneseFont,
        color: textColor,
      ),
      labelMedium: baseTheme.labelMedium?.copyWith(
        fontFamily: _japaneseFont,
        color: textColor,
      ),
      labelSmall: baseTheme.labelSmall?.copyWith(
        fontFamily: _japaneseFont,
        color: textColor,
      ),
    );
  }
}

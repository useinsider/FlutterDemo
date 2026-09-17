import 'package:flutter/material.dart';

import 'package:flutter_demo/theme/insider_colors.dart';

/// The Flutter side of the design system the native Android demo declares in
/// `app/src/main/res/values/styles.xml`. Every metric below is the value its
/// `SuperApp.*` counterpart uses, so the two demos render the same surfaces.
abstract final class InsiderTheme {
  /// Family name declared under `flutter: fonts:` in pubspec.yaml.
  static const String fontFamily = 'Kufam';

  /// Corner radius of every card surface — `item_app_frames_placement.xml`.
  static const double cardRadius = 18;

  /// Corner radius shared by buttons and inputs — `SuperApp.Button` / `SuperApp.Input`.
  static const double controlRadius = 14;

  /// Corner radius of the in-card compact text actions — `SuperApp.Button.TextCompact`.
  static const double compactControlRadius = 12;

  /// Height every full-width button and input box holds, so a side-by-side pair lines up.
  static const double controlHeight = 52;

  /// Width of the outline stroke on cards, inputs and dividers.
  static const double strokeWidth = 1;

  /// Height of a Playground action button — `item_playground_button.xml`.
  static const double playgroundButtonHeight = 60;

  /// Fixed height of the Playground output console — `activity_playground.xml`.
  static const double playgroundConsoleHeight = 124;

  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: InsiderColors.navy,
      onPrimary: InsiderColors.white,
      secondary: InsiderColors.orange,
      onSecondary: InsiderColors.white,
      surface: InsiderColors.white,
      onSurface: InsiderColors.onSurface,
      surfaceContainerHighest: InsiderColors.surfaceVariant,
      onSurfaceVariant: InsiderColors.onSurfaceVariant,
      outline: InsiderColors.outline,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: InsiderColors.surface,

      appBarTheme: const AppBarTheme(
        backgroundColor: InsiderColors.navy,
        foregroundColor: InsiderColors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: InsiderColors.white,
        ),
      ),

      // SuperApp.Button — filled primary action.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: InsiderColors.navy,
          foregroundColor: InsiderColors.white,
          minimumSize: const Size.fromHeight(controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(controlRadius),
          ),
        ),
      ),

      // SuperApp.Button.Outlined — same 52dp footprint as the filled button.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: InsiderColors.onSurface,
          backgroundColor: InsiderColors.white,
          minimumSize: const Size.fromHeight(controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          side: const BorderSide(
            color: InsiderColors.outline,
            width: strokeWidth,
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(controlRadius),
          ),
        ),
      ),

      // SuperApp.Button.TextCompact — in-card row actions.
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: InsiderColors.onSurface,
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compactControlRadius),
          ),
        ),
      ),

      // SuperApp.Input — outlined box, 14dp corner, 1dp outline stroke.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: InsiderColors.white,
        constraints: const BoxConstraints(minHeight: controlHeight),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          color: InsiderColors.onSurfaceVariant,
        ),
        border: _inputBorder(InsiderColors.outline),
        enabledBorder: _inputBorder(InsiderColors.outline),
        focusedBorder: _inputBorder(InsiderColors.navy),
      ),

      // item_app_frames_placement.xml — white, 18dp radius, 1dp outline, no shadow.
      cardTheme: CardThemeData(
        color: InsiderColors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(
            color: InsiderColors.outline,
            width: strokeWidth,
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: InsiderColors.outline,
        thickness: strokeWidth,
        space: strokeWidth,
      ),

      textTheme: const TextTheme(
        // item_playground_header.xml — 20sp kufam_bold, tight tracking.
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: InsiderColors.iosTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: InsiderColors.onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: InsiderColors.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: InsiderColors.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: InsiderColors.onSurfaceVariant,
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(controlRadius),
        borderSide: BorderSide(color: color, width: strokeWidth),
      );
}

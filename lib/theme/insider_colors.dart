import 'package:flutter/material.dart';

/// The Insider brand palette, mirroring the `insider_*` colours in the native
/// Android demo's `app/src/main/res/values/colors.xml`.
///
/// This is the only place in the app allowed to spell out a colour literal —
/// every widget reads its colours from here or from [InsiderTheme].
abstract final class InsiderColors {
  static const Color navy = Color(0xFF1B1F3B);
  static const Color navyDark = Color(0xFF0E1027);
  static const Color orange = Color(0xFFFF5C35);
  static const Color orangeDark = Color(0xFFE5491F);

  static const Color surface = Color(0xFFF7F8FC);
  static const Color surfaceVariant = Color(0xFFEDEFF7);
  static const Color onSurface = Color(0xFF1B1F3B);
  static const Color onSurfaceVariant = Color(0xFF5B6075);
  static const Color outline = Color(0xFFD6DAE8);

  static const Color white = Color(0xFFFFFFFF);

  // ===============================================================
  // iOS ExampleSwift palette — the Playground home and Splash ONLY.
  // Separate from the navy+orange brand used everywhere else; the
  // native Android demo keeps the same split in its colors.xml.
  // ===============================================================
  static const Color iosCanvas = Color(0xFFEFEBE4);
  static const Color iosTextPrimary = Color(0xFF18181B);
  static const Color iosAccent = Color(0xFFF4482B);
  static const Color iosGradientRed = Color(0xFFE92E2F);
  static const Color iosGradientOrange = Color(0xFFFF6126);
  static const Color iosBorder = Color(0x1F18181B);

  // Per-mini-app accents, from the same colors.xml block.
  static const Color accentEcommerce = Color(0xFFFF5C35);
  static const Color accentInbox = Color(0xFFF59E0B);

  /// Secondary text on the navy-dark mini-apps sheet.
  static const Color onNavyVariant = Color(0xFFB9BED6);

  /// Hairline stroke on the navy-dark mini-app cards.
  static const Color navyCardOutline = Color(0x26FFFFFF);

  /// Chevron tint on the navy-dark mini-app cards.
  static const Color navyChevron = Color(0x80FFFFFF);
}

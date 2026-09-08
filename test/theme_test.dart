import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/theme/insider_colors.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

void main() {
  final ThemeData theme = InsiderTheme.light;

  test('the app speaks Kufam', () {
    expect(theme.textTheme.titleSmall?.fontWeight, FontWeight.w600);
    expect(theme.textTheme.titleSmall?.fontFamily, InsiderTheme.fontFamily);
    expect(theme.textTheme.bodyMedium?.fontFamily, InsiderTheme.fontFamily);
  });

  test('cards are white, 18dp, 1dp outlined and flat', () {
    expect(theme.cardTheme.color, InsiderColors.white);
    expect(theme.cardTheme.elevation, 0);

    final shape = theme.cardTheme.shape as RoundedRectangleBorder;
    expect(
      shape.borderRadius,
      BorderRadius.circular(InsiderTheme.cardRadius),
    );
    expect(shape.side.color, InsiderColors.outline);
    expect(shape.side.width, InsiderTheme.strokeWidth);
  });

  test('the colour scheme carries the insider_* tokens', () {
    expect(theme.colorScheme.primary, InsiderColors.navy);
    expect(theme.colorScheme.secondary, InsiderColors.orange);
    expect(theme.colorScheme.onSurface, InsiderColors.onSurface);
    expect(theme.colorScheme.onSurfaceVariant, InsiderColors.onSurfaceVariant);
    expect(theme.colorScheme.outline, InsiderColors.outline);
    expect(theme.scaffoldBackgroundColor, InsiderColors.surface);
  });

  test('inputs share the button corner radius and outline stroke', () {
    final border = theme.inputDecorationTheme.enabledBorder!
        as OutlineInputBorder;

    expect(
      border.borderRadius,
      BorderRadius.circular(InsiderTheme.controlRadius),
    );
    expect(border.borderSide.color, InsiderColors.outline);
    expect(border.borderSide.width, InsiderTheme.strokeWidth);
  });

  test('section headers use the Playground bold treatment', () {
    expect(theme.textTheme.headlineSmall?.fontSize, 20);
    expect(theme.textTheme.headlineSmall?.fontWeight, FontWeight.w700);
    expect(theme.textTheme.headlineSmall?.color, InsiderColors.iosTextPrimary);
  });

  test('the cream Playground palette stays separate from the brand', () {
    expect(InsiderColors.iosCanvas, const Color(0xFFEFEBE4));
    expect(InsiderColors.iosTextPrimary, const Color(0xFF18181B));
    expect(InsiderColors.iosGradientRed, const Color(0xFFE92E2F));
    expect(InsiderColors.iosGradientOrange, const Color(0xFFFF6126));
    expect(InsiderColors.iosBorder, const Color(0x1F18181B));

    // The two palettes must not collapse into each other.
    expect(InsiderColors.iosCanvas, isNot(InsiderColors.surface));
    expect(InsiderColors.iosAccent, isNot(InsiderColors.orange));
  });

  test('the divider matches the card stroke', () {
    expect(theme.dividerTheme.color, InsiderColors.outline);
    expect(theme.dividerTheme.thickness, InsiderTheme.strokeWidth);
  });
}

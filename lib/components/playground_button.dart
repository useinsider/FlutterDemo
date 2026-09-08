import 'package:flutter/material.dart';

import 'package:flutter_demo/theme/insider_colors.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

/// The Playground action button — `item_playground_button.xml` in the native
/// Android demo: a fixed-height pill filled with the red-to-orange gradient,
/// white semibold label, up to two centred lines.
class PlaygroundButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PlaygroundButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius =
        BorderRadius.circular(InsiderTheme.controlRadius);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Container(
        height: InsiderTheme.playgroundButtonHeight,
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: const LinearGradient(
            // angle="0" in the drawable means left to right.
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              InsiderColors.iosGradientRed,
              InsiderColors.iosGradientOrange,
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            splashColor: InsiderColors.navyCardOutline,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: InsiderTheme.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: InsiderColors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

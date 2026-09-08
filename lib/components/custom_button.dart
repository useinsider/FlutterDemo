import 'package:flutter/material.dart';

import 'package:flutter_demo/components/playground_button.dart';

/// The action button every demo section uses.
///
/// It delegates to [PlaygroundButton] so the whole Playground home picks up the
/// native demo's gradient treatment without any section having to change.
class CustomButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;

  /// Kept for callers that pass it; the Playground button carries the shared
  /// gradient, so a per-button colour is no longer applied.
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return PlaygroundButton(label: buttonText, onPressed: onPressed);
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_demo/components/playground_button.dart';

/// The action button every demo section uses.
///
/// It delegates to [PlaygroundButton] so the whole Playground home picks up the
/// native demo's gradient treatment without any section having to change. The
/// gradient is the only treatment there is: a per-button colour would not be
/// applied, so the parameter is not offered.
class CustomButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PlaygroundButton(label: buttonText, onPressed: onPressed);
  }
}

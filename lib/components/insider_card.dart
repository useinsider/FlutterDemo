import 'package:flutter/material.dart';

import 'package:flutter_demo/theme/insider_theme.dart';

/// The card surface shared by every screen: white, [InsiderTheme.cardRadius]
/// corners, a 1dp outline stroke and no shadow — the treatment
/// `item_app_frames_placement.xml` gives a placement card in the native Android
/// demo. Margins match that layout's 8dp horizontal / 6dp vertical insets.
class InsiderCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const InsiderCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Card(
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_demo/theme/insider_colors.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

/// The lines the Playground console shows.
///
/// The demo's SDK calls report through `print`, which only reaches a developer
/// with a console attached. The native demos surface the same output on screen,
/// so [logInsider] writes to both.
class PlaygroundLog extends ChangeNotifier {
  /// The native console keeps only the most recent lines so the card never
  /// grows unbounded; [maxLines] is the same cap on the Flutter side.
  static const int maxLines = 200;

  static final PlaygroundLog instance = PlaygroundLog._();

  PlaygroundLog._();

  final List<String> _lines = <String>[];

  List<String> get lines => List<String>.unmodifiable(_lines);

  String get text => _lines.join('\n');

  bool get isEmpty => _lines.isEmpty;

  void add(String line) {
    _lines.add(line);
    if (_lines.length > maxLines) {
      _lines.removeRange(0, _lines.length - maxLines);
    }
    notifyListeners();
  }

  void clear() {
    if (_lines.isEmpty) return;
    _lines.clear();
    notifyListeners();
  }
}

/// Reports [message] to the on-screen console and to the developer console.
void logInsider(String message) {
  PlaygroundLog.instance.add(message);
  // ignore: avoid_print
  print(message);
}

/// The Playground output card — the `printScroll` / `printLabel` pair in
/// `activity_playground.xml`: a fixed-height white card that scrolls internally
/// rather than growing down the screen.
class PlaygroundConsole extends StatefulWidget {
  const PlaygroundConsole({super.key});

  @override
  State<PlaygroundConsole> createState() => _PlaygroundConsoleState();
}

class _PlaygroundConsoleState extends State<PlaygroundConsole> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNewestLine() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: InsiderTheme.playgroundConsoleHeight,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: InsiderColors.white,
        borderRadius: BorderRadius.circular(InsiderTheme.controlRadius),
        border: Border.all(
          color: InsiderColors.iosBorder,
          width: InsiderTheme.strokeWidth,
        ),
      ),
      child: AnimatedBuilder(
        animation: PlaygroundLog.instance,
        builder: (BuildContext context, Widget? child) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToNewestLine());

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(14),
            child: SelectableText(
              PlaygroundLog.instance.text,
              style: const TextStyle(
                // 'monospace' only resolves on Android; iOS needs a real family
                // name or the console falls back to the proportional default.
                fontFamily: 'monospace',
                fontFamilyFallback: <String>['Menlo', 'Courier'],
                fontSize: 13,
                color: InsiderColors.iosTextPrimary,
              ),
            ),
          );
        },
      ),
    );
  }
}

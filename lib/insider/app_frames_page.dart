import 'package:flutter/material.dart';

import 'package:flutter_demo/components/insider_card.dart';
import 'package:flutter_demo/theme/insider_colors.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

/// The Flutter twin of the native Android demo's App Frames screen
/// (`activity_app_frames.xml` + `item_app_frames_placement.xml`). Element order
/// and labels are the ones in that layout's `app_frames_*` strings, so the two
/// demos read the same on both platforms.
///
/// The native screen's GDPR and mobile-access rows are deliberately absent: they
/// were test-only affordances, and partners are the ones who ship these
/// mini-apps. The Playground home still carries the consent controls.
///
/// The frame itself is a placeholder: flutter_insider exposes no App Frames API
/// — there is no Flutter counterpart to Android's `InsiderAppFramesView` — so
/// each placement card carries one in its place. See [_AppFramePlaceholder].
class AppFramesPage extends StatefulWidget {
  const AppFramesPage({super.key});

  @override
  State<AppFramesPage> createState() => _AppFramesPageState();
}

class _AppFramesPageState extends State<AppFramesPage> {
  final TextEditingController _placementController = TextEditingController();

  /// Registered placement ids, in the order they were added.
  final List<String> _placements = <String>[];

  /// Per-placement attach state and status label, keyed by placement id.
  final Map<String, bool> _attached = <String, bool>{};
  final Map<String, String> _status = <String, String>{};

  @override
  void dispose() {
    _placementController.dispose();
    super.dispose();
  }

  void _addPlacement() {
    final String placementId = _placementController.text.trim();
    if (placementId.isEmpty || _placements.contains(placementId)) {
      return;
    }

    setState(() {
      _placements.add(placementId);
      _attached[placementId] = true;
      _status[placementId] = 'Idle';
      _placementController.clear();
    });
  }

  void _deletePlacement(String placementId) {
    setState(() {
      _placements.remove(placementId);
      _attached.remove(placementId);
      _status.remove(placementId);
    });
  }

  void _toggleAttached(String placementId) {
    setState(() {
      final bool nowAttached = !(_attached[placementId] ?? false);
      _attached[placementId] = nowAttached;
      _status[placementId] = nowAttached ? 'Attached' : 'Detached';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Frames')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _placementController,
                decoration: const InputDecoration(hintText: 'e.g., home_page'),
                textInputAction: TextInputAction.done,
                maxLines: 1,
                onSubmitted: (_) => _addPlacement(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
              child: ElevatedButton(
                onPressed: _addPlacement,
                child: const Text('+ Add Placement'),
              ),
            ),

            for (final String placementId in _placements)
              _PlacementCard(
                placementId: placementId,
                attached: _attached[placementId] ?? false,
                status: _status[placementId] ?? 'Idle',
                onToggleAttached: () => _toggleAttached(placementId),
                onDelete: () => _deletePlacement(placementId),
              ),
          ],
        ),
      ),
    );
  }
}

/// One placement card — `item_app_frames_placement.xml`: a header row of the
/// placement label plus the attach and delete actions, the frame, a 1dp divider
/// and the placement's status chip.
class _PlacementCard extends StatelessWidget {
  final String placementId;
  final bool attached;
  final String status;
  final VoidCallback onToggleAttached;
  final VoidCallback onDelete;

  const _PlacementCard({
    required this.placementId,
    required this.attached,
    required this.status,
    required this.onToggleAttached,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InsiderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _MiddleEllipsisText(
                    text: 'Placement: $placementId',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                TextButton(
                  onPressed: onToggleAttached,
                  child: Text(attached ? 'Detach' : 'Attach'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    foregroundColor: InsiderColors.orange,
                  ),
                  icon: const Icon(Icons.delete_outline, size: 14),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ),
          const _AppFramePlaceholder(),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _StatusChip(label: status),
          ),
        ],
      ),
    );
  }
}

/// Stands in for the frame the native demos render here.
///
/// TODO(MOB-26643): replace with the real App Frames view once flutter_insider
/// exposes one — the plugin has no App Frames API today, so there is nothing to
/// attach a placement to on Flutter.
class _AppFramePlaceholder extends StatelessWidget {
  const _AppFramePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
      decoration: BoxDecoration(
        color: InsiderColors.surfaceVariant,
        borderRadius: BorderRadius.circular(InsiderTheme.controlRadius),
        border: Border.all(
          color: InsiderColors.outline,
          width: InsiderTheme.strokeWidth,
        ),
      ),
      child: Text(
        'App Frames view — not available on Flutter yet',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

/// The per-placement status chip: a 10dp dot plus a label, defaulting to `Idle`.
class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 16, 8),
        decoration: BoxDecoration(
          color: InsiderColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: InsiderColors.outline,
            width: InsiderTheme.strokeWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: InsiderColors.onSurfaceVariant,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 9),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: InsiderColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single-line text truncated in the MIDDLE, matching the Android label's
/// `android:ellipsize="middle"`. Flutter's [TextOverflow] has no middle mode, so
/// the string is measured against the available width and cut by hand.
class _MiddleEllipsisText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const _MiddleEllipsisText({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final TextStyle effectiveStyle =
            style ?? DefaultTextStyle.of(context).style;

        return Text(
          _truncate(text, effectiveStyle, constraints.maxWidth,
              MediaQuery.textScalerOf(context)),
          maxLines: 1,
          softWrap: false,
          style: effectiveStyle,
        );
      },
    );
  }

  static String _truncate(
    String value,
    TextStyle style,
    double maxWidth,
    TextScaler textScaler,
  ) {
    if (!maxWidth.isFinite || _fits(value, style, maxWidth, textScaler)) {
      return value;
    }

    // Shrink from the middle outwards until the ellipsized string fits.
    for (int dropped = 1; dropped < value.length; dropped++) {
      final int keptHead = (value.length - dropped + 1) ~/ 2;
      final int keptTail = value.length - dropped - keptHead;
      if (keptTail <= 0) break;

      final String candidate =
          '${value.substring(0, keptHead)}…${value.substring(value.length - keptTail)}';
      if (_fits(candidate, style, maxWidth, textScaler)) {
        return candidate;
      }
    }

    return '…';
  }

  static bool _fits(
    String value,
    TextStyle style,
    double maxWidth,
    TextScaler textScaler,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: value, style: style),
      maxLines: 1,
      textScaler: textScaler,
      textDirection: TextDirection.ltr,
    )..layout();

    final double width = painter.width;
    painter.dispose();

    return width <= maxWidth;
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_demo/insider/app_frames_page.dart';
import 'package:flutter_demo/insider/app_cards_page.dart';
import 'package:flutter_demo/theme/insider_colors.dart';

/// One row of the mini-apps sheet.
class MiniApp {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final WidgetBuilder builder;

  const MiniApp({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.builder,
  });

  /// The mini-apps FlutterDemo can actually open.
  ///
  /// The Android demo registers Shop, WebView and News here too, but those
  /// resolve to Activities FlutterDemo has no counterpart for — its own
  /// `SheetMiniApp.available()` skips entries whose target is unavailable, and
  /// this list follows the same rule.
  static const List<MiniApp> available = <MiniApp>[
    MiniApp(
      title: 'App Cards',
      subtitle: 'Inbox campaigns from the panel',
      icon: Icons.inbox_rounded,
      accent: InsiderColors.accentInbox,
      builder: _appCards,
    ),
    MiniApp(
      title: 'App Frames',
      subtitle: 'Placement-driven frames',
      icon: Icons.dashboard_customize_rounded,
      accent: InsiderColors.accentEcommerce,
      builder: _appFrames,
    ),
  ];

  static Widget _appCards(BuildContext context) => const AppCardsPage();

  static Widget _appFrames(BuildContext context) => const AppFramesPage();
}

/// The app-switcher bottom sheet the Playground home opens — `sheet_mini_apps`
/// in the native Android demo. Uses the navy brand, not the cream Playground
/// canvas, exactly as the Android sheet does.
class MiniAppsSheet extends StatelessWidget {
  const MiniAppsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => const MiniAppsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      decoration: const BoxDecoration(
        color: InsiderColors.navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 4, bottom: 10),
                decoration: BoxDecoration(
                  color: InsiderColors.navyChevron,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 4, 24, 4),
              child: Text(
                'Mini-apps',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: InsiderColors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                'Jump into another experience',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: InsiderColors.onNavyVariant,
                ),
              ),
            ),
            for (final MiniApp miniApp in MiniApp.available)
              _MiniAppCard(miniApp: miniApp),
          ],
        ),
      ),
    );
  }
}

/// One navy-dark mini-app card — `item_sheet_mini_app.xml`.
class _MiniAppCard extends StatelessWidget {
  final MiniApp miniApp;

  const _MiniAppCard({required this.miniApp});

  void _open(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(MaterialPageRoute<void>(builder: miniApp.builder));
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(20);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        color: InsiderColors.navyDark,
        borderRadius: radius,
        child: InkWell(
          onTap: () => _open(context),
          borderRadius: radius,
          splashColor: InsiderColors.navyCardOutline,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: InsiderColors.navyCardOutline),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: miniApp.accent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    miniApp.icon,
                    size: 26,
                    color: InsiderColors.white,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          miniApp.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: InsiderColors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            miniApp.subtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: InsiderColors.onNavyVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: InsiderColors.navyChevron,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

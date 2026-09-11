import 'package:flutter/material.dart';

import 'package:flutter_demo/components/custom_title.dart';
import 'package:flutter_demo/components/mini_apps_sheet.dart';
import 'package:flutter_demo/components/playground_console.dart';

import 'package:flutter_demo/insider/event.dart';
import 'package:flutter_demo/insider/gdpr.dart';
import 'package:flutter_demo/insider/page_visit.dart';
import 'package:flutter_demo/insider/product.dart';
import 'package:flutter_demo/insider/purchase.dart';
import 'package:flutter_demo/insider/smart_recommender.dart';
import 'package:flutter_demo/insider/user_attribute.dart';
import 'package:flutter_demo/insider/user_identifier.dart';
import 'package:flutter_demo/insider/app_cards.dart';
import 'package:flutter_demo/insider/content_optimizer.dart';
import 'package:flutter_demo/insider/geofence.dart';
import 'package:flutter_demo/insider/in_app_messages.dart';
import 'package:flutter_demo/insider/wishlist.dart';

import 'package:flutter_demo/firebase/insider_push_bridge.dart';

import 'package:flutter_demo/theme/insider_colors.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/enum/InsiderCallbackAction.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebaseMessaging();
  runApp(const InsiderDemo());
}

class InsiderDemo extends StatelessWidget {
  const InsiderDemo({super.key});

  Future initInsider() async {
    // FIXME-INSIDER: Please change with your partner name and app group.
    await FlutterInsider.Instance.init(
        "your_partner_name", "group.com.useinsider.mobile-ios",
        (int type, dynamic data) {
      switch (type) {
        case InsiderCallbackAction.NOTIFICATION_OPEN:
          logInsider('[INSIDER][NOTIFICATION_OPEN]: $data');
          break;
        case InsiderCallbackAction.TEMP_STORE_CUSTOM_ACTION:
          logInsider('[INSIDER][TEMP_STORE_CUSTOM_ACTION]: $data');
          break;
        default:
          logInsider('[INSIDER][InsiderCallbackAction]: Unregistered Action!');
          break;
      }
    });

    // This is an utility method, if you want to handle the push permission in iOS own your own you can omit the following method.
    FlutterInsider.Instance.setActiveForegroundPushView();
    FlutterInsider.Instance.registerWithQuietPermission(false);
    logFcmToken();
    FlutterInsider.Instance.enableIDFACollection(true);
    FlutterInsider.Instance.enableIpCollection(true);
    FlutterInsider.Instance.enableCarrierCollection(true);
    FlutterInsider.Instance.enableLocationCollection(true);
    FlutterInsider.Instance.startTrackingGeofence();
  }

  @override
  Widget build(BuildContext context) {
    initInsider();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: InsiderTheme.light,
      home: const HomePage(title: '[Flutter] Insider SDK Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // The Playground home in the native demos runs on the cream iOS canvas,
    // not the navy brand: a slim logo bar, a fixed output console, then the
    // action sections, with the mini-apps switcher floating over them.
    return Scaffold(
      backgroundColor: InsiderColors.iosCanvas,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => MiniAppsSheet.show(context),
        backgroundColor: InsiderColors.navy,
        foregroundColor: InsiderColors.white,
        icon: const Icon(Icons.apps),
        label: const Text('Apps'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _PlaygroundTopBar(),
            const PlaygroundConsole(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 88),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CustomTitle(title: 'User Attributes'),
                    UserAttribute(),
                    CustomTitle(title: 'User Identifiers'),
                    UserIdentifier(),
                    CustomTitle(title: 'Event'),
                    Event(),
                    CustomTitle(title: 'Product'),
                    Product(),
                    CustomTitle(title: 'Purchase'),
                    Purchase(),
                    CustomTitle(title: 'Smart Recommender'),
                    SmartRecommender(),
                    CustomTitle(title: 'Page Visit Methods'),
                    PageVisit(),
                    CustomTitle(title: 'GDPR'),
                    GDPR(),
                    CustomTitle(title: 'App Cards'),
                    AppCards(),
                    CustomTitle(title: 'Content Optimizer'),
                    ContentOptimizer(),
                    CustomTitle(title: 'Geofence'),
                    Geofence(),
                    CustomTitle(title: 'In-App Messages'),
                    InAppMessages(),
                    CustomTitle(title: 'Wishlist'),
                    Wishlist(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The slim transparent bar over the cream canvas: the Insider mark centred,
/// a round clear button on the trailing edge — `playgroundTopBar`.
class _PlaygroundTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset('assets/images/insider-one.png', height: 26),
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: InsiderColors.white,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: PlaygroundLog.instance.clear,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.clear,
                    size: 20,
                    color: InsiderColors.iosTextPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

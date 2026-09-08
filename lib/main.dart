import 'package:flutter/material.dart';

import 'package:flutter_demo/components/custom_title.dart';

import 'package:flutter_demo/insider/event.dart';
import 'package:flutter_demo/insider/gdpr.dart';
import 'package:flutter_demo/insider/message_center.dart';
import 'package:flutter_demo/insider/page_visit.dart';
import 'package:flutter_demo/insider/product.dart';
import 'package:flutter_demo/insider/purchase.dart';
import 'package:flutter_demo/insider/smart_recommender.dart';
import 'package:flutter_demo/insider/user_attribute.dart';
import 'package:flutter_demo/insider/user_identifier.dart';
import 'package:flutter_demo/insider/content_optimizer.dart';
import 'package:flutter_demo/insider/geofence.dart';
import 'package:flutter_demo/insider/in_app_messages.dart';
import 'package:flutter_demo/insider/wishlist.dart';

import 'package:flutter_demo/firebase/insider_push_bridge.dart';

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
          print('[INSIDER][NOTIFICATION_OPEN]: $data');
          break;
        case InsiderCallbackAction.TEMP_STORE_CUSTOM_ACTION:
          print('[INSIDER][TEMP_STORE_CUSTOM_ACTION]: $data');
          break;
        default:
          print("[INSIDER][InsiderCallbackAction]: Unregistered Action!");
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

    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(title: '[Flutter] Insider SDK Demo'),
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/images/insider-one.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 150,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const <Widget>[
                        Text(
                          '[Flutter] Insider SDK Demo',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'This Demo contains simple methods that you can use with the Insider SDK.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
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
                  MessageCenter(),
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
            ],
          ),
        ),
      ),
    );
  }
}

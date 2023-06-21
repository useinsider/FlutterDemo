import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_demo/components/CustomTitle.dart';

import 'package:flutter_demo/insider/Event.dart';
import 'package:flutter_demo/insider/GDPR.dart';
import 'package:flutter_demo/insider/MessageCenter.dart';
import 'package:flutter_demo/insider/PageVisit.dart';
import 'package:flutter_demo/insider/Product.dart';
import 'package:flutter_demo/insider/Purchase.dart';
import 'package:flutter_demo/insider/SmartRecommender.dart';
import 'package:flutter_demo/insider/SocialProof.dart';
import 'package:flutter_demo/insider/UserAttribute.dart';
import 'package:flutter_demo/insider/UserIdentifier.dart';
import 'package:flutter_demo/insider/ContentOptimizer.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/enum/InsiderCallbackAction.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (message.data['source'] == 'Insider') {
    // In this step, you should forward the push data to the Insider SDK.
    FlutterInsider.Instance.handleNotification(
        <String, dynamic> {
          "data": message.data
        }
    );
  }

  print('[FCM][onBackgroundMessage]: ${message.data}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const InsiderDemo());
}

String getCurrentLocale() {
  String languageCode = window.locale.languageCode;

  return languageCode;
}

String getInsiderPanelName() {
  String languageCode = getCurrentLocale();

  print('[INSIDER][currentLanguage]: $languageCode');

  // Ex: samsungappseguat , samsungappsegprod, samsungappsebnuat, samsungappsebnprod, etc.
  switch (languageCode) {
    case 'tr':
      return 'partner_name_1';
    case 'en':
      return 'partner_name_2';
    default:
      return 'partner_name_default';
  }
}

Future initInsider() async {
  /* NOTE: Dynamically set the partner name here according to your application structure.
   * In this demo, the partner name is handled depending on the device language.
   */
  String panelName = getInsiderPanelName();

  // FIXME-INSIDER: Please change with your partner name and app group.
  await FlutterInsider.Instance.init(
      panelName, "group.com.useinsider.FlutterDemo",
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
  FlutterInsider.Instance.enableIDFACollection(true);
  FlutterInsider.Instance.enableIpCollection(true);
  FlutterInsider.Instance.enableCarrierCollection(true);
  FlutterInsider.Instance.enableLocationCollection(true);
  FlutterInsider.Instance.startTrackingGeofence();
}

Future initFirebase() async {
  FirebaseMessaging.instance.getToken().then((token) {
    print('[FCM][Token]: $token');
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.data['source'] == 'Insider') {
      // In this step, you should forward the push data to the Insider SDK.
      FlutterInsider.Instance.handleNotification(
          <String, dynamic> {
            "data": message.data
          }
      );
    }

    print('[FCM][onMessage]: ${message.data}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('[FCM][onMessageOpenedApp]: ${message.data}');
  });
}

class InsiderDemo extends StatelessWidget {
  const InsiderDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(title: '[Flutter] Insider SDK Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    initInsider();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/insider-logo.png',
              fit: BoxFit.none,
              width: double.infinity,
              height: 200,
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
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                        ),
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
                CustomTitle(title: 'Social Proof'),
                SocialProof(),
                CustomTitle(title: 'Page Visit Methods'),
                PageVisit(),
                CustomTitle(title: 'GDPR'),
                GDPR(),
                CustomTitle(title: 'Message Center'),
                MessageCenter(),
                CustomTitle(title: 'Content Optimizer'),
                ContentOptimizer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


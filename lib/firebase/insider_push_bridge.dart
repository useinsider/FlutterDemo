import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_insider/flutter_insider.dart';

import '../firebase_options.dart';

/// Routes Firebase Cloud Messaging traffic so that Insider pushes reach the
/// Insider SDK and every other message stays with the app.
///
/// The Insider native SDKs register their own messaging handlers; this bridge
/// covers the case where `firebase_messaging` receives the message first.

bool _isInsiderMessage(RemoteMessage message) =>
    message.data['source'] == 'Insider';

/// Runs in its own isolate when a message arrives while the app is in the
/// background or terminated, so Firebase has to be initialized again here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await routeMessage(message, origin: 'background');
}

Future<void> routeMessage(RemoteMessage message,
    {required String origin}) async {
  if (_isInsiderMessage(message)) {
    await FlutterInsider.Instance
        .handleNotification(<String, dynamic>{'data': message.data});
    return;
  }
  print('[FCM][$origin]: ${message.data}');
}

/// Initializes Firebase and wires the message listeners.
///
/// Returns `false` when Firebase is not configured yet (the placeholder
/// `firebase_options.dart` is still in place); the app then runs with the
/// Insider SDK alone.
bool _listening = false;

Future<bool> initFirebaseMessaging() async {
  final options = DefaultFirebaseOptions.currentPlatform;
  // Firebase raises a native exception on empty options; Dart cannot catch it.
  if (options.appId.isEmpty || options.apiKey.isEmpty) {
    print('[FCM] Firebase not configured, run flutterfire configure');
    return false;
  }
  try {
    await Firebase.initializeApp(options: options);
  } catch (error) {
    print('[FCM] Firebase initialization failed: $error');
    return false;
  }
  if (_listening) return true;
  _listening = true;

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage
      .listen((message) => routeMessage(message, origin: 'foreground'));
  FirebaseMessaging.onMessageOpenedApp
      .listen((message) => print('[FCM][opened]: ${message.data}'));
  return true;
}

Future<void> logFcmToken() async {
  if (Firebase.apps.isEmpty) return;
  final token = await FirebaseMessaging.instance.getToken();
  print('[FCM][token]: $token');
}

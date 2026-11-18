import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers the platform-views system channel so `InsiderAppFramesView` believes
/// a native view was created and opens its per-view method channel.
class FakePlatformViews {
  final List<int> _createdViewIds = <int>[];
  int _nextTextureId = 1;

  /// The platform view ids created so far, oldest first.
  List<int> get createdViewIds => List<int>.unmodifiable(_createdViewIds);

  /// Installs the fake and tears it down again when the test ends.
  void install() {
    final TestDefaultBinaryMessenger messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    messenger.setMockMethodCallHandler(SystemChannels.platform_views,
        (MethodCall call) async {
      if (call.method == 'create') {
        _createdViewIds
            .add((call.arguments as Map<dynamic, dynamic>)['id'] as int);
        return _nextTextureId++;
      }
      return null;
    });

    addTearDown(() => messenger.setMockMethodCallHandler(
        SystemChannels.platform_views, null));
  }
}

/// Sends a native -> Dart call on an App Frames view's channel, the way the
/// Android and iOS bridges do.
Future<void> emitAppFramesCall(
  int viewId,
  String method, [
  Object? arguments,
]) {
  return TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .handlePlatformMessage(
    'flutter_insider_app_frames_$viewId',
    const StandardMethodCodec().encodeMethodCall(MethodCall(method, arguments)),
    (_) {},
  );
}

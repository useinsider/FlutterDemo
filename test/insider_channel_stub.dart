import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers the `flutter_insider` platform channel in widget tests.
///
/// The screens under test call into the SDK (consent toggles, campaign fetches),
/// and without a stub every one of those calls throws
/// `MissingPluginException` because no native side is attached to the test
/// binding. Returns the calls it received so a test can assert on them.
class InsiderChannelStub {
  static const MethodChannel _channel = MethodChannel('flutter_insider');

  final List<MethodCall> calls = <MethodCall>[];

  /// Installs the stub and tears it down again when the test ends.
  void install() {
    final TestDefaultBinaryMessenger messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    messenger.setMockMethodCallHandler(_channel, (MethodCall call) async {
      calls.add(call);
      return null;
    });

    addTearDown(() => messenger.setMockMethodCallHandler(_channel, null));
  }

  /// The method names recorded so far, in call order.
  List<String> get methods =>
      calls.map((MethodCall call) => call.method).toList();
}

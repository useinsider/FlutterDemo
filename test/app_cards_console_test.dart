import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/components/playground_console.dart';
import 'package:flutter_demo/insider/app_cards_page.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

import 'insider_channel_stub.dart';

void main() {
  // Regression: App Cards used to call loadAppCards() straight from initState.
  // Its first log ran before the first await, so logInsider notified the
  // console's AnimatedBuilder inside the build phase and the framework reported
  // "markNeedsBuild() called during build" every time the screen was opened.
  testWidgets('opening App Cards does not log during the build phase',
      (WidgetTester tester) async {
    final InsiderChannelStub insider = InsiderChannelStub()..install();
    insider.responses['getAppCardsCampaigns'] = <String, dynamic>{
      'items': <Map<String, dynamic>>[],
    };

    // A console mounted and settled in an earlier frame, exactly like the
    // Playground home the mini-apps sheet opens App Cards from.
    await tester.pumpWidget(MaterialApp(
      theme: InsiderTheme.light,
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) => Column(
            children: <Widget>[
              const Expanded(child: PlaygroundConsole()),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AppCardsPage(),
                  ),
                ),
                child: const Text('open'),
              ),
            ],
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(
      tester.takeException(),
      isNull,
      reason: 'opening App Cards must not report a framework error',
    );
  });
}

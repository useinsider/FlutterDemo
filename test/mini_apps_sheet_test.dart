import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/components/mini_apps_sheet.dart';
import 'package:flutter_demo/insider/app_frames_page.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

import 'insider_channel_stub.dart';

void main() {
  setUp(() {
    InsiderChannelStub().install();
  });

  Future<void> openSheet(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: InsiderTheme.light,
      home: Builder(
        builder: (BuildContext context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => MiniAppsSheet.show(context),
              child: const Text('Apps'),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Apps'));
    await tester.pumpAndSettle();
  }

  testWidgets('lists the mini-apps FlutterDemo can open',
      (WidgetTester tester) async {
    await openSheet(tester);

    expect(find.text('Mini-apps'), findsOneWidget);
    expect(find.text('Jump into another experience'), findsOneWidget);

    expect(find.text('App Cards'), findsOneWidget);
    expect(find.text('Inbox campaigns from the panel'), findsOneWidget);
    expect(find.text('App Frames'), findsOneWidget);
    expect(find.text('Placement-driven frames'), findsOneWidget);
  });

  testWidgets('does not offer mini-apps FlutterDemo has no screen for',
      (WidgetTester tester) async {
    await openSheet(tester);

    // The Android sheet also registers these; FlutterDemo has no counterpart.
    expect(find.text('Shop'), findsNothing);
    expect(find.text('News'), findsNothing);
    expect(find.text('WebView'), findsNothing);
  });

  testWidgets('tapping a mini-app dismisses the sheet and opens its screen',
      (WidgetTester tester) async {
    await openSheet(tester);

    await tester.tap(find.text('App Frames'));
    await tester.pumpAndSettle();

    expect(find.byType(AppFramesPage), findsOneWidget);
    expect(find.text('Mini-apps'), findsNothing);
  });
}

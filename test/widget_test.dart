import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/components/playground_console.dart';
import 'package:flutter_demo/insider/app_frames_page.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/theme/insider_colors.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

import 'insider_channel_stub.dart';

void main() {
  setUp(() {
    InsiderChannelStub().install();
    PlaygroundLog.instance.clear();
  });

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: InsiderTheme.light,
      home: const HomePage(title: '[Flutter] Insider SDK Demo'),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('the home page wears the Playground cream canvas',
      (WidgetTester tester) async {
    await pumpHome(tester);

    final Scaffold scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, InsiderColors.iosCanvas);

    expect(find.byType(PlaygroundConsole), findsOneWidget);
    expect(find.text('Apps'), findsOneWidget);
  });

  testWidgets('the console shows what the SDK reports',
      (WidgetTester tester) async {
    await pumpHome(tester);

    logInsider('[INSIDER] a line');
    await tester.pumpAndSettle();

    expect(find.textContaining('[INSIDER] a line'), findsOneWidget);
  });

  testWidgets('the clear button empties the console',
      (WidgetTester tester) async {
    await pumpHome(tester);

    logInsider('[INSIDER] a line');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    expect(find.textContaining('[INSIDER] a line'), findsNothing);
  });

  testWidgets('App Frames is reached through the mini-apps sheet',
      (WidgetTester tester) async {
    await pumpHome(tester);

    // It is no longer a section on the home list.
    expect(find.text('Open App Frames'), findsNothing);

    await tester.tap(find.text('Apps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('App Frames'));
    await tester.pumpAndSettle();

    expect(find.byType(AppFramesPage), findsOneWidget);
  });
}

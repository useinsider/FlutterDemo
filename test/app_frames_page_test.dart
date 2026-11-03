import 'package:flutter/material.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/insider/app_frames_page.dart';
import 'package:flutter_demo/theme/insider_colors.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

import 'app_frames_test_harness.dart';
import 'insider_channel_stub.dart';

void main() {
  // The page itself makes no SDK calls any more, but the stub stays installed so
  // any that creep back in fail here instead of reaching a real channel.
  late FakePlatformViews platformViews;

  setUp(() {
    InsiderChannelStub().install();
    platformViews = FakePlatformViews()..install();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: InsiderTheme.light,
      home: const AppFramesPage(),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> addPlacement(WidgetTester tester, String placementId) async {
    await tester.enterText(find.byType(TextField), placementId);
    await tester.tap(find.text('+ Add Placement'));
    await tester.pumpAndSettle();
  }

  Finder chipOf(String placementId, String label) => find.descendant(
        of: find.ancestor(
          of: find.text('Placement: $placementId'),
          matching: find.byType(Card),
        ),
        matching: find.text(label),
      );

  Future<void> emitStatus(
    WidgetTester tester,
    int viewId,
    String status, [
    String previousStatus = 'detached',
  ]) async {
    await emitAppFramesCall(viewId, 'onStatusChanged', <String, Object?>{
      'status': status,
      'previousStatus': previousStatus,
    });
    await tester.pump();
  }

  Future<void> emitLoadFailed(
    WidgetTester tester,
    int viewId,
    String code,
    String message,
  ) async {
    await emitAppFramesCall(viewId, 'onLoadFailed', <String, Object?>{
      'code': code,
      'message': message,
    });
    await tester.pump();
  }

  group('AppFramesPage layout', () {
    testWidgets('shows the controls the Android screen shows, in order',
        (WidgetTester tester) async {
      await pumpPage(tester);

      expect(find.text('e.g., home_page'), findsOneWidget);
      expect(find.text('+ Add Placement'), findsOneWidget);

      // The consent controls belong to the Playground home, not here: partners
      // ship these mini-apps, so the screen carries no SDK-wide toggles.
      expect(find.textContaining('GDPR'), findsNothing);
      expect(find.textContaining('MOBILE ACCESS'), findsNothing);
    });

    testWidgets('starts with no placement cards', (WidgetTester tester) async {
      await pumpPage(tester);

      expect(find.byType(Card), findsNothing);
    });
  });

  group('placement lifecycle', () {
    testWidgets('adding a placement renders a card defaulting to Idle',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');

      expect(find.text('Placement: home_page'), findsOneWidget);
      expect(find.text('Idle'), findsOneWidget);
      expect(find.text('Detach'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('an empty placement id adds nothing',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, '   ');

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('the same placement id is not added twice',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      await addPlacement(tester, 'home_page');

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('detach removes the frame and attach mounts a fresh one',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');

      await tester.tap(find.text('Detach'));
      await tester.pumpAndSettle();

      expect(find.text('Attach'), findsOneWidget);
      expect(find.text('Detached'), findsOneWidget);
      expect(find.byType(InsiderAppFramesView), findsNothing);

      await tester.tap(find.text('Attach'));
      await tester.pumpAndSettle();

      expect(find.text('Detach'), findsOneWidget);
      expect(find.text('Attached'), findsOneWidget);
      expect(find.byType(InsiderAppFramesView), findsOneWidget);
      expect(platformViews.createdViewIds.length, 2);
    });

    testWidgets('re-attach creates a new platform view',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      await tester.tap(find.text('Detach'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Attach'));
      await tester.pumpAndSettle();

      final int oldViewId = platformViews.createdViewIds.first;
      final int newViewId = platformViews.createdViewIds.last;

      await emitStatus(tester, oldViewId, 'ready');
      expect(chipOf('home_page', 'Attached'), findsOneWidget);

      await emitStatus(tester, newViewId, 'ready');
      expect(chipOf('home_page', 'ready'), findsOneWidget);
    });

    testWidgets('delete removes only its own card',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      await addPlacement(tester, 'basket_page');

      expect(find.byType(Card), findsNWidgets(2));

      await tester.tap(find.text('Delete').first);
      await tester.pumpAndSettle();

      expect(find.text('Placement: home_page'), findsNothing);
      expect(find.text('Placement: basket_page'), findsOneWidget);
    });

    testWidgets('the delete action is tinted orange',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');

      final Icon trashIcon = tester.widget<Icon>(
        find.byIcon(Icons.delete_outline),
      );
      expect(trashIcon.size, 14);

      // bySubtype, not byType: older Flutter versions build TextButton.icon as a
      // private TextButton subclass, which an exact-type finder never matches.
      final TextButton deleteButton = tester.widget<TextButton>(
        find.ancestor(
          of: find.text('Delete'),
          matching: find.bySubtype<TextButton>(),
        ),
      );
      expect(
        deleteButton.style?.foregroundColor?.resolve(<WidgetState>{}),
        InsiderColors.orange,
      );
    });
  });

  group('App Frames view', () {
    testWidgets('each card hosts an InsiderAppFramesView for its placement id',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');

      expect(find.byType(InsiderAppFramesView), findsOneWidget);
      expect(
        tester
            .widget<InsiderAppFramesView>(find.byType(InsiderAppFramesView))
            .placementId,
        'home_page',
      );
    });

    testWidgets('no placeholder text remains', (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');

      expect(find.textContaining('not available on Flutter'), findsNothing);
    });

    testWidgets('status chip follows onStatusChanged',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      final int viewId = platformViews.createdViewIds.single;

      await emitStatus(tester, viewId, 'resolving');
      expect(chipOf('home_page', 'resolving'), findsOneWidget);

      await emitStatus(tester, viewId, 'ready', 'rendering');
      expect(chipOf('home_page', 'ready'), findsOneWidget);
    });

    testWidgets('load failure shows the error in the chip',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      final int viewId = platformViews.createdViewIds.single;

      await emitLoadFailed(tester, viewId, 'resolutionFailed', 'boom');

      expect(chipOf('home_page', 'resolutionFailed: boom'), findsOneWidget);
      expect(find.text('Idle'), findsNothing);
    });

    testWidgets('error survives a following error status',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      final int viewId = platformViews.createdViewIds.single;

      await emitLoadFailed(tester, viewId, 'resolutionFailed', 'boom');
      await emitStatus(tester, viewId, 'errorResolving', 'resolving');

      expect(chipOf('home_page', 'resolutionFailed: boom'), findsOneWidget);
    });

    testWidgets('error survives when the error status arrives first',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      final int viewId = platformViews.createdViewIds.single;

      await emitStatus(tester, viewId, 'errorResolving', 'resolving');
      await emitLoadFailed(tester, viewId, 'resolutionFailed', 'boom');

      expect(chipOf('home_page', 'resolutionFailed: boom'), findsOneWidget);
    });

    testWidgets('error text cleared by the next loading status',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      final int viewId = platformViews.createdViewIds.single;

      await emitLoadFailed(tester, viewId, 'resolutionFailed', 'boom');
      await emitStatus(tester, viewId, 'resolving', 'errorResolving');

      expect(chipOf('home_page', 'resolving'), findsOneWidget);
    });

    testWidgets('disabled status is shown verbatim',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      final int viewId = platformViews.createdViewIds.single;

      await emitStatus(tester, viewId, 'disabled');

      expect(chipOf('home_page', 'disabled'), findsOneWidget);
    });

    testWidgets('status updates only its own card',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'a');
      await addPlacement(tester, 'b');
      final int viewIdA = platformViews.createdViewIds.first;

      await emitStatus(tester, viewIdA, 'ready');

      expect(chipOf('a', 'ready'), findsOneWidget);
      expect(chipOf('b', 'Idle'), findsOneWidget);
    });

    testWidgets('deleting a card keeps the next card\'s frame alive',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'a');
      await addPlacement(tester, 'b');
      final int viewIdB = platformViews.createdViewIds.last;

      await tester.tap(find.text('Delete').first);
      await tester.pumpAndSettle();

      expect(platformViews.createdViewIds.length, 2);
      await emitStatus(tester, viewIdB, 'ready');
      expect(chipOf('b', 'ready'), findsOneWidget);
    });

    testWidgets('events after delete are ignored', (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');
      final int viewId = platformViews.createdViewIds.single;

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await emitStatus(tester, viewId, 'ready');

      expect(tester.takeException(), isNull);
      expect(find.byType(Card), findsNothing);
    });
  });
}

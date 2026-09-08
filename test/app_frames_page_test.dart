import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/insider/app_frames_page.dart';
import 'package:flutter_demo/theme/insider_colors.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

import 'insider_channel_stub.dart';

void main() {
  late InsiderChannelStub insider;

  setUp(() {
    insider = InsiderChannelStub()..install();
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

  group('AppFramesPage layout', () {
    testWidgets('shows the controls the Android screen shows, in order',
        (WidgetTester tester) async {
      await pumpPage(tester);

      expect(find.text('e.g., home_page'), findsOneWidget);
      expect(find.text('+ Add Placement'), findsOneWidget);
      expect(find.text('GDPR ON'), findsOneWidget);
      expect(find.text('GDPR OFF'), findsOneWidget);
      expect(find.text('MOBILE ACCESS ON'), findsOneWidget);
      expect(find.text('MOBILE ACCESS OFF'), findsOneWidget);
      expect(
        find.text('Last set here — GDPR: ON  ·  Mobile access: ON'),
        findsOneWidget,
      );

      // The consent line sits below both button rows, above the placement cards.
      final double gdprRowY = tester.getTopLeft(find.text('GDPR ON')).dy;
      final double accessRowY =
          tester.getTopLeft(find.text('MOBILE ACCESS ON')).dy;
      final double consentY = tester
          .getTopLeft(find.textContaining('Last set here — GDPR:'))
          .dy;

      expect(gdprRowY, lessThan(accessRowY));
      expect(accessRowY, lessThan(consentY));
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

    testWidgets('the attach action toggles its label and the status',
        (WidgetTester tester) async {
      await pumpPage(tester);
      await addPlacement(tester, 'home_page');

      await tester.tap(find.text('Detach'));
      await tester.pumpAndSettle();

      expect(find.text('Attach'), findsOneWidget);
      expect(find.text('Detached'), findsOneWidget);

      await tester.tap(find.text('Attach'));
      await tester.pumpAndSettle();

      expect(find.text('Detach'), findsOneWidget);
      expect(find.text('Attached'), findsOneWidget);
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

      final TextButton deleteButton = tester.widget<TextButton>(
        find.ancestor(
          of: find.text('Delete'),
          matching: find.byType(TextButton),
        ),
      );
      expect(
        deleteButton.style?.foregroundColor?.resolve(<WidgetState>{}),
        InsiderColors.orange,
      );
    });
  });

  group('consent controls', () {
    testWidgets('GDPR buttons reach the SDK and update the consent line',
        (WidgetTester tester) async {
      await pumpPage(tester);

      await tester.tap(find.text('GDPR OFF'));
      await tester.pumpAndSettle();

      expect(insider.methods, contains('setGDPRConsent'));
      expect(insider.calls.last.arguments['consent'], false);
      expect(
        find.text('Last set here — GDPR: OFF  ·  Mobile access: ON'),
        findsOneWidget,
      );
    });

    testWidgets('mobile access buttons reach the SDK and update the line',
        (WidgetTester tester) async {
      await pumpPage(tester);

      await tester.tap(find.text('MOBILE ACCESS OFF'));
      await tester.pumpAndSettle();

      expect(insider.methods, contains('setMobileAppAccess'));
      expect(insider.calls.last.arguments['mobileAppAccess'], false);
      expect(
        find.text('Last set here — GDPR: ON  ·  Mobile access: OFF'),
        findsOneWidget,
      );
    });
  });
}

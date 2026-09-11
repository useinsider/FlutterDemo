import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/insider/app_cards_page.dart';
import 'package:flutter_demo/theme/insider_colors.dart';
import 'package:flutter_demo/theme/insider_theme.dart';

import 'insider_channel_stub.dart';

void main() {
  late InsiderChannelStub insider;

  setUp(() {
    insider = InsiderChannelStub()..install();
    insider.responses['getAppCardsCampaigns'] = <String, dynamic>{
      'items': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'card-1',
          'type': 'message',
          'read': false,
          'content': <String, dynamic>{
            'title': 'Welcome back',
            'description': 'A campaign from the panel',
          },
        },
      ],
    };
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: InsiderTheme.light,
      home: const AppCardsPage(),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('renders a campaign as a card', (WidgetTester tester) async {
    await pumpPage(tester);

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('the campaign card takes its surface from the theme',
      (WidgetTester tester) async {
    await pumpPage(tester);

    final Card card = tester.widget<Card>(find.byType(Card).first);

    // No per-card overrides: cardTheme owns colour, shape and elevation, so
    // every surface in the app stays white / 18dp / 1dp outline / flat.
    expect(card.elevation, isNull);
    expect(card.shape, isNull);
    expect(card.color, isNull);

    final ThemeData theme = Theme.of(tester.element(find.byType(Card).first));
    final RoundedRectangleBorder shape =
        theme.cardTheme.shape! as RoundedRectangleBorder;
    expect(theme.cardTheme.elevation, 0);
    expect(shape.borderRadius, BorderRadius.circular(InsiderTheme.cardRadius));
    expect(shape.side.color, InsiderColors.outline);
  });
}

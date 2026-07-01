import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';
import 'package:flutter_demo/insider/MessageCenterInboxPage.dart';

import 'package:flutter_insider/flutter_insider.dart';

class MessageCenter extends StatelessWidget {
  MessageCenter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(
                buttonText: 'Open App Cards',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppCardsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Get Campaigns Data (Console)', onPressed: () async {
                print('[INSIDER][getCampaigns]: Method is triggered, waiting response...');

                try {
                  final response = await FlutterInsider.Instance.appCards.getCampaigns();

                  if (response != null) {
                    print('[INSIDER][getCampaigns]: Received ${response.appCards.length} app cards');
                    for (var card in response.appCards) {
                      print('  - Card ID: ${card.id}');
                      print('    Title: ${card.content?.title ?? "N/A"}');
                      print('    Description: ${card.content?.description ?? "N/A"}');
                      print('    Read: ${card.isRead}');
                      print('    Images: ${card.images?.length ?? 0}');
                      print('    Buttons: ${card.buttons?.length ?? 0}');
                    }
                  } else {
                    print('[INSIDER][getCampaigns]: No campaigns data received');
                  }
                } catch (e) {
                  print('[INSIDER][getCampaigns]: Error: $e');
                }
              }),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_demo/components/custom_button.dart';
import 'package:flutter_demo/components/playground_console.dart';

import 'package:flutter_insider/flutter_insider.dart';

/// The App Cards playground action.
///
/// Opening the App Cards screen itself moved to the mini-apps sheet, matching
/// the native demos; the campaign dump stays here because it is a console
/// action, not a screen.
class AppCards extends StatelessWidget {
  const AppCards({super.key});

  Future<void> _dumpCampaigns() async {
    logInsider('[INSIDER][getCampaigns]: Method is triggered, waiting response...');

    try {
      final response = await FlutterInsider.Instance.appCards.getCampaigns();

      if (response == null) {
        logInsider('[INSIDER][getCampaigns]: No campaigns data received');
        return;
      }

      logInsider(
          '[INSIDER][getCampaigns]: Received ${response.appCards.length} app cards');
      for (final card in response.appCards) {
        logInsider('  - Card ID: ${card.id}');
        logInsider('    Title: ${card.content?.title ?? "N/A"}');
        logInsider('    Description: ${card.content?.description ?? "N/A"}');
        logInsider('    Read: ${card.isRead}');
        logInsider('    Images: ${card.images?.length ?? 0}');
        logInsider('    Buttons: ${card.buttons?.length ?? 0}');
      }
    } catch (e) {
      logInsider('[INSIDER][getCampaigns]: Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Same 90% width the other single-action sections use, so the button lines
    // up with them instead of running the full width of the list.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: CustomButton(
            buttonText: 'Get Campaigns Data (Console)',
            onPressed: _dumpCampaigns,
          ),
        ),
      ],
    );
  }
}

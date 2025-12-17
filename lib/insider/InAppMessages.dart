import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';

class InAppMessages extends StatelessWidget {
  InAppMessages();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Enable InApp',
                  onPressed: () {
                    // --- ENABLE IN-APP MESSAGES --- //
                    FlutterInsider.Instance.enableInAppMessages();

                    print('[INSIDER][enableInAppMessages]: Method is triggered.');
              }),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Disable InApp',
                  onPressed: () {
                    // --- DISABLE IN-APP MESSAGES --- //
                    FlutterInsider.Instance.disableInAppMessages();

                    print('[INSIDER][disableInAppMessages]: Method is triggered.');
              }),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';

class GDPR extends StatelessWidget {
  GDPR();

  @override
  Widget build(BuildContext context) {
    // --- GDPR --- //
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: CustomButton(buttonText: 'GDPR True', onPressed: () {
                FlutterInsider.Instance.setGDPRConsent(true);

                print('INSIDER GDPR Status: true');
              }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: CustomButton(buttonText: 'GDPR False', onPressed: () {
                FlutterInsider.Instance.setGDPRConsent(false);

                print('INSIDER GDPR Status: false');
              }),
            )
          ],
        ),
      ],
    );
  }
}
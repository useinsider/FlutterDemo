import 'package:flutter/material.dart';

import 'package:flutter_demo/components/playground_console.dart';
import 'package:flutter_demo/components/custom_button.dart';

import 'package:flutter_insider/flutter_insider.dart';

class GDPR extends StatelessWidget {
  const GDPR({super.key});

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

                logInsider('INSIDER GDPR Status: true');
              }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: CustomButton(buttonText: 'GDPR False', onPressed: () {
                FlutterInsider.Instance.setGDPRConsent(false);

                logInsider('INSIDER GDPR Status: false');
              }),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Set Mobile App Access', onPressed: () {
                FlutterInsider.Instance.setMobileAppAccess(true);

                logInsider('[INSIDER][setMobileAppAccess]: Method is triggered.');
              }),
            ),
          ],
        ),
      ],
    );
  }
}
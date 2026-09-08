import 'package:flutter/material.dart';

import 'package:flutter_demo/components/playground_console.dart';
import 'package:flutter_demo/components/custom_button.dart';

import 'package:flutter_insider/flutter_insider.dart';

class Geofence extends StatelessWidget {
  const Geofence({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Start Tracking Geofence',
                  onPressed: () {
                    // --- GEOFENCE --- //
                    FlutterInsider.Instance.startTrackingGeofence();

                    logInsider('[INSIDER][startTrackingGeofence]: Method is triggered.');
              }),
            ),
          ],
        ),
      ],
    );
  }
}


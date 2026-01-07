import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';

class Geofence extends StatelessWidget {
  Geofence();

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

                    print('[INSIDER][startTrackingGeofence]: Method is triggered.');
              }),
            ),
          ],
        ),
      ],
    );
  }
}


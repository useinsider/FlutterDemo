import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

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
              child: CustomButton(buttonText: 'Get Message Center Data', onPressed: () async {
                // --- MESSAGE CENTER --- //
                DateTime startDate = DateTime.now().subtract(const Duration(days: 90));
                DateTime endDate = DateTime.now().add(const Duration(days: 90));

                print('[INSIDER][getMessageCenterData]: Method is triggered , waiting response.');

                List? messageCenterData =
                    await FlutterInsider.Instance.getMessageCenterData(startDate, endDate, 100);

                print('[INSIDER][getMessageCenterData]: $messageCenterData');
              }),
            ),
          ],
        ),
      ],
    );
  }
}
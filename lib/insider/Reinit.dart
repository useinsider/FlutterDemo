import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';
import 'package:flutter_insider/flutter_insider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Reinit extends StatelessWidget {
  String partnerName;
  final TextEditingController _controller;

  Reinit(this.partnerName) : _controller = TextEditingController(text: partnerName) {
    updatePartnerName();
  }

  Future updatePartnerName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedPartnerName = prefs.getString("insider_partner_name");

    if (cachedPartnerName != null && cachedPartnerName != "") {
      _controller.text = cachedPartnerName;
    } else {
      _controller.text = partnerName;
    }
  }

  Future reinitWithPartnerName(newPartnerName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("insider_partner_name", newPartnerName);

    FlutterInsider.Instance.reinitWithPartnerName(newPartnerName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Partner Name',
                ),
                onChanged: (value) {
                  partnerName = value;
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Reinit With Partner Name', onPressed: () {
                reinitWithPartnerName(partnerName);
              }),
            ),
          ],
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';
import 'package:flutter_insider/flutter_insider.dart';

class Reinit extends StatelessWidget {
  String partnerName;
  final TextEditingController _controller;

  Reinit(this.partnerName) : _controller = TextEditingController(text: partnerName);

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
                FlutterInsider.Instance.reinitWithPartnerName(partnerName);
              }),
            ),
          ],
        ),
      ],
    );
  }
}
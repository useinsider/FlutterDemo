import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/src/user.dart';
import 'package:flutter_insider/src/identifiers.dart';

class UserIdentifier extends StatelessWidget {
  UserIdentifier();

  @override
  Widget build(BuildContext context) {
    // --- USER IDENTIFIER --- //
    return
      Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: CustomButton(buttonText: 'Login', onPressed: () async {
                  // Setting User Identifiers.
                  FlutterInsiderUser currentUser = FlutterInsider.Instance.getCurrentUser()!;
                  FlutterInsiderIdentifiers identifiers = new FlutterInsiderIdentifiers();

                  identifiers.addEmail("mobile.test@useinsider.com");
                  identifiers.addPhoneNumber("+909876543210");
                  identifiers.addUserID("{crmID}");

                  // Login
                  currentUser.login(identifiers);

                  print('[INSIDER][login]: Method is triggered.');
                }),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: CustomButton(buttonText: 'Logout',
                    backgroundColor: const Color.fromRGBO(229, 127, 116, 1),
                    onPressed: () async {
                    FlutterInsiderUser currentUser = FlutterInsider.Instance.getCurrentUser()!;

                    // Logout
                    currentUser.logout();

                    print('[INSIDER][logout]: Method is triggered.');
              }),
              ),
            ],
          ),
        ],
      );
  }
}
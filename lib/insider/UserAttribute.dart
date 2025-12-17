import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/enum/InsiderGender.dart';
import 'package:flutter_insider/src/user.dart';

class UserAttribute extends StatelessWidget {
  UserAttribute();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Set Attributes', onPressed: () {
                // --- USER ATTRIBUTE --- //
                FlutterInsiderUser currentUser = FlutterInsider.Instance.getCurrentUser()!;

                // Setting User Attributes
                currentUser.setName("Insider");
                currentUser.setSurname("Demo");
                currentUser.setAge(23);
                currentUser.setGender(InsiderGender.OTHER);
                currentUser.setBirthday(new DateTime.now());
                currentUser.setEmailOptin(true);
                currentUser.setSMSOptin(false);
                currentUser.setPushOptin(true);
                currentUser.setLocationOptin(true);
                currentUser.setFacebookID("Facebook-ID");
                currentUser.setTwitterID("Twittter-ID");
                currentUser.setLanguage("TR");
                currentUser.setLocale("tr_TR");

                // Custom Attributes
                currentUser.setCustomAttributeWithBoolean("mobile_app_access", true);

                print('[INSIDER][getCurrentUser]: Method is triggered.');
              }),
            ),
          ],
        ),
      ],
    );
  }
}
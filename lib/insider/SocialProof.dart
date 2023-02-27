import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/src/product.dart';

class SocialProof extends StatelessWidget {
  final taxonomy = <String>['tax1', 'tax2', 'tax3'];

  SocialProof();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Trigger Social Proof',
                  onPressed: () {
                    // --- SOCIAL PROOF --- //
                    FlutterInsiderProduct insiderExampleProduct =
                      FlutterInsider.Instance.createNewProduct("productID", "productName",
                          taxonomy, "imageURL", 1000.5, "currency");

                    FlutterInsider.Instance.visitProductDetailPage(insiderExampleProduct);

                    print('[INSIDER][visitProductDetailPage]: Method is triggered.');
              }),
            ),
          ],
        ),
      ],
    );
  }
}
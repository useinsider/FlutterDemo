import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/src/product.dart';

class SmartRecommender extends StatelessWidget {
  final taxonomy = <String>['tax1', 'tax2', 'tax3'];

  SmartRecommender();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Get Smart Recommender Data',
                  onPressed: () async {
                    // --- SMART RECOMMENDER --- //
                    FlutterInsiderProduct insiderExampleProduct =
                      FlutterInsider.Instance.createNewProduct("productID", "productName",
                          taxonomy, "imageURL", 1000.5, "currency");

                    Map? recommendationWithID =
                        await FlutterInsider.Instance.getSmartRecommendation(1, "tr_TR", "TRY");

                    print("[INSIDER][getSmartRecommendation]: $recommendationWithID");

                    Map? recommendationWithProduct =
                        await FlutterInsider.Instance.getSmartRecommendationWithProduct(insiderExampleProduct, 1, "tr_TR");

                    print("[INSIDER][getSmartRecommendationWithProduct]: $recommendationWithProduct");

                    Map? recommendationWithProductIDs =
                        await FlutterInsider.Instance.getSmartRecommendationWithProductIDs(['X', 'Y', 'Z'], 1, "tr_TR", "TRY");

                    print("[INSIDER][getSmartRecommendationWithProductIDs]: $recommendationWithProductIDs");
              }),
            ),
          ],
        ),
      ],
    );
  }
}
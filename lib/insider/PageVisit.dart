import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/src/product.dart';

class PageVisit extends StatelessWidget {
  final taxonomy = <String>['tax1', 'tax2', 'tax3'];

  PageVisit();

  @override
  Widget build(BuildContext context) {
    // --- PAGE VISIT METHODS --- //
    FlutterInsiderProduct insiderExampleProduct =
      FlutterInsider.Instance.createNewProduct("productID", "productName",
          taxonomy, "imageURL", 1000.5, "currency");

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: CustomButton(buttonText: 'Home Page', onPressed: () {
                FlutterInsider.Instance.visitHomePage();

                print('[INSIDER][visitHomePage]: Method is triggered.');
              }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: CustomButton(buttonText: 'Product Page', onPressed: () {
                FlutterInsider.Instance.visitProductDetailPage(insiderExampleProduct);

                print('[INSIDER][visitProductDetailPage]: Method is triggered.');
              }),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: CustomButton(buttonText: 'Cart Page', onPressed: () {
                final insiderExampleProducts = <FlutterInsiderProduct>[
                  insiderExampleProduct,
                  insiderExampleProduct
                ];

                FlutterInsider.Instance.visitCartPage(insiderExampleProducts);

                print('[INSIDER][visitCartPage]: Method is triggered.');
              }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: CustomButton(buttonText: 'Category Page', onPressed: () {
                FlutterInsider.Instance.visitListingPage(taxonomy);

                print('[INSIDER][visitListingPage]: Method is triggered.');
              }),
            )
          ],
        )
      ],
    );
  }
}
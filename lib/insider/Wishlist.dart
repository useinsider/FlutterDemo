import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/src/product.dart';

class Wishlist extends StatelessWidget {
  final taxonomy = <String>['tax1', 'tax2', 'tax3'];

  Wishlist();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Add to Wishlist',
                  onPressed: () {
                    // --- ITEM ADDED TO WISHLIST --- //
                    FlutterInsiderProduct insiderProduct =
                      FlutterInsider.Instance.createNewProduct("productID", "productName",
                          taxonomy, "imageURL", 1000.5, "currency");

                    FlutterInsider.Instance.itemAddedToWishlist(insiderProduct);

                    print('[INSIDER][itemAddedToWishlist]: Method is triggered.');
              }),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Remove from Wishlist',
                  onPressed: () {
                    // --- ITEM REMOVED FROM WISHLIST --- //
                    FlutterInsider.Instance.itemRemovedFromWishlist("productID");

                    print('[INSIDER][itemRemovedFromWishlist]: Method is triggered.');
              }),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Clear Wishlist',
                  onPressed: () {
                    // --- WISHLIST CLEARED --- //
                    FlutterInsider.Instance.wishlistCleared();

                    print('[INSIDER][wishlistCleared]: Method is triggered.');
              }),
            ),
          ],
        ),
      ],
    );
  }
}

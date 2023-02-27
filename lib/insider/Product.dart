import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/src/product.dart';

class Product extends StatelessWidget {
  final arr = <String>['value1', 'value2', 'value3'];

  Product();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Create Product', onPressed: () {
                // --- PRODUCT --- //
                final taxonomy = <String>['tax1', 'tax2', 'tax3'];

                FlutterInsiderProduct insiderExampleProduct =
                FlutterInsider.Instance.createNewProduct("productID", "productName",
                    taxonomy, "imageURL", 1000.5, "currency");

                // Setting Product Attributes in chainable way.
                insiderExampleProduct
                    .setColor("color")
                    .setVoucherName("voucherName")
                    .setVoucherDiscount(10.5)
                    .setPromotionName("promotionName")
                    .setPromotionDiscount(10.5)
                    .setSize("size")
                    .setSalePrice(10.5)
                    .setShippingCost(10.5)
                    .setQuantity(10)
                    .setStock(10);

                // Setting custom attributes.
                // MARK: Your attribute key should be all lowercased and should not include any
                //special or non Latin characters or any space, otherwise this attribute will be ignored. You can use underscore _.
                insiderExampleProduct
                    .setCustomAttributeWithString("string_parameter", "This is Insider.")
                    .setCustomAttributeWithInt("int_parameter", 10)
                    .setCustomAttributeWithDouble("double_parameter", 10.5)
                    .setCustomAttributeWithBoolean("bool_parameter", true)
                    .setCustomAttributeWithDate("date_parameter", new DateTime.now());

                // MARK: You can only call the method with array of string otherwise this event will be ignored.
                insiderExampleProduct.setCustomAttributeWithArray("array_parameter", arr);

                print('[INSIDER][createNewProduct]: Method is triggered.');
              }),
            ),
          ],
        ),
      ],
    );
  }
}
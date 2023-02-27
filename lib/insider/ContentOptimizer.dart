import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/enum/ContentOptimizerDataType.dart';

class ContentOptimizer extends StatelessWidget {
  ContentOptimizer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Get Variable With Content Optimizer',
                  onPressed: () async {
                    // --- CONTENT OPTIMIZER --- //

                    var contentOptimizerString =
                        await FlutterInsider.Instance.getContentStringWithName(
                        "string_variable_name",
                        "defaultValue",
                        ContentOptimizerDataType.ELEMENT);

                    print('[INSIDER][getContentStringWithName]: $contentOptimizerString');

                    // Boolean
                    var contentOptimizerBool =
                        await FlutterInsider.Instance.getContentBoolWithName(
                        "bool_variable_name", true, ContentOptimizerDataType.ELEMENT);

                    print('[INSIDER][getContentBoolWithName]: $contentOptimizerBool');

                    // Integer
                    var contentOptimizerInt =
                        await FlutterInsider.Instance.getContentIntWithName(
                        "int_variable_name", 10, ContentOptimizerDataType.ELEMENT);

                    print('[INSIDER][getContentIntWithName]: $contentOptimizerInt');
              }),
            ),
          ],
        ),
      ],
    );
  }
}
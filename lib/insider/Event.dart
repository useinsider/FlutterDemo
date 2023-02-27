import 'package:flutter/material.dart';
import 'package:flutter_demo/components/CustomButton.dart';

import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/src/event.dart';

class Event extends StatelessWidget {
  final arr = <String>['value1', 'value2', 'value3'];
  Event();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(buttonText: 'Trigger Events', onPressed: () {
                // --- EVENT --- //

                // You can create an event without parameters and call the build method
                FlutterInsider.Instance.tagEvent("first_event").build();

                // You can create an event then add parameters and call the build method
                FlutterInsider.Instance.tagEvent("second_event")
                    .addParameterWithInt("int_parameter", 10)
                    .build();

                // You can create an object and add the parameters later
                FlutterInsiderEvent insiderExampleEvent =
                FlutterInsider.Instance.tagEvent("third_event");

                insiderExampleEvent
                    .addParameterWithString("string_parameter", "This is Insider.")
                    .addParameterWithInt("int_parameter", 10)
                    .addParameterWithDouble("double_parameter", 10.5)
                    .addParameterWithBoolean("bool_parameter", true)
                    .addParameterWithDate("date_parameter", new DateTime.now());

                // MARK: You can only call the method with array of string otherwise this event will be ignored.
                insiderExampleEvent.addParameterWithArray("array_parameter", arr);

                // Do not forget to call build method once you are done with parameters.
                // Otherwise your event will be ignored.
                insiderExampleEvent.build();

                print('Insider events triggered.');
              }),
            ),
          ],
        ),
      ],
    );
  }
}
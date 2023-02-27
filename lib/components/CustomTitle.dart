import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String title;

  CustomTitle({ required this.title });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String title;

  const CustomTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // item_playground_header.xml — 16dp sides, 16dp above, 6dp below.
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

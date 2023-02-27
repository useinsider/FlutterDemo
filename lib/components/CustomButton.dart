import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;
  final Color? backgroundColor;

  CustomButton({ required this.buttonText, required this.onPressed, this.backgroundColor });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.black, // Set the background color of the button
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(buttonText),
      ),
    );
  }
}
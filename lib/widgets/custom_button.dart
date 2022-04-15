// ignore_for_file: use_key_in_widget_constructors

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ElevatedButton(
      child: Text(
        text,
        style: Styles.buttonTextStyle,
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: Styles.backgroundPrimary,
        side: const BorderSide(width: 3, color: Styles.primaryColor),
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1, vertical: size.width * 0.02),
        elevation: 3,
      ),
    );
  }
}

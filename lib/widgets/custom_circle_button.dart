// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  VoidCallback onPressed;
  IconData icon;
  bool isLoading;
  CustomCircleButton(
      {Key? key,
      required this.icon,
      required this.onPressed,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: onPressed,
      child: isLoading
          ? Container(
              height: size.width * 0.03,
              width: size.width * 0.03,
              alignment: Alignment.center,
              child: const CircularProgressIndicator())
          : Icon(
              icon,
              size: 25,
            ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(const CircleBorder()),
        padding: MaterialStateProperty.all(EdgeInsets.all(size.width * 0.02)),
        backgroundColor:
            MaterialStateProperty.all(Styles.primaryColor), // <-- Button color
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) return Styles.fourthColor;
          return null; // <-- Splash color
        }),
      ),
    );
  }
}

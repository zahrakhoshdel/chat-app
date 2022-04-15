// ignore_for_file: must_be_immutable, file_names

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  double bottomPadding;
  double rightPadding;
  VoidCallback onPressed;
  IconData icon;
  CustomFloatingActionButton(
      {Key? key,
      required this.bottomPadding,
      required this.rightPadding,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, right: rightPadding),
      child: SizedBox(
        height: size.width * 0.11,
        width: size.width * 0.11,
        child: FittedBox(
          child: FloatingActionButton(
              backgroundColor: Styles.primaryColor,
              elevation: 5,
              child: Icon(
                icon,
              ),
              onPressed: onPressed),
        ),
      ),
    );
  }
}

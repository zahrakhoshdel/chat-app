// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class LogoIcon extends StatelessWidget {
  double logosize;
  LogoIcon({Key? key, required this.logosize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: logosize,
      height: logosize,
      decoration: BoxDecoration(
          color: Styles.backgroundSecondary,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: Styles.softShadows),
      child: Icon(
        Icons.message,
        color: Styles.primaryColor,
        size: logosize * 0.5,
      ),
    );
  }
}

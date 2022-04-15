import 'package:flutter/material.dart';

//const kPhoneNumber = '+11111111111'; //test

abstract class Styles {
  // static const backgroundImage = 'assets/images/bg.jpg';
  static const imgProfile = 'assets/images/imgProfile.png';

/////////////////////////// COLOR ///////////////////////////
  static const Color backgroundPrimary = Color(0xffe7ecef);
  static const Color backgroundSecondary = Color(0xD8D0D6DE);

  static const Color primaryColor = Color(0xff5a6199);
  static const Color secondaryColor = Color(0xFFaa6373);
  static const Color thirdColor = Color(0xFFEBA626);
  static const Color fourthColor = Color(0xFFb6b7d0);

  static const Color darkShadow = Color(0xffcfceca);
  static const Color lightShadow = Color(0xffffffff);

  static const Color textColor = Color(0xff001f3f);
  static const Color textColorSecondary = Color(0xFF795548);

  static const Color onlineIndicator = Color(0xff614a80);

  static const Color greyColorLight = Color(0xffd7d7d7);

  static const softShadows = [
    BoxShadow(
        color: darkShadow,
        offset: Offset(2.0, 2.0),
        blurRadius: 2.0,
        spreadRadius: 1.0),
    BoxShadow(
        color: lightShadow,
        offset: Offset(-2.0, -2.0),
        blurRadius: 2.0,
        spreadRadius: 1.0),
  ];

  static const softShadowsInvert = [
    BoxShadow(
        color: lightShadow,
        offset: Offset(2.0, 2.0),
        blurRadius: 1.0,
        spreadRadius: 1.0),
    BoxShadow(
        color: darkShadow,
        offset: Offset(-2.0, -2.0),
        blurRadius: 2.0,
        spreadRadius: 2.0),
  ];

/////////////////////////// TEXT ///////////////////////////

  static const TextStyle smallTextStyle = TextStyle(
    color: primaryColor,
    fontSize: 20,
  );

  static const TextStyle defaultTextStyle = TextStyle(
    color: textColor,
    fontSize: 25,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: secondaryColor,
    fontSize: 30,
  );

  static const TextStyle titleTextStyle = TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 40,
  );

  static const TextStyle titleStyle = TextStyle(
    color: Styles.textColor,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle subtitleStyle = TextStyle(
    color: Styles.textColor,
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
  );
}

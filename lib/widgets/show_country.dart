// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class ShowCountry extends StatelessWidget {
  String countryName;
  ShowCountry({Key? key, required this.countryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(size.width * 0.015),
      decoration: BoxDecoration(
          color: Styles.backgroundSecondary,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: Styles.softShadows),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.language,
            color: Styles.primaryColor,
            size: 32,
          ),
          SizedBox(
            width: size.width * 0.01,
          ),
          Text(
            countryName,
            style: Styles.smallTextStyle,
          ),
          SizedBox(
            width: size.width * 0.01,
          ),
          const Icon(
            Icons.arrow_drop_down,
            color: Styles.primaryColor,
            size: 32,
          ),
        ],
      ),
    );
  }
}

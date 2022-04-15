// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String dialCode;
  bool otp;
  bool textType;
  CustomTextField({
    Key? key,
    required this.controller,
    this.dialCode = '',
    this.otp = false,
    this.textType = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: otp
          ? EdgeInsets.symmetric(horizontal: size.width * 0.1)
          : const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
          color: Styles.backgroundPrimary,
          boxShadow: Styles.softShadowsInvert,
          borderRadius: BorderRadius.circular(30.0)),
      child: TextField(
        keyboardType: otp
            ? TextInputType.number
            : textType
                ? TextInputType.name
                : TextInputType.phone,
        controller: controller,
        //style: Styles.defaultTextStyle,
        style: TextStyle(
          letterSpacing: otp ? 30 : null,
          color: Styles.textColor,
          fontSize: 30.0,
        ),
        textAlign: otp ? TextAlign.center : TextAlign.left,
        decoration: InputDecoration(
          filled: true,
          fillColor: Styles.backgroundSecondary.withOpacity(0.5),
          prefixIcon: dialCode.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.all(size.width * 0.02),
                  child: Text(
                    dialCode,
                    style:
                        Styles.defaultTextStyle.copyWith(color: Colors.black45),
                  ),
                )
              : const SizedBox(),
          border: InputBorder.none,
          isDense: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Styles.primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

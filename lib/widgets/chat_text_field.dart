// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  TextEditingController controller;
  String hint;

  ChatTextField({
    Key? key,
    required this.controller,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Expanded(
      child: TextFormField(
        minLines: 1,
        maxLines: 5,
        controller: controller,
        autocorrect: false,
        style: Styles.smallTextStyle,
        decoration: InputDecoration(
          hintText: hint,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Styles.primaryColor)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Styles.primaryColor)),
          filled: true,
          contentPadding: EdgeInsets.all(size.width * 0.02),
        ),
      ),
    );
  }
}

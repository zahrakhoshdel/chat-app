// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/logo_icon.dart';
import 'package:flutter/material.dart';

class BaseScreenAuth extends StatelessWidget {
  String testStep;
  String hintText;
  Widget bodyWidget;

  BaseScreenAuth(
      {Key? key,
      required this.testStep,
      required this.hintText,
      required this.bodyWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoIcon(
                    logosize: size.width * 0.15,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Text(
                    testStep,
                    style: Styles.titleTextStyle
                        .copyWith(color: Styles.secondaryColor),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(hintText,
                  style: Styles.defaultTextStyle
                      .copyWith(color: Colors.grey, fontSize: 32)),
              SizedBox(
                height: size.height * 0.02,
              ),
              bodyWidget,
              SizedBox(
                height: size.height * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

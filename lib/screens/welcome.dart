// ignore_for_file: non_constant_identifier_names

import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/login/phone_verification_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/logo_icon.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoIcon(
              logosize: size.width * 0.2,
            ),
            info(),
            TermsAndConditions(onPressed: () {}),
            CustomButton(
                text: "Let\'s Start",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhoneVerificationScreen()),
                  );
                })
          ],
        ),
      ),
    );
  }

  info() {
    return Column(
      children: [
        const Text(
          'Hello!',
          style: Styles.titleTextStyle,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'mobile messaging with friends',
          style: Styles.defaultTextStyle.copyWith(color: Styles.secondaryColor),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'all over the world',
          style: Styles.defaultTextStyle.copyWith(color: Styles.secondaryColor),
        ),
      ],
    );
  }

  TextButton TermsAndConditions({required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        "Terms and conditions",
        style: Styles.defaultTextStyle,
      ),
    );
  }
}

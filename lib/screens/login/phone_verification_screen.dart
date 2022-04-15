// ignore_for_file: use_key_in_widget_constructors

import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/login/base_screen_auth.dart';
import 'package:chat_app/screens/login/verify_number_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/select_country.dart';
import 'package:chat_app/widgets/show_country.dart';
import 'package:flutter/material.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final phoneController = TextEditingController();
  Map<String, dynamic> data = {
    "name": "Iran",
    "dial_code": "+98",
  };

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BaseScreenAuth(
      testStep: "Verification • one step",
      hintText: "Enter your phone number",
      bodyWidget: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
                onTap: () {
                  _showForm(context);
                },
                child: ShowCountry(countryName: data['name'])),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          CustomTextField(
            controller: phoneController,
            dialCode: data['dial_code'],
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          const Text(
            "You will receive an activation code in short time",
            style: Styles.smallTextStyle,
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          CustomButton(
            text: 'Send Code',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerifyNumberScreen(
                        number: data['dial_code'] + phoneController.text)),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showForm(
    BuildContext context,
  ) async {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        backgroundColor: Styles.backgroundPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (_) => const SelectCountry()).then((value) {
      setState(() {
        if (value != null) data = value;
        //print('dataResult: $value');
      });
    });
  }
}

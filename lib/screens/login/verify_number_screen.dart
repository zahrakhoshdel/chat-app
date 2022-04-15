// ignore_for_file: constant_identifier_names

import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/login/base_screen_auth.dart';
import 'package:chat_app/screens/login/user_credential_screen.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_progress_indicator.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status { Waiting, Error }

class VerifyNumberScreen extends StatefulWidget {
  final String number;
  const VerifyNumberScreen({Key? key, required this.number}) : super(key: key);

  @override
  State<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String currentVerificationId = '';
  bool showLoading = false;

  var status = Status.Waiting;

  @override
  void initState() {
    super.initState();
    sendCode();
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UserCredentialInputScreen()));
      }
    } on FirebaseAuthException {
      setState(() {
        showLoading = false;
        status = Status.Error;
        otpController.text = "";
      });
    }
  }

  sendCode() async {
    setState(() {
      showLoading = true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.number,
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          showLoading = false;
        });
        // signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) async {
        setState(() {
          showLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(verificationFailed.message.toString())));
      },
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          showLoading = false;
          currentVerificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  verifyCode() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: currentVerificationId,
      smsCode: otpController.text,
    );

    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BaseScreenAuth(
        testStep: "OTP • two step",
        hintText: showLoading
            ? ''
            : status != Status.Error
                ? "Enter OTP sent to"
                : "The code used is invalid!",
        bodyWidget: showLoading
            ? Center(
                child: CustomProgressIndicator(
                  width: size.width * .02,
                  height: size.width * .02,
                ),
              )
            : status != Status.Error
                ? Column(
                    children: [
                      Text(
                        widget.number,
                        style: Styles.smallTextStyle,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomTextField(
                        controller: otpController,
                        otp: true,
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Did't receive the OTP?",
                            style: Styles.smallTextStyle,
                          ),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                status = Status.Waiting;
                              });
                              await sendCode();
                            },
                            child: Text(
                              "RESEND OTP",
                              style: Styles.smallTextStyle
                                  .copyWith(color: Styles.secondaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      CustomButton(
                        text: "Verify OTP",
                        onPressed: verifyCode,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      TextButton(
                        onPressed: () async => Navigator.pop(context),
                        child: const Text(
                          "Edit Number",
                          style: Styles.smallTextStyle,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            status = Status.Waiting;
                          });
                          await sendCode();
                        },
                        child: const Text(
                          "RESEND OTP",
                          style: Styles.smallTextStyle,
                        ),
                      ),
                    ],
                  ));
  }
}

import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:chat_app/widgets/avatar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCredentialInputScreen extends StatefulWidget {
  const UserCredentialInputScreen({Key? key}) : super(key: key);

  @override
  _UserCredentialInputScreenState createState() =>
      _UserCredentialInputScreenState();
}

class _UserCredentialInputScreenState extends State<UserCredentialInputScreen> {
  // late File? _userImageFile = File("");
  // void _pickedImage(File? image) {
  //   _userImageFile = image;
  // }

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  submitUserInformation() async {
    FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);
    await firestore.collection('users').doc(auth.currentUser!.uid).set({
      'name': nameController.text,
      'bio': bioController.text,
      'phone': FirebaseAuth.instance.currentUser!.phoneNumber,
      'status': 'Available',
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //UserImagePicker(_pickedImage),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                'Enter your information',
                style: Styles.titleTextStyle
                    .copyWith(color: Styles.secondaryColor),
              ),
              Avatar(
                width: size.width * 0.3,
                height: size.width * 0.3,
                url: 'assets/images/user_info.png',
              ),

              SizedBox(
                height: size.height * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name:",
                    style: Styles.smallTextStyle,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  CustomTextField(controller: nameController, textType: true),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  const Text(
                    "Bio:",
                    style: Styles.smallTextStyle,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  CustomTextField(controller: bioController, textType: true),
                ],
              ),

              SizedBox(
                height: size.height * 0.04,
              ),
              CustomButton(
                  text: 'Lets Chat !',
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      CustomSnackBar(
                        context,
                        const Text('Please enter a name'),
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    if (bioController.text.isEmpty) {
                      CustomSnackBar(
                        context,
                        const Text('Please enter a bio'),
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    submitUserInformation();
                  }),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

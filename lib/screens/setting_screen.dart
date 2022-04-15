// ignore_for_file: use_key_in_widget_constructors

import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/welcome.dart';
import 'package:chat_app/widgets/avatar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_progress_indicator.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser!.uid;

  late CollectionReference messageRef;

  @override
  void initState() {
    super.initState();
    messageRef = firestore.collection('users');
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // nameController.text=;
    // bioController.text=;

    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Styles.backgroundPrimary,
        //   title: Padding(
        //     padding: EdgeInsets.only(left: size.width * 0.08),
        //     child: Text(
        //       'Setting',
        //       style:
        //           Styles.buttonTextStyle.copyWith(color: Styles.primaryColor),
        //     ),
        //   ),
        //   elevation: 5,
        //   toolbarHeight: 100,
        // ),
        body: StreamBuilder<QuerySnapshot>(
      stream: messageRef.where('uid', isEqualTo: currentUser).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
        if (snapshots.hasError) {
          return const Center(
            child: Text("Something went wrong!"),
          );
        }
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const CustomProgressIndicator();
        }
        if (snapshots.hasData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 5,
                forceElevated: true,
                pinned: true,
                expandedHeight: 100,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Setting',
                    style: Styles.buttonTextStyle
                        .copyWith(color: Styles.primaryColor),
                  ),
                ),
                backgroundColor: Styles.backgroundPrimary,
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                snapshots.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  nameController.text = data['name'];
                  bioController.text = data['bio'];
                  return Padding(
                    padding: EdgeInsets.all(size.width * 0.1),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Text(
                          'Enter your information',
                          style: Styles.titleTextStyle
                              .copyWith(color: Styles.secondaryColor),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
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
                            CustomTextField(
                                controller: nameController, textType: true),
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
                            CustomTextField(
                                controller: bioController, textType: true),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            Center(
                                child: CustomButton(
                              text: 'LogOut',
                              onPressed: () {
                                signOut();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WelcomeScreen()));
                              },
                            )),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ))
            ],
          );
        }
        return Container();
      },
    ));
  }
}

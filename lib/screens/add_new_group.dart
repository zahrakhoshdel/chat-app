// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:chat_app/widgets/chat_text_field.dart';
import 'package:chat_app/widgets/custom_floatingActionButton.dart';
import 'package:chat_app/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddNewGroup extends StatefulWidget {
  List<Map<String, dynamic>> memberList;

  AddNewGroup({Key? key, required this.memberList}) : super(key: key);

  @override
  State<AddNewGroup> createState() => _AddNewGroupState();
}

class _AddNewGroupState extends State<AddNewGroup> {
  TextEditingController groupName = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  void createGroup() async {
    setState(() {
      isLoading = true;
    });
    String groupId = const Uuid().v1();

    await firestore.collection('groups').doc(groupId).set({
      "members": widget.memberList,
      "id": groupId,
    });

    for (int i = 0; i < widget.memberList.length; i++) {
      String uid = widget.memberList[i]['uid'];

      await firestore
          .collection('users')
          .doc(uid)
          //.where("name", isEqualTo: uid)
          .collection('groups')
          .doc(groupId)
          .set({
        "groupName": groupName.text,
        "groupId": groupId,
      });

      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .add({
        "message": "${auth.currentUser!.displayName} Created This Group",
        "type": "notify",
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: size.width * 0.03),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Styles.primaryColor,
                )),
          ),
          backgroundColor: Styles.backgroundPrimary,
          title: Text(
            'Create new group',
            style: Styles.buttonTextStyle.copyWith(color: Styles.primaryColor),
          ),
          elevation: 5,
          centerTitle: true,
          toolbarHeight: 100,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: size.width * 0.07,
                    backgroundColor: Styles.primaryColor,
                    foregroundColor: Colors.white,
                    child: const Icon(
                      Icons.group,
                      size: 50,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  ChatTextField(
                      controller: groupName, hint: "Enter group name"),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: groupName.text.length >= 2
            ? CustomFloatingActionButton(
                bottomPadding: size.width * 0.05,
                rightPadding: size.width * 0.05,
                icon: Icons.done,
                onPressed: () {
                  createGroup();
                  CustomSnackBar(
                    context,
                    Text('Successfully created ${groupName.text} group'),
                    backgroundColor: Colors.green,
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              )
            : const SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

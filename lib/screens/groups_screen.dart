import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/add_member_group_screen.dart';
import 'package:chat_app/screens/general_group_screen.dart';
import 'package:chat_app/screens/group_chats_screen.dart';
import 'package:chat_app/widgets/custom_floatingActionButton.dart';
import 'package:chat_app/widgets/custom_progress_indicator.dart';
import 'package:chat_app/widgets/group_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.backgroundPrimary,
          title: Padding(
            padding: EdgeInsets.only(left: size.width * 0.08),
            child: Text(
              'Groups',
              style:
                  Styles.buttonTextStyle.copyWith(color: Styles.primaryColor),
            ),
          ),
          elevation: 5,
          toolbarHeight: 100,
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _titleText('General Group'),
                  GroupCard(
                      onTapped: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GeneralGroupScreen(
                                      groupName: 'main',
                                    )));
                      },
                      title: 'main'),
                  const Divider(
                    //height: 10,
                    thickness: 3,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  _titleText('New Groups'),
                  isLoading
                      ? const Center(child: CustomProgressIndicator())
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: groupList.length,
                          itemBuilder: (context, index) {
                            return GroupCard(
                                onTapped: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              groupChatsScreen(
                                                groupChatId: groupList[index]
                                                    ['groupId'],
                                                groupChatName: groupList[index]
                                                    ['groupName'],
                                              )));
                                },
                                title: groupList[index]['groupName']);
                          }),
                ],
              ),
            )),
        floatingActionButton: CustomFloatingActionButton(
          bottomPadding: size.height * 0.12,
          rightPadding: size.width * 0.03,
          icon: Icons.group_add_rounded,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddMemberGroupScreen()));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  _titleText(String title) {
    return Text(title,
        style: Styles.buttonTextStyle.copyWith(color: Styles.secondaryColor));
  }
}

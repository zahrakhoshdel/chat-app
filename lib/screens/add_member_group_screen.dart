import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/add_new_group.dart';
import 'package:chat_app/widgets/chat_text_field.dart';
import 'package:chat_app/widgets/custom_circle_button.dart';
import 'package:chat_app/widgets/custom_floatingActionButton.dart';
import 'package:chat_app/widgets/member_circle.dart';
import 'package:chat_app/widgets/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMemberGroupScreen extends StatefulWidget {
  const AddMemberGroupScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberGroupScreen> createState() => _AddMemberGroupScreenState();
}

class _AddMemberGroupScreenState extends State<AddMemberGroupScreen> {
  TextEditingController search = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  Map<String, dynamic>? userMap;
  List<Map<String, dynamic>> memberList = [];

  var userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetaila();
  }

  void getCurrentUserDetaila() {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: userId)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.map((data) {
          //print('name: ${data['name']}');

          setState(() {
            memberList.add({
              'name': data['name'],
              'phone': data['phone'],
              'isAdmin': true,
              'uid': data['uid'],
            });
          });
        }).toList();
      } else {
        print('Document does not exist on the database');
      }
    });

    //print('memberList: $memberList');
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await firestore
        .collection('users')
        .where("name", isEqualTo: search.text)
        .get()
        .then((value) {
      setState(() {
        isLoading = false;
        userMap = value.docs[0].data();
      });
      //print('userMap: $userMap');
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < memberList.length; i++) {
      if (memberList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        memberList.add({
          'name': userMap!['name'],
          'lastname': userMap!['lastname'],
          'phone': userMap!['phone'],
          'isAdmin': false,
          'uid': userMap!['uid'],
        });
        userMap = null;
      });
    }
  }

  void onRemoveMember(int index) {
    if (memberList[index]['uid'] != userId) {
      setState(() {
        memberList.removeAt(index);
      });
    }
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
            'Add member',
            style: Styles.buttonTextStyle.copyWith(color: Styles.primaryColor),
          ),
          elevation: 5,
          centerTitle: true,
          toolbarHeight: 100,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: size.height * 0.13,
                child: ListView.builder(
                    itemCount: memberList.length,
                    //physics: const ClampingScrollPhysics(),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return MemberCircle(
                        onTaped: () => onRemoveMember(index),
                        name: memberList[index]['name'],
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03, vertical: size.width * 0.01),
                child: Row(
                  children: [
                    ChatTextField(
                      controller: search,
                      hint: "Search user ...",
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    CustomCircleButton(
                      icon: Icons.search_rounded,
                      onPressed: onSearch,
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
              userMap != null
                  ? UserCard(
                      fullname: userMap!['name'],
                      sub: userMap!['phone'],
                      //url: 'assets/images/imgProfile.png',
                      onTapped: onResultTap,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        floatingActionButton: memberList.length >= 2
            ? CustomFloatingActionButton(
                bottomPadding: size.width * 0.05,
                rightPadding: size.width * 0.05,
                icon: Icons.forward,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewGroup(
                              memberList: memberList,
                            ))),
              )
            : const SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

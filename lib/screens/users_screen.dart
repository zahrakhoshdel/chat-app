// ignore_for_file: use_key_in_widget_constructors, unused_local_variable

import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/custom_progress_indicator.dart';
import 'package:chat_app/widgets/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  late CollectionReference messageRef;

  var currentUser = FirebaseAuth.instance.currentUser!.uid;

  String chatRoomId(String user1, String user2) {
    return "$user1$user2";

    // if (user1[0].toLowerCase().codeUnits[0] >
    //     user2.toLowerCase().codeUnits[0]) {
    //   return "$user1$user2";
    // } else {
    //   return "$user2$user1";
    // }
  }

  void callChatDetailScreen(String name, String uid, String chatRoomId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                chatRoomId: chatRoomId, friendUid: uid, friendName: name)));
  }

  @override
  void initState() {
    super.initState();
    messageRef = firestore.collection('users');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: messageRef.where('uid', isNotEqualTo: currentUser).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.hasError) {
            return const Center(
              child: Text("Something went wrong!"),
            );
          }
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomProgressIndicator());
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
                      'Users',
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
                    return UserCard(
                      fullname: '${data['name']}',
                      sub: data['status'],
                      //url: 'assets/images/imgProfile.png',
                      onTapped: () {
                        String roomId = chatRoomId(
                          auth.currentUser!.displayName.toString(),
                          data['name'],
                        );
                        callChatDetailScreen(data['name'], data['uid'], roomId);
                      },
                    );
                  }).toList(),
                ))
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors

import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/custom_progress_indicator.dart';
import 'package:chat_app/widgets/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserChatsScreen extends StatefulWidget {
  @override
  State<UserChatsScreen> createState() => _UserChatsScreenState();
}

class _UserChatsScreenState extends State<UserChatsScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late CollectionReference messageRef;
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  var userId = '';

  var currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var chatDocumets = [];
  Map<String, dynamic> messages = {};

  void refChatsForCurrentUser() async {
    await chats
        .where('users.$currentUserId', isNull: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      //print('object:${snapshot.docs.length}');
      if (snapshot.docs.length != 0) {
        chatDocumets = snapshot.docs.map((DocumentSnapshot doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Map<String, dynamic> names = data['names'];
          names.remove(currentUserId);
          return {
            'docid': doc.id,
            'name': names.values.first,
            'id': names.keys.first
          };
        }).toList();
        //print('chatDocumets: $chatDocumets');

        if (mounted) {
          setState(() {
            isLoading = false;
            chatDocumets.forEach((doc) {
              FirebaseFirestore.instance
                  .collection('chats/${doc['docid']}/messages')
                  .orderBy('createdOn', descending: true)
                  .limit(1)
                  .snapshots()
                  .listen((QuerySnapshot snapshot) {
                if (snapshot.docs.isNotEmpty) {
                  messages[doc['name']] = {
                    'msg': snapshot.docs.first['msg'],
                    'time': snapshot.docs.first['createdOn'],
                    'friendName': doc['name'],
                    'friendUid': doc['id'],
                    'chatRoomId': doc['docid']
                  };
                  //print('messages: $messages');
                }
              });
            });
          });
        }
      }
    });
  }

  bool isLoading = true;

  List usersChatList = [];

  @override
  void initState() {
    super.initState();
    refChatsForCurrentUser();
    messageRef = firestore.collection('chats');
  }

  void callChatDetailScreen(String name, String uid, String chatRoomId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                chatRoomId: chatRoomId, friendUid: uid, friendName: name)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: messageRef
                .where('users.$currentUserId', isNull: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong!"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomProgressIndicator());
              }

              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      elevation: 5,
                      forceElevated: true,
                      pinned: true,
                      expandedHeight: 100,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          'Users Chat',
                          style: Styles.buttonTextStyle
                              .copyWith(color: Styles.primaryColor),
                        ),
                      ),
                      backgroundColor: Styles.backgroundPrimary,
                    ),
                    snapshot.data!.docs.length == 0
                        ? SliverList(
                            delegate: SliverChildListDelegate([
                              //const SizedBox.shrink(),
                              Center(
                                  child: Padding(
                                padding:
                                    EdgeInsets.only(top: size.height * 0.1),
                                child: Text(
                                  "no chats",
                                  style: Styles.defaultTextStyle.copyWith(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                            ]),
                          )
                        : SliverList(
                            delegate: SliverChildListDelegate(
                                messages.values.toList().map((data) {
                            Timestamp time = data['time'];
                            DateTime msgTime = time.toDate();
                            return UserCard(
                                fullname: '${data['friendName']}',
                                sub: msgTime.toString(),
                                //url: 'assets/images/imgProfile.png',
                                onTapped: () {
                                  callChatDetailScreen(
                                    data['friendName'],
                                    data['friendUid'],
                                    data['chatRoomId'],
                                  );
                                });
                          }).toList()))
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }

  String formatTimestamp(int timestamp) {
    var format = DateFormat('d MMM, hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }
}

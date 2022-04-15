// ignore_for_file: camel_case_types

import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/chat_text_field.dart';
import 'package:chat_app/widgets/custom_circle_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';

class groupChatsScreen extends StatefulWidget {
  final String groupChatId, groupChatName;

  const groupChatsScreen(
      {Key? key, required this.groupChatId, required this.groupChatName})
      : super(key: key);
  @override
  State<groupChatsScreen> createState() => _groupChatsScreenState();
}

class _groupChatsScreenState extends State<groupChatsScreen> {
  final TextEditingController _message = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final currentUserName = FirebaseAuth.instance.currentUser!.displayName;

  @override
  void initState() {
    super.initState();
  }

  bool isSender(String friend) {
    //print('friend: $friend');
    //print('currentUserId: $currentUserId');
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
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
            widget.groupChatName,
            style: Styles.buttonTextStyle.copyWith(color: Styles.primaryColor),
          ),
          elevation: 5,
          centerTitle: true,
          toolbarHeight: 100,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('groups')
                      .doc(widget.groupChatId)
                      .collection('chats')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Something went wrong!"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text('Loading ...'),
                      );
                    }

                    if (snapshot.hasData) {
                      return ListView(
                        shrinkWrap: true,
                        reverse: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map data = document.data()! as Map;
                          // Map<String, dynamic> data =
                          //     document.data()! as Map<String, dynamic>;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper5(
                                  radius: 25,
                                  secondRadius: 2,
                                  type: isSender(data['sendById'].toString())
                                      ? BubbleType.sendBubble
                                      : BubbleType.receiverBubble),
                              alignment:
                                  getAlignment(data['sendById'].toString()),
                              margin: const EdgeInsets.only(
                                top: 20,
                              ),
                              backGroundColor:
                                  isSender(data['sendById'].toString())
                                      ? const Color(0xFF08C187)
                                      : Styles.backgroundSecondary,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.6,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * .01),
                                child: Column(
                                  children: [
                                    Text(
                                      data["sendBy"],
                                      style: Styles.defaultTextStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isSender(
                                                  data['sendById'].toString())
                                              ? Styles.primaryColor
                                              : Styles.secondaryColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      data['message'],
                                      style: Styles.defaultTextStyle.copyWith(
                                          color: isSender(
                                                  data['sendById'].toString())
                                              ? Colors.white
                                              : Colors.black),
                                      maxLines: 50,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                      data['createdOn'] == null
                                          ? DateTime.now().toString()
                                          : data['createdOn']
                                              .toDate()
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: isSender(
                                                  data['senderUid'].toString())
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return const Center(child: Text('No chats'));
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.03),
              child: Row(
                children: [
                  ChatTextField(
                    controller: _message,
                    hint: "Type message...",
                  ),
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  CustomCircleButton(
                    icon: Icons.send_rounded,
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    String text = _message.text;
    if (text.trim().length < 1) {
      return;
    }

    Map<String, dynamic> chatData = {
      "sendById": auth.currentUser!.uid,
      "sendBy": auth.currentUser!.displayName,
      "message": _message.text,
      "time": FieldValue.serverTimestamp(),
    };
    _message.text = '';

    await firestore
        .collection('groups')
        .doc(widget.groupChatId)
        .collection('chats')
        .add(chatData);
  }
}

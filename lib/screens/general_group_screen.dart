// ignore_for_file: must_be_immutable, prefer_collection_literals

import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/chat_text_field.dart';
import 'package:chat_app/widgets/custom_circle_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';

class GeneralGroupScreen extends StatefulWidget {
  String groupName;
  GeneralGroupScreen({Key? key, required this.groupName}) : super(key: key);
  @override
  State<GeneralGroupScreen> createState() => _GeneralGroupScreenState();
}

class _GeneralGroupScreenState extends State<GeneralGroupScreen> {
  var textController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference messageRef;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final currentUserName = FirebaseAuth.instance.currentUser!.displayName;

  @override
  void initState() {
    super.initState();
    messageRef = firestore.collection('generalChat');
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
            widget.groupName,
            style: Styles.buttonTextStyle.copyWith(color: Styles.primaryColor),
          ),
          elevation: 5,
          centerTitle: true,
          toolbarHeight: 100,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream:
                      messageRef.orderBy('time', descending: true).snapshots(),
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
                                  type: isSender(data['senderUid'].toString())
                                      ? BubbleType.sendBubble
                                      : BubbleType.receiverBubble),
                              alignment:
                                  getAlignment(data['senderUid'].toString()),
                              margin: const EdgeInsets.only(
                                top: 20,
                              ),
                              backGroundColor:
                                  isSender(data['senderUid'].toString())
                                      ? const Color(0xFF08C187)
                                      : Styles.backgroundSecondary,
                              //: Color(0xFFD0D0D5),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * .01),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.6,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      data['senderName'],
                                      style: Styles.defaultTextStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isSender(
                                                  data['senderUid'].toString())
                                              ? Styles.primaryColor
                                              : Styles.secondaryColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      data['msg'],
                                      style: Styles.defaultTextStyle.copyWith(
                                          color: isSender(
                                                  data['senderUid'].toString())
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
                    controller: textController,
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

  void sendMessage() {
    String text = textController.text;
    if (text.trim().length < 1) {
      return;
    }

    Map<String, dynamic> newMap = Map();
    newMap['msg'] = text;
    newMap['time'] = DateTime.now();
    newMap['senderUid'] = currentUserId;
    newMap['senderName'] = currentUserName;

    messageRef.add(newMap).then((value) {}).whenComplete(() {
      textController.text = '';
    });
  }
}

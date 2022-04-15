import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/chat_text_field.dart';
import 'package:chat_app/widgets/custom_circle_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';

class ChatScreen extends StatefulWidget {
  final String friendUid;
  final String friendName;
  final String chatRoomId;

  const ChatScreen({
    Key? key,
    required this.friendUid,
    required this.friendName,
    required this.chatRoomId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
  // State<ChatScreen> createState() => _ChatScreenState(friendUid, friendName);
}

class _ChatScreenState extends State<ChatScreen> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference messageRef;

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var chatRoomId1;
  var textController = TextEditingController();

  @override
  void initState() {
    firestore
        .collection('chats')
        .where('users',
            isEqualTo: {widget.friendUid: null, currentUserId: null})
        //.where(widget.chatRoomId)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
          firestore.collection('chats').doc(widget.chatRoomId).set({
            'users': {currentUserId: null, widget.friendUid: null},
            'names': {
              currentUserId: FirebaseAuth.instance.currentUser?.displayName,
              widget.friendUid: widget.friendName
            }
          });
          //print('chatDocId: ${querySnapshot.docs.single.id}');
          setState(() {
            chatRoomId1 = querySnapshot.docs.single.id;
          });
        })
        .catchError((error) {});

    messageRef = firestore.collection('chats');

    //print('name: ${FirebaseAuth.instance.currentUser?.displayName}');
    //print('friend: ${widget.friendName}');

    super.initState();
  }

  bool isSender(String friend) {
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
            widget.friendName,
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
                  stream: messageRef
                      .doc(chatRoomId1)
                      //.doc(widget.chatRoomId)
                      .collection('messages')
                      .orderBy('createdOn', descending: true)
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper5(
                                  radius: 25,
                                  secondRadius: 2,
                                  type: isSender(data['uid'].toString())
                                      ? BubbleType.sendBubble
                                      : BubbleType.receiverBubble),
                              alignment: getAlignment(data['uid'].toString()),
                              margin: const EdgeInsets.only(
                                top: 20,
                              ),
                              backGroundColor: isSender(data['uid'].toString())
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
                                      data['msg'],
                                      style: Styles.defaultTextStyle.copyWith(
                                          color:
                                              isSender(data['uid'].toString())
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
                                          color:
                                              isSender(data['uid'].toString())
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
    if (text.trim().length > 1) {
      Map<String, dynamic> messages = {
        'createdOn': FieldValue.serverTimestamp(),
        'uid': currentUserId,
        'friendName': widget.friendName,
        'friendUid': widget.friendUid.toString(),
        'msg': text
      };

      messageRef
          .doc(chatRoomId1)
          .collection('messages')
          .add(messages)
          .then((value) {})
          .whenComplete(() {
        textController.text = '';
      });
    } else {
      //print('Enter some text');
    }
  }
}

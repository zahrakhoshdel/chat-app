// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/avatar.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  String fullname;
  String sub;
  String url;
  VoidCallback onTapped;
  UserCard(
      {Key? key,
      required this.fullname,
      required this.sub,
      this.url = Styles.imgProfile,
      required this.onTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(size.width * 0.03),
      child: InkWell(
        onTap: onTapped,
        child: Row(
          children: [
            Avatar(
              height: size.width * 0.1,
              width: size.width * 0.1,
              url: url,
              isOnline: true,
            ),
            SizedBox(width: size.width * 0.02),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullname,
                  style: Styles.titleStyle,
                ),
                const SizedBox(height: 2.0),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.subtitleStyle,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  String title;
  VoidCallback onTapped;
  GroupCard({Key? key, required this.onTapped, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTapped,
      child: Container(
        padding: EdgeInsets.all(size.width * 0.02),
        child: Row(
          children: [
            const CircleAvatar(
              child: Icon(
                Icons.group,
                color: Colors.white,
                size: 45,
              ),
              backgroundColor: Styles.fourthColor,
              radius: 40,
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
            Text(
              title,
              style:
                  Styles.defaultTextStyle.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

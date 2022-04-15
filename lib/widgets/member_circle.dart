// ignore_for_file: must_be_immutable

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class MemberCircle extends StatelessWidget {
  String name;
  VoidCallback onTaped;
  MemberCircle({Key? key, required this.onTaped, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: size.width * 0.02, left: size.width * 0.03),
      child: InkWell(
        onTap: onTaped,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Styles.secondaryColor,
                  foregroundColor: Colors.white,
                  // backgroundImage: AssetImage('assets/ff7.jpg'),
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      //size: 50,
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                name,
                style: Styles.subtitleStyle,
              ),
            ),
            // SizedBox(
            //   width: size.width * 0.01,
            //   child: Center(
            //     child: Text(name),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

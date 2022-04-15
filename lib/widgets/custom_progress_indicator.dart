import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double width;
  final double height;

  const CustomProgressIndicator(
      {Key? key, this.width = 14.0, this.height = 14.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
          color: Styles.backgroundSecondary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Styles.darkShadow,
                blurRadius: 2.0,
                spreadRadius: 0,
                offset: Offset(1, 1))
          ]),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

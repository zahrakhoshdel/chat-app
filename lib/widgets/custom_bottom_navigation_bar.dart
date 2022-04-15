// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

library lamp_bottom_navigation;

import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final double iconSize, width;
  final List<IconData> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavigationBar({
    this.iconSize = 25,
    this.items = const <IconData>[],
    required this.width,
    required this.onTap,
    this.currentIndex = 0,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  int oldIndex = 0;
  late AnimationController _controller;
  late double width;

  @override
  initState() {
    super.initState();
    _resetState();
  }

  _resetState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );
    _controller.forward();
    width = widget.width;
  }

  _buildNavigationTile() {
    var tiles = <Widget>[];
    for (int i = 0; i < widget.items.length; i++) {
      tiles.add(
        InkWell(
          onTap: () {
            if (widget.onTap != null) widget.onTap(i);
          },
          child: LampNavigationBarTile(
            key: UniqueKey(),
            iconSize: widget.iconSize,
            icon: widget.items[i],
            active: i == widget.currentIndex,
            wasActive: i == oldIndex,
            animation: _controller,
            onTap: () {},
          ),
        ),
      );
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          builder: (_, w) {
            return SizedBox(
              height: size.height * 0.2,
              width: width,
              child: CustomPaint(
                foregroundPainter: _SelectedTilePainter(
                    iconSize: widget.iconSize * 3,
                    newPosition: widget.currentIndex,
                    oldPosition: oldIndex,
                    progress: Tween<double>(begin: 0.0, end: 1.0)
                        .animate(CurvedAnimation(
                            parent: _controller,
                            curve: const Interval(0.0, 0.5,
                                curve: Curves.easeInOut)))
                        .value,
                    count: widget.items.length),
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[..._buildNavigationTile()],
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class LampNavigationBarTile extends StatelessWidget {
  final IconData icon;
  final bool active, wasActive;
  final double iconSize;
  final Animation<double> animation;
  final VoidCallback onTap;

  LampNavigationBarTile({
    Key? key,
    required this.icon,
    required this.animation,
    this.iconSize = 30,
    required this.onTap,
    this.active = false,
    this.wasActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.1,
      width: iconSize + size.width * 0.02,
      child: Stack(
        children: <Widget>[
          Center(
            child: Icon(
              icon,
              size: iconSize,
              color: active ? Colors.white : Styles.fourthColor,
            ),
          ),
          FadeTransition(
            opacity: ((active)
                ? Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.6, 1, curve: Curves.easeInOut)),
                  )
                : Tween<double>(begin: 1, end: 0).animate(
                    CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0, 0.4, curve: Curves.easeInOut)),
                  )),
            // child: CustomPaint(
            //   foregroundPainter: _LightLampPainter(
            //     active: active || wasActive,
            //   ),
            // ),
          )
        ],
      ),
    );
  }
}

class _SelectedTilePainter extends CustomPainter {
  _SelectedTilePainter({
    required this.oldPosition,
    required this.newPosition,
    required this.progress,
    required this.count,
    this.iconSize = 24,
    this.color = Colors.white,
  }) {
    assert(progress != null);
  }

  final int oldPosition, newPosition, count;
  final double iconSize;
  final Color color;
  final double progress;

  Offset startOffset(Size size) {
    var freeSpace = (size.width / count) - iconSize;
    assert(freeSpace >= 0);
    return Offset(
        freeSpace / 2 +
            (freeSpace + iconSize) *
                (oldPosition * (1 - progress) + newPosition * progress),
        1);
  }

  Offset endOffset(Size size) {
    var freeSpace = (size.width / count) - iconSize;
    assert(freeSpace >= 0);
    return Offset(
        freeSpace / 2 +
            (freeSpace + iconSize) *
                (oldPosition * (1 - progress) + newPosition * progress) +
            iconSize,
        1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var p = Paint()
      ..color = this.color
      ..strokeWidth = 3;
    canvas.drawLine(startOffset(size), endOffset(size), p);
  }

  @override
  bool shouldRepaint(_SelectedTilePainter oldDelegate) => true;
}

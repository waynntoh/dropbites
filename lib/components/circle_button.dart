import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class CircleButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color bgColor;
  final Function onTap;

  CircleButton(
      {@required this.child,
      @required this.onTap,
      @required this.color,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        boxShadow: [kButtonShadow],
        color: bgColor != null ? bgColor : Colors.white,
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: child,
          color: color,
          onPressed: onTap,
        ),
      ),
    );
  }
}

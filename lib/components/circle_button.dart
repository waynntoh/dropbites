import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class CircleButton extends StatelessWidget {
  final Icon icon;
  final Function onTap;
  final Color color;

  CircleButton(
      {@required this.icon, @required this.onTap, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90), boxShadow: [kButtonShadow]),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: icon,
          color: color,
          onPressed: onTap,
        ),
      ),
    );
  }
}

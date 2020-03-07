import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.color, this.text, @required this.onPressed, this.width});

  final Color color;
  final String text;
  final Function onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      color: color,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: width ?? 168,
        height: 42.0,
        child: Text(text),
      ),
    );
  }
}

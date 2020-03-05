import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.color, this.text, @required this.onPressed});

  final Color color;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      color: color,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 168,
        height: 42.0,
        child: Text(text),
      ),
    );
  }
}

import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xFFF4F3ED);
const kOrange0 = Color(0xFFFDEBD0);
const kOrange1 = Color(0xFFFAD7A0);
const kOrange2 = Color(0xFFF8C471);
const kOrange3 = Color(0xFFF5B041);
const kOrange4 = Color(0xFFF39C12);
const kOrange5 = Color(0xFFD68910);

const kButtonTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  fontFamily: 'Dekko',
);

const kSplashScreenTextStyle = TextStyle(
  fontSize: 55,
  fontWeight: FontWeight.w900,
  letterSpacing: 1.25,
  fontFamily: 'Dekko',
);

const kTextFieldDecoration = InputDecoration(
  hintText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kOrange3, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kOrange4, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

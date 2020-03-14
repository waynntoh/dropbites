import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const kBackgroundColor = Color(0xFFF4F3ED);
const kOrange0 = Color(0xFFFDEBD0);
const kOrange1 = Color(0xFFFAD7A0);
const kOrange2 = Color(0xFFF8C471);
const kOrange3 = Color(0xFFF5B041);
const kOrange4 = Color(0xFFF39C12);
const kOrange5 = Color(0xFFD68910);
const kOrange6 = Color(0xFFCA6F1E);

const kGrey0 = Color(0xFFECECEC);
const kGrey1 = Color(0xFFBBBBBB);
const kGrey2 = Color(0xFF9A9A9A);
const kGrey3 = Color(0xFF9A9A9A);
const kGrey4 = Color(0xFF6B6B6B);
const kGrey5 = Color(0xFF4C4C4C);
const kGrey6 = Color(0xFF2C2C2C);

const kCardColors = [
  Color(0xFFFFEBEB),
  Color(0xFFFFFEEB),
  Color(0xFFF1FFEB),
  Color(0xFFEBFFFB),
  Color(0xFFEBF0FF),
  Color(0xFFF9EBFF),
  Color(0xFFFFEBF3),
];

const kButtonShadow = BoxShadow(
  color: kGrey0,
  blurRadius: 1,
  spreadRadius: 1,
  offset: Offset(2, 2.5),
);

const kItemCardShadow = BoxShadow(
  color: kGrey1,
  blurRadius: 3,
  spreadRadius: 2,
  offset: Offset(2, 2.5),
);

const kSpinKitWave = SpinKitWave(
  color: kOrange4,
  itemCount: 5,
  type: SpinKitWaveType.center,
  size: 70,
);

Widget kSpinKitHybrid = Stack(
  children: <Widget>[
    SpinKitFadingCircle(
      color: kOrange5,
      size: 70,
    ),
    SpinKitDoubleBounce(
      color: kOrange0,
      size: 30,
    ),
  ],
);

const kButtonTextStyle = TextStyle(
  fontFamily: 'Slabo',
  fontSize: 18,
);

const kDefaultTextStyle = TextStyle(
  fontFamily: 'Slabo',
  fontSize: 16,
);

const kSplashScreenTextStyle = TextStyle(
  fontSize: 55,
  fontFamily: 'Slabo',
  color: kGrey5,
);

const kCardTitleTextStyle = TextStyle(
    fontSize: 22,
    fontFamily: 'Slabo',
    fontWeight: FontWeight.w900,
    color: kGrey5);

const kMainMenuTitleTextStyle = TextStyle(fontSize: 20, fontFamily: 'Slabo');

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

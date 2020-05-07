import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// COLORS
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
  Color(0xFFFFF0F0),
  Color(0xFFFFFDF0),
  Color(0xFFF8FFF0),
  Color(0xFFF0FFF8),
  Color(0xFFF0FAFF),
  Color(0xFFF8F0FF),
  Color(0xFFFFF0F2),
];

// SHADOWS
const kButtonShadow = BoxShadow(
  color: kGrey1,
  blurRadius: 1,
  spreadRadius: 1,
  offset: Offset(2, 2.5),
);

const kItemCardShadow = BoxShadow(
  color: kGrey1,
  blurRadius: 2,
  spreadRadius: 1,
  offset: Offset(1, 1.5),
);

const kItemCardTitleShadow = BoxShadow(
  color: kGrey4,
  blurRadius: 1,
  spreadRadius: .1,
  offset: Offset(0, 1),
);

// SPINKITS
Widget kSpinKitLoader = SpinKitWave(
  type: SpinKitWaveType.center,
  color: kOrange2,
  size: 100,
);

// TEXTSTYLES
const kButtonTextStyle = TextStyle(
  fontFamily: 'Slabo',
  fontSize: 18,
);

const kDefaultTextStyle = TextStyle(
  fontFamily: 'Slabo',
  fontSize: 16,
);

const kNumeralTextStyle = TextStyle(
  fontFamily: 'Rokkitt',
  fontSize: 20,
);

const kSplashScreenTextStyle = TextStyle(
  fontSize: 55,
  fontFamily: 'Slabo',
  color: kGrey5,
);

const kCardTitleTextStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'Slabo',
  color: Colors.black,
);

const kMainMenuTitleTextStyle = TextStyle(
  fontSize: 20,
  fontFamily: 'Slabo',
);

// TEXTFIELD DECORATIONS
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
    borderSide: BorderSide(color: kOrange4, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);

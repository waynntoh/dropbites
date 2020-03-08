import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class CustomSnackbar {
  static void showSnackbar(
      {@required String text,
      @required GlobalKey<ScaffoldState> scaffoldKey,
      IconData iconData}) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  iconData,
                  color: kOrange3,
                ),
                SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(color: kOrange3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

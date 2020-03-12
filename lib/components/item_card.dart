import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class ItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24, right: 36, bottom: 24),
      height: 360,
      width: 240,
      decoration: BoxDecoration(
        boxShadow: [kItemCardShadow],
        gradient: LinearGradient(
            colors: [kGrey0, Colors.white],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft),
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/d1.jpg'),
        ),
      ),
    );
  }
}

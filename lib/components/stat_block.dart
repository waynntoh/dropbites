import 'package:drop_bites/utils/constants.dart';
import 'package:flutter/material.dart';

class StatBlock extends StatelessWidget {
  final String title;
  final String data;
  final IconData iconData;
  final Color color;

  StatBlock(
      {@required this.title,
      @required this.data,
      @required this.iconData,
      @required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 45,
            color: color,
          ),
          SizedBox(height: 12),
          Text(
            data,
            style: kNumeralTextStyle.copyWith(fontSize: 24, color: kGrey5),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: kDefaultTextStyle.copyWith(fontSize: 15, color: kGrey3),
          ),
        ],
      ),
    );
  }
}

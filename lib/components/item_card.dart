import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class ItemCard extends StatelessWidget {
  final double cardWidth = 240;
  final double cardHeight = 360;
  final String price;
  final Color color;

  ItemCard({@required this.price, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      width: 290,
      child: Stack(
        children: <Widget>[
          Positioned(
            height: 360,
            width: 240,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [kItemCardShadow],
                gradient: LinearGradient(
                    colors: [kGrey1, Colors.white],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft),
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('images/d1.jpg'),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 28,
            height: 60,
            width: 80,
            child: Container(
              child: Center(
                child: Text(
                  '\$$price',
                  style: kCardTitleTextStyle,
                  textAlign: TextAlign.start,
                ),
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kGrey3,
                    blurRadius: 1,
                    spreadRadius: 1,
                    offset: Offset(1, 1),
                  )
                ],
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

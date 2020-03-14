import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class ItemCard extends StatelessWidget {
  final double cardWidth = 160;
  final double cardHeight = 120;
  final String price;
  final Color color;

  ItemCard({@required this.price, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 24),
          height: 360,
          width: 240,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Rainbow Macaron'),
            Text('\$8'),
          ],
        )
      ],
    );
  }
}

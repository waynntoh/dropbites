import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class ItemCard extends StatelessWidget {
  final double cardWidth = 240;
  final double cardHeight = 360;
  final String price;
  final Color color;
  final int rating;

  ItemCard({@required this.price, @required this.rating, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 2,
            top: 32,
            height: 360,
            width: 240,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [kItemCardShadow],
                gradient: LinearGradient(
                    colors: [kGrey1, Colors.white],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('images/d1.jpg'),
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 64,
            height: 120,
            width: 200,
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Rainbow Macaron',
                    style: kCardTitleTextStyle.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$$price.00',
                    style: kCardTitleTextStyle.copyWith(
                      color: kOrange3,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: _buildRatings(),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                boxShadow: [kItemCardTitleShadow],
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildRatings() {
    List<Widget> stars = [];

    for (int i = 0; i < 5; i++) {
      (i < rating)
          ? stars.add(
              Icon(
                Icons.star,
                color: kOrange3,
              ),
            )
          : stars.add(
              Icon(
                Icons.star,
                color: kOrange1,
              ),
            );
    }
    return stars;
  }
}

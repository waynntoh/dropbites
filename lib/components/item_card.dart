import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String price;
  final Color color;
  final int rating;

  ItemCard(
      {@required this.price,
      @required this.rating,
      @required this.title,
      this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add to cart on item
        print('Add $title to cart');
      },
      child: SizedBox(
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
              bottom: 54,
              height: 130,
              width: 200,
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      title,
                      style: kCardTitleTextStyle.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      '\$$price.00',
                      style: kCardTitleTextStyle.copyWith(
                        color: kOrange3,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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

// ADD TO CART
// Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       Icon(
//                         Icons.remove_circle_outline,
//                         size: 40,
//                         color: kGrey5,
//                       ),
//                       SizedBox(width: 24),
//                       Icon(
//                         Icons.add_circle_outline,
//                         size: 40,
//                         color: kGrey5,
//                       ),
//                     ],
//                   ),

import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/utils/item.dart';
import 'package:drop_bites/views/item_view.dart';
import 'package:drop_bites/components/rating_stars.dart';

class ItemCard extends StatelessWidget {
  final Color color;
  final Item item;

  ItemCard({@required this.item, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemView(
              item: item,
            ),
          ),
        );
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
                    image: NetworkImage(
                        'http://hackanana.com/dropbites/product_images/${item.id}.jpg'),
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
                      item.name,
                      style: kCardTitleTextStyle,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: kCardTitleTextStyle.copyWith(
                        fontWeight: FontWeight.w900,
                        color: kGrey5,
                      ),
                    ),
                    RatingStars(rating: item.rating),
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
}

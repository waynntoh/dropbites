import 'package:cached_network_image/cached_network_image.dart';
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl:
                        'http://hackanana.com/dropbites/product_images/${item.id}.jpg',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => kLargeImageLoader,
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
                decoration: BoxDecoration(
                  boxShadow: [kItemCardTitleShadow],
                  gradient: LinearGradient(
                      colors: [Colors.white, color],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      item.name,
                      style: kDefaultTextStyle.copyWith(fontSize: 21),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: kNumeralTextStyle.copyWith(
                        fontWeight: FontWeight.w900,
                        color: kGrey5,
                      ),
                    ),
                    RatingStars(rating: item.rating),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:drop_bites/components/rating_stars.dart';
import 'package:drop_bites/utils/item.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/circle_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemView extends StatefulWidget {
  final Item item;

  ItemView({@required this.item});

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  int itemCount = 1;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: Container(
              height: height / 2,
              width: width,
              padding:
                  EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 36),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [kItemCardShadow],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.item.name,
                            style: kDefaultTextStyle.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '\$${widget.item.price.toStringAsFixed(2)}',
                            style: kDefaultTextStyle.copyWith(
                                fontSize: 24,
                                color: kOrange4,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.item.description,
                        textAlign: TextAlign.justify,
                        style: kDefaultTextStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.local_shipping,
                                size: 28,
                                color: kGrey1,
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Standard Delivery',
                                style: kDefaultTextStyle.copyWith(
                                  color: kGrey4,
                                ),
                              ),
                            ],
                          ),
                          RatingStars(rating: widget.item.rating),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                                boxShadow: [kButtonShadow]),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.remove,
                                        size: 32, color: kGrey4),
                                    onPressed: () {
                                      setState(() {
                                        (itemCount > 1)
                                            ? itemCount--
                                            : itemCount = itemCount;
                                      });
                                    }),
                                SizedBox(
                                  width: .5,
                                  height: 25,
                                  child: VerticalDivider(
                                    thickness: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 48,
                                  child: Center(
                                    child: Text(itemCount.toString(),
                                        style: kDefaultTextStyle.copyWith(
                                            color: kOrange3, fontSize: 32)),
                                  ),
                                ),
                                SizedBox(
                                  width: .5,
                                  height: 25,
                                  child: VerticalDivider(
                                    thickness: 2,
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.add,
                                        size: 32, color: kGrey4),
                                    onPressed: () {
                                      setState(() {
                                        itemCount++;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                                width: 170,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: kOrange2,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    boxShadow: [kButtonShadow]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FaIcon(
                                      FontAwesomeIcons.cartPlus,
                                      color: kGrey6,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Add To Cart',
                                      style: kDefaultTextStyle.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                )),
                            onTap: () {
                              // TODO: add to cart
                              print('add to cart');
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              height: height / 2 + 40,
              width: width,
              decoration: BoxDecoration(
                boxShadow: [kItemCardShadow],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'http://hackanana.com/dropbites/product_images/${widget.item.id}.jpg'),
                ),
              ),
            ),
          ),
          Positioned(
            top: 36,
            left: 24,
            child: CircleButton(
              color: kOrange3,
              icon: Icon(Icons.arrow_back_ios),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

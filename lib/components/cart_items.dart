import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drop_bites/utils/item.dart';

class CartItems extends StatefulWidget {
  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height / 1.55,
      width: width,
      padding: EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'My Cart',
                style: kSplashScreenTextStyle.copyWith(
                    fontWeight: FontWeight.w900, fontSize: 36),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.solidTrashAlt),
                onPressed: () {
                  // TODO: Toggle delete
                  print('Toggle delete');
                },
              ),
            ],
          ),
          SizedBox(height: 24),
          SizedBox(
            height: height / 2.1,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                Item item = Item();
                item.setId('d1');
                item.setName('Rainbow Macaron');
                item.setPrice(8);
                return _buildCartItem(item, 2, width);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Item item, int count, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.only(right: 8, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'http://hackanana.com/dropbites/product_images/${item.id}.jpg'),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.name,
                    style: kDefaultTextStyle.copyWith(fontSize: 20),
                  ),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: kDefaultTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: kOrange5),
                  ),
                ],
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: kGrey0,
            foregroundColor: kGrey6,
            child: Text(
              'x$count',
              style: kDefaultTextStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          )
        ],
      ),
    );
  }
}

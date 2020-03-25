import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class CartItem extends StatefulWidget {
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                    image: AssetImage('images/d1.jpg'),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Rainbow Macaron',
                    style: kDefaultTextStyle.copyWith(fontSize: 20),
                  ),
                  Text(
                    '\$8.00',
                    style: kDefaultTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: kOrange5
                    ),
                  ),
                ],
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: kGrey0,
            foregroundColor: kGrey6,
            child: Text(
              'x1',
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

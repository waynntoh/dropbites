import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class CartView extends StatefulWidget {
  static const String id = 'cart_view';
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey6,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 650,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 12, right: 16, top: 36),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.keyboard_backspace,
                          color: kGrey3,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'My Cart',
                        style: kDefaultTextStyle.copyWith(fontSize: 19),
                      ),
                      SizedBox(width: 36)
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              print('Checkout');
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Proceed to ',
                              style: kCardTitleTextStyle.copyWith(
                                  color: kGrey1, letterSpacing: .5),
                            ),
                            TextSpan(
                              text: 'Checkout',
                              style: kCardTitleTextStyle.copyWith(
                                  color: kGrey0,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .5),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  CircleAvatar(
                    backgroundColor: kOrange3,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: kGrey6,
                      size: 24,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/circle_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drop_bites/components/cart_item.dart';

class CartView extends StatefulWidget {
  static const String id = 'cart_view';
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kGrey6,
      body: Stack(
        children: <Widget>[
          // White Background
          Positioned(
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  )),
              height: height - height / 8.5,
              width: width,
            ),
          ),
          // Bottom Checkout buttons
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                // TODO: Checkout
                print('Checkout');
              },
              child: Container(
                width: width,
                height: height / 8.5,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Center(
                      child: RichText(
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
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: kGrey6,
                        height: 30,
                      ),
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
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: CircleButton(
              color: kOrange3,
              icon: Icon(Icons.arrow_back_ios),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Title + Toggle delete + Listview
          Positioned(
            top: 90,
            child: Container(
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
                        return CartItem();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Total Price
          Positioned(
            bottom: 90,
            child: Container(
              width: width,
              height: height / 8.5,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Center(
                    child: Text(
                      '2 items',
                      style: kDefaultTextStyle.copyWith(
                          fontSize: 20, color: kGrey3),
                    ),
                  ),
                  Center(
                    child: Text(
                      '\$32.00',
                      style: kDefaultTextStyle.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

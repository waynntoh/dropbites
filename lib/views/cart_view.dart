import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/circle_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:drop_bites/utils/cart.dart';
import 'package:drop_bites/utils/item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartView extends StatefulWidget {
  static const String id = 'cart_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  final String email;

  CartView({@required this.email});
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool deletable = false;
  List cartItems = [];
  Cart cart = Cart();
  double totalPrice = 0;
  int totalItems = 0;
  bool loading = false;
  double loadingOpacity = 1;

  String getCartURL = 'http://hackanana.com/dropbites/php/get_cart.php';
  String deleteItemURL =
      'http://hackanana.com/dropbites/php/delete_from_cart.php';

  void _getCartItems() async {
    // Start loading spinkit & block taps
    setState(() {
      loading = true;
      loadingOpacity = .5;
    });

    http.post(getCartURL, body: {
      'email': widget.email,
    }).then((res) {
      if (res.body != 'Cart Empty') {
        setState(() {
          var extractdata = json.decode(res.body);
          cartItems = extractdata["cart"];
          totalItems = 0;
          totalPrice = 0;
          cart.clear();

          // Create a cart
          for (var cartItem in cartItems) {
            // Create new item
            Item newItem = Item();
            newItem.setId(cartItem['id']);
            newItem.setName(cartItem['name']);
            newItem.setPrice(double.parse(cartItem['price']));
            newItem.setRating(double.parse(cartItem['rating']));
            newItem.setType(cartItem['type']);
            newItem.setDescription(cartItem['description']);

            cart.add(newItem, int.parse(cartItem['product_count']),
                double.parse(cartItem['subtotal']));

            // Get summary
            totalPrice += double.parse(cartItem['subtotal']);
            totalItems += int.parse(cartItem['product_count']);
          }
        });
      }
      // Start loading spinkit & block taps
      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
    }).catchError((e) {
      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
      print(e);
    });
  }

  void _deleteCartItem(Item item) {
    CartView.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.delete_outline,
                  color: kOrange3,
                ),
                SizedBox(width: 8),
                Text(
                  'Discard item?',
                  style: TextStyle(color: kOrange3),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  color: kOrange0,
                  child: Text(
                    'No',
                    style: kDefaultTextStyle.copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    CartView.scaffoldKey.currentState.hideCurrentSnackBar();
                  },
                ),
                SizedBox(width: 16),
                FlatButton(
                  color: kOrange3,
                  child: Text(
                    'Discard',
                    style: kDefaultTextStyle.copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    // Hide Snackbar
                    CartView.scaffoldKey.currentState.hideCurrentSnackBar();

                    setState(() {
                      loading = true;
                      loadingOpacity = .5;
                    });
                    http.post(deleteItemURL, body: {
                      'email': widget.email,
                      'product_id': item.id,
                    }).then((res) {
                      setState(() {
                        _getCartItems();
                        loading = false;
                        loadingOpacity = 1;
                      });
                      print(totalPrice);
                    }).catchError((e) {
                      print(e);
                      setState(() {
                        _getCartItems();
                        loading = false;
                        loadingOpacity = 1;
                      });
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
    // Start loading spinkit & block taps
  }

  void _toggleDelete() {
    setState(() {
      deletable = !deletable;
    });
  }

  @override
  void initState() {
    _getCartItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: CartView.scaffoldKey,
      backgroundColor: kGrey6,
      body: AbsorbPointer(
        absorbing: loading,
        child: Opacity(
          opacity: loadingOpacity,
          child: Stack(
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
                    setState(() {
                      print(totalItems);
                      print(totalPrice);
                    });
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
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // Title + Toggle delete + Listview
              Positioned(
                top: 90,
                child: _buildCart(height, width),
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
                          '$totalItems items',
                          style: kNumeralTextStyle.copyWith(
                              fontSize: 24, color: kGrey3),
                        ),
                      ),
                      Center(
                        child: Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: kNumeralTextStyle.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (loading) ? kSpinKitLoader : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCart(double height, double width) {
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
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    boxShadow: deletable ? null : [kButtonShadow]),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: kGrey0,
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.solidTrashAlt,
                      color: deletable ? Colors.redAccent : kGrey6,
                    ),
                    color: deletable ? Colors.red : kGrey6,
                    onPressed: () {
                      _toggleDelete();
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          // Listview
          SizedBox(
            height: height / 2.1,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                List<Map> maps = cart.items;
                return _buildCartItem(
                    maps[index]['item'], maps[index]['count'], width);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Item item, int count, double width) {
    return Container(
      height: 120,
      width: width,
      padding: EdgeInsets.only(bottom: 0),
      child: Stack(
        children: <Widget>[
          Positioned(
            width: width - 48,
            bottom: 20,
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
                        boxShadow: [kItemCardShadow],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'http://hackanana.com/dropbites/product_images/${item.id}.jpg'),
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: kDefaultTextStyle.copyWith(fontSize: 20),
                        ),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: kNumeralTextStyle.copyWith(
                            fontWeight: FontWeight.w900,
                            color: kOrange5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '\$${(item.price * count).toStringAsFixed(2)}',
                  style: kNumeralTextStyle.copyWith(
                      fontSize: 21, fontWeight: FontWeight.w900, color: kGrey5),
                ),
              ],
            ),
          ),
          Positioned(
            left: 64,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  boxShadow: [kItemCardShadow]),
              child: CircleAvatar(
                backgroundColor: deletable ? Colors.redAccent[200] : kOrange0,
                foregroundColor: kGrey6,
                child: deletable
                    ? GestureDetector(
                        child: Icon(
                          Icons.delete_forever,
                          color: kGrey6,
                          size: 30,
                        ),
                        onTap: () {
                          _deleteCartItem(item);
                        },
                      )
                    : RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'x',
                              style: kDefaultTextStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: kGrey6
                              ),
                            ),
                            TextSpan(
                              text: count.toString(),
                              style: kNumeralTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: kGrey6
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:drop_bites/utils/order.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/views/location_view.dart';
import 'package:drop_bites/views/reload_view.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/circle_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:drop_bites/utils/cart.dart';
import 'package:drop_bites/utils/item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  static const String id = 'cart_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  final String email;
  final double credits;
  final Function onPlacedOrder;

  CartView(
      {@required this.email,
      @required this.credits,
      @required this.onPlacedOrder});
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
  bool locationSet = false;
  String address;
  String getCartURL = 'http://hackanana.com/dropbites/php/get_cart.php';
  String deleteItemURL =
      'http://hackanana.com/dropbites/php/delete_from_cart.php';
  String editUserUrl = 'http://hackanana.com/dropbites/php/edit_user.php';
  String addOrderUrl = 'http://hackanana.com/dropbites/php/add_order.php';

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
      // Stop loading spinkit & block taps
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

                        // Set local variable to 0 when last item is deleted for UI to reset
                        if (totalItems == 1) {
                          totalItems = 0;
                          _toggleDelete();
                        }

                        loading = false;
                        loadingOpacity = 1;
                      });
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
  }

  void _toggleDelete() {
    setState(() {
      deletable = !deletable;
    });
  }

  void _toggleLocationSet() {
    setState(() {
      locationSet = !locationSet;
    });
  }

  void _navigateToLocationView(BuildContext context) async {
    address = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationView(toggler: _toggleLocationSet),
      ),
    );
  }

  void _clearCart() async {
    http.post(deleteItemURL, body: {
      'email': widget.email,
      'clear': 'clear all',
    }).then((res) {
      setState(() {
        _getCartItems();
        loading = false;
        loadingOpacity = 1;
      });
    }).catchError((e) {
      print(e);
      setState(() {
        _getCartItems();
        loading = false;
        loadingOpacity = 1;
      });
    });
  }

  void _deductCredits() async {
    double newAmount = widget.credits - totalPrice;

    http.post(editUserUrl, body: {
      "email": widget.email,
      "col": 'credits',
      "new_data": newAmount.toString(),
    }).then((res) {
      setState(() {
        _getCartItems();
        loading = false;
        loadingOpacity = 1;
      });
    }).catchError((e) {
      print(e);
      setState(() {
        _getCartItems();
        loading = false;
        loadingOpacity = 1;
      });
    });
  }

  void _addCartToOrder() async {
    // Get all items => Order object
    Order newOrder = new Order();
    newOrder.initialize(
      orderID: null,
      email: widget.email,
      address: address,
      orderDate: null,
      items: cart.items,
    );

    String itemsData = json.encode(newOrder);

    // Pass to PHP
    http.post(
      addOrderUrl,
      body: {
        "email": widget.email,
        "order_id": newOrder.orderID,
        "items_data": itemsData,
        "items_count": totalItems.toString(),
        "total": totalPrice.toString(),
        "address": address,
      },
    ).then(
      (res) {
        if (res.body == "Added Successfully") {
          Navigator.pop(context);
          widget.onPlacedOrder(widget.email);
        } else {
          CustomSnackbar.showSnackbar(
              text: 'Order Failed',
              scaffoldKey: CartView.scaffoldKey,
              iconData: Icons.error);
        }
      },
    ).catchError(
      (err) {
        setState(() {
          loading = false;
          loadingOpacity = 1;
        });
        print(err);
      },
    );
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
    final loggedInUser = Provider.of<User>(context, listen: false);

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
                    ),
                  ),
                  height: height - height / 8.5,
                  width: width,
                ),
              ),
              // Bottom Checkout buttons
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    // Check for sufficient credits
                    if (locationSet) {
                      if (loggedInUser.credits > totalPrice) {
                        CartView.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 10),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.fastfood,
                                      color: kOrange3,
                                      size: 28,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Place Order?',
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
                                        style: kDefaultTextStyle.copyWith(
                                            color: Colors.black),
                                      ),
                                      onPressed: () {
                                        // Hide Snackbar
                                        CartView.scaffoldKey.currentState
                                            .hideCurrentSnackBar();
                                      },
                                    ),
                                    SizedBox(width: 16),
                                    FlatButton(
                                      color: kOrange3,
                                      child: Text(
                                        'Yes',
                                        style: kDefaultTextStyle.copyWith(
                                            color: Colors.black),
                                      ),
                                      onPressed: () {
                                        // Clear cart
                                        _clearCart();
                                        // Deduct credits + object
                                        _deductCredits();
                                        loggedInUser.setCredit(
                                            loggedInUser.credits - totalPrice);
                                        // Add order to database
                                        _addCartToOrder();
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        CartView.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 10),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.error,
                                      color: kOrange3,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Insufficient Credits',
                                      style: TextStyle(color: kOrange3),
                                    ),
                                  ],
                                ),
                                FlatButton(
                                  color: kOrange3,
                                  child: Text(
                                    'Reload',
                                    style: kDefaultTextStyle.copyWith(
                                        color: Colors.black),
                                  ),
                                  onPressed: () {
                                    CartView.scaffoldKey.currentState
                                        .hideCurrentSnackBar();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReloadView(
                                            email: loggedInUser.email),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      if (cartItems.length == 0) {
                        CustomSnackbar.showSnackbar(
                          text: 'Cart Empty',
                          scaffoldKey: CartView.scaffoldKey,
                          iconData: Icons.error,
                        );
                      } else {
                        _navigateToLocationView(context);
                      }
                    }
                    setState(() {
                      deletable = false;
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
                                  text: locationSet ? 'Place ' : 'Set ',
                                  style: kCardTitleTextStyle.copyWith(
                                      color: kGrey1, letterSpacing: .5),
                                ),
                                TextSpan(
                                  text: locationSet ? 'Order' : 'Location',
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
                        Center(
                          child: locationSet
                              ? FaIcon(
                                  FontAwesomeIcons.arrowAltCircleRight,
                                  color: kOrange3,
                                  size: 45,
                                )
                              : Icon(
                                  Icons.edit_location,
                                  color: totalItems != 0 ? kOrange3 : kGrey4,
                                  size: 45,
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Top UI
              Positioned(
                width: width,
                top: 40,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircleButton(
                        color: kOrange3,
                        child: Icon(Icons.arrow_back_ios),
                        onTap: () {
                          if (locationSet) {
                            CartView.scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 10),
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.delete_outline,
                                          color: kOrange3,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Cancel Order?',
                                          style: TextStyle(color: kOrange3),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                          color: kOrange0,
                                          child: Text(
                                            'Yes',
                                            style: kDefaultTextStyle.copyWith(
                                                color: Colors.black),
                                          ),
                                          onPressed: () {
                                            CartView.scaffoldKey.currentState
                                                .hideCurrentSnackBar();
                                            Navigator.pop(context);
                                          },
                                        ),
                                        SizedBox(width: 16),
                                        FlatButton(
                                          color: kOrange3,
                                          child: Text(
                                            'No',
                                            style: kDefaultTextStyle.copyWith(
                                                color: Colors.black),
                                          ),
                                          onPressed: () {
                                            // Hide Snackbar
                                            CartView.scaffoldKey.currentState
                                                .hideCurrentSnackBar();
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      Text(
                        'My Cart',
                        style: kSplashScreenTextStyle.copyWith(
                            fontWeight: FontWeight.w900, fontSize: 30),
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
                ),
              ),
              // Listview
              Positioned(
                top: 90,
                child: totalItems != 0
                    ? _buildCart(height, width)
                    : Container(
                        width: width,
                        height: height / 1.5,
                        child: Center(
                          child: Text(
                            'Cart Empty',
                            style: kDefaultTextStyle.copyWith(
                              color: kOrange5,
                              fontSize: 22,
                            ),
                          ),
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
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '$totalItems',
                                style: kNumeralTextStyle.copyWith(
                                    fontSize: 24, color: kGrey4),
                              ),
                              TextSpan(
                                text: '  Items',
                                style: kDefaultTextStyle.copyWith(
                                    fontSize: 21, color: kGrey4),
                              )
                            ],
                          ),
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
      height: height / 1.65,
      width: width,
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          // Listview
          SizedBox(
            height: height / 1.75,
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
      height: 115,
      width: width,
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
              child: AnimatedCrossFade(
                firstChild: CircleAvatar(
                  backgroundColor: kOrange0,
                  foregroundColor: kGrey6,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'x',
                          style: kDefaultTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: kGrey6),
                        ),
                        TextSpan(
                          text: count.toString(),
                          style: kNumeralTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: kGrey6),
                        ),
                      ],
                    ),
                  ),
                ),
                secondChild: CircleAvatar(
                  backgroundColor: Colors.redAccent[200],
                  foregroundColor: kGrey6,
                  child: GestureDetector(
                    child: Icon(
                      Icons.delete_forever,
                      color: kGrey6,
                      size: 30,
                    ),
                    onTap: () {
                      _deleteCartItem(item);
                    },
                  ),
                ),
                crossFadeState: deletable
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

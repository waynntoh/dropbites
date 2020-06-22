import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:drop_bites/components/guest_drawer.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/components/user_drawer.dart';
import 'package:drop_bites/components/overhead_selector.dart';
import 'package:drop_bites/components/item_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:drop_bites/views/cart_view.dart';
import 'package:drop_bites/components/circle_button.dart';
import 'package:drop_bites/utils/item.dart';
import 'package:provider/provider.dart';
import 'package:drop_bites/utils/user.dart';

class MainMenuView extends StatefulWidget {
  static const String id = 'main_menu_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  List items = [];
  bool loading = false;
  double loadingOpacity = 1;
  String url = 'http://hackanana.com/dropbites/php/get_products.php';
  ScrollController scrollController = ScrollController();

  void onPlacedOrder(String email) {
    CustomSnackbar.showSnackbar(
      iconData: Icons.local_shipping,
      text: 'New order placed!',
      scaffoldKey: MainMenuView.scaffoldKey,
      duration: Duration(seconds: 5),
    );
  }

  void _getItems() async {
    setState(() {
      loading = true;
      loadingOpacity = .2;
    });
    http.post(url, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        items = extractdata["items"];
      });

      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
    }).catchError((e) {
      print(e);
      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
    });
  }

  void _sortItems(String type) {
    // Start loading spinkit & block taps
    setState(() {
      loading = true;
      loadingOpacity = .2;
    });

    if (type != null) {
      http.post(url, body: {
        "type": type,
      }).then((res) {
        setState(() {
          var extractdata = json.decode(res.body);
          items = extractdata["items"];
        });
        setState(() {
          scrollController.animateTo(
            scrollController.initialScrollOffset,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
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
    } else {
      _getItems();
    }
  }

  @override
  void initState() {
    _getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context, listen: false);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: MainMenuView.scaffoldKey,
        drawer: LoginView.isGuest
            ? GuestDrawer(showSnackbar: showGuestSnackbar)
            : UserDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 12, right: 16, top: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: kOrange3,
                      ),
                      onPressed: () {
                        MainMenuView.scaffoldKey.currentState.openDrawer();
                        MainMenuView.scaffoldKey.currentState
                            .hideCurrentSnackBar();
                      }),
                  CircleButton(
                    color: kOrange3,
                    child: Icon(Icons.shopping_cart),
                    onTap: () {
                      if (LoginView.isGuest) {
                        showGuestSnackbar();
                      } else {
                        MainMenuView.scaffoldKey.currentState
                            .hideCurrentSnackBar();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartView(
                              email: loggedInUser.email,
                              credits: loggedInUser.credits,
                              onPlacedOrder: onPlacedOrder,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 24, top: 12, right: 16),
                child: items.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Today\'s Deals',
                              style: kSplashScreenTextStyle.copyWith(
                                  fontWeight: FontWeight.w900, fontSize: 36),
                            ),
                            SizedBox(height: 20),
                            OverheadSelector(
                              sort: _sortItems,
                              selections: [
                                'All',
                                'Appetizers',
                                'Entrées',
                                'Beverages',
                                'Desserts'
                              ],
                              types: [
                                null,
                                'app',
                                'ent',
                                'bev',
                                'des',
                              ],
                            ),
                            SizedBox(height: 8),
                            Stack(
                              children: <Widget>[
                                AbsorbPointer(
                                  absorbing: loading,
                                  child: Opacity(
                                    opacity: loadingOpacity,
                                    child: SizedBox(
                                      height: 530,
                                      child: ListView.builder(
                                        controller: scrollController,
                                        physics: ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            items != null ? items.length : 0,
                                        itemBuilder: (context, index) {
                                          // Pass item object to item card widget
                                          Item newItem = Item();
                                          newItem.setId(items[index]['id']);
                                          newItem.setName(items[index]['name']);
                                          newItem.setPrice(double.parse(
                                              items[index]['price']));
                                          newItem.setRating(double.parse(
                                              items[index]['rating']));
                                          newItem.setType(items[index]['type']);
                                          newItem.setDescription(
                                              items[index]['description']);
                                          return ItemCard(
                                            item: newItem,
                                            color: kCardColors[index % 7],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  heightFactor: 4,
                                  child:
                                      (loading) ? kSpinKitLoader : Container(),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : null),
          ],
        ),
      ),
    );
  }

  void showGuestSnackbar() {
    MainMenuView.scaffoldKey.currentState.showSnackBar(
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
                  'Not Logged In',
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
                    MainMenuView.scaffoldKey.currentState.hideCurrentSnackBar();
                  },
                ),
                SizedBox(width: 16),
                FlatButton(
                  color: kOrange3,
                  child: Text(
                    'Login',
                    style: kDefaultTextStyle.copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    MainMenuView.scaffoldKey.currentState.hideCurrentSnackBar();
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

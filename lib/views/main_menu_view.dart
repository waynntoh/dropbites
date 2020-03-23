import 'package:drop_bites/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/components/custom_drawer.dart';
import 'package:drop_bites/components/overhead_selector.dart';
import 'package:drop_bites/components/item_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:drop_bites/views/cart_view.dart';
import 'package:drop_bites/components/circle_button.dart';
import 'package:drop_bites/utils/item.dart';

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
  String url = "http://hackanana.com/dropbites/php/get_products.php";

  void _loadItems() async {
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
      _loadItems();
    }
  }

  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: MainMenuView.scaffoldKey,
        drawer: CustomDrawer(),
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
                      color: kGrey3,
                    ),
                    onPressed: () =>
                        MainMenuView.scaffoldKey.currentState.openDrawer(),
                  ),
                  CircleButton(
                    color: kOrange3,
                    icon: Icon(Icons.shopping_cart),
                    onTap: () {
                      Navigator.pushNamed(context, CartView.id);
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
                                          newItem.setRating(int.parse(
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
}

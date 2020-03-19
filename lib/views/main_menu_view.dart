import 'package:drop_bites/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/components/custom_drawer.dart';
import 'package:drop_bites/components/overhead_selector.dart';
import 'package:drop_bites/components/item_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class MainMenuView extends StatefulWidget {
  static const String id = 'main_menu_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  List items = [];
  final rand = Random();
  bool loading = false;
  double loadingOpacity = 1;
  String url = "http://hackanana.com/dropbites/php/get_products.php";

  void _loadItems() async {
    http.post(url, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        items = extractdata["items"];
      });
    }).catchError((e) {
      print(e);
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
      setState(() {
        loading = true;
        loadingOpacity = .2;
      });
      _loadItems();
      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
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
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        boxShadow: [kButtonShadow]),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart),
                        color: kOrange3,
                        onPressed: () {
                          // TODO: Cart
                          print('Shopping cart');
                        },
                      ),
                    ),
                  )
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
                                          return ItemCard(
                                            id: items[index]['id'],
                                            title: items[index]['name'],
                                            rating:
                                                int.parse(items[index]['rating']),
                                            price: double.parse(
                                                    items[index]['price'])
                                                .toStringAsFixed(2),
                                            color: kCardColors[
                                                rand.nextInt(max(0, 7))],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  heightFactor: 4,
                                  child: (loading) ? kSpinKitLoader : Container(),
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

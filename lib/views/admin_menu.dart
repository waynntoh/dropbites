import 'dart:convert';
import 'package:drop_bites/components/admin_add_dialog.dart';
import 'package:drop_bites/components/admin_menu_item.dart';
import 'package:drop_bites/components/circle_button.dart';
import 'package:drop_bites/components/user_drawer.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/utils/item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminMenu extends StatefulWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static const String id = 'admin_menu_view';

  @override
  _AdminMenuState createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  List items = [];
  bool loading = false;
  double loadingOpacity = 1;
  String url = 'http://hackanana.com/dropbites/php/get_products.php';

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

  void resetItems() {
    setState(() {
      items.clear();
      _getItems();
    });
  }

  @override
  void initState() {
    _getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: UserDrawer(),
      key: AdminMenu.scaffoldKey,
      body: AbsorbPointer(
        absorbing: loading,
        child: Opacity(
          opacity: loadingOpacity,
          child: Stack(
            children: [
              Positioned(
                top: 36,
                left: 16,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        AdminMenu.scaffoldKey.currentState.openDrawer();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            boxShadow: [kItemCardShadow]),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: kGrey3,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.menu,
                              color: kOrange4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 78),
                    Text(
                      'My Menu',
                      style: kSplashScreenTextStyle.copyWith(
                          fontWeight: FontWeight.w900, fontSize: 30),
                    ),
                    SizedBox(width: 66),
                    CircleButton(
                      color: kOrange3,
                      child: Icon(Icons.add, size: 30),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) =>
                            AdminAddDialog(resetItems: resetItems),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                width: width,
                height: height,
                child: Container(
                  margin:
                      EdgeInsets.only(top: 100, left: 8, right: 8, bottom: 24),
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: items != null ? items.length : 0,
                    itemBuilder: (context, index) {
                      // Pass item object to item card widget
                      Item newItem = Item();
                      newItem.setId(items[index]['id']);
                      newItem.setName(items[index]['name']);
                      newItem.setPrice(double.parse(items[index]['price']));
                      newItem.setRating(double.parse(items[index]['rating']));
                      newItem.setType(items[index]['type']);
                      newItem.setDescription(items[index]['description']);
                      return AdminMenuItem(
                        item: newItem,
                        color: kCardColors[index % 7],
                        resetItems: resetItems,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

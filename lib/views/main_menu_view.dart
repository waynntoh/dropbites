import 'package:drop_bites/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/components/custom_drawer.dart';
import 'package:drop_bites/components/overhead_selector.dart';
import 'package:drop_bites/components/item_card.dart';

class MainMenuView extends StatefulWidget {
  static const String id = 'main_menu_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Today\'s Deals',
                    style: kSplashScreenTextStyle.copyWith(
                        fontWeight: FontWeight.w900, fontSize: 36),
                  ),
                  SizedBox(height: 16),
                  OverheadSelector(
                    selections: [
                      'All',
                      'Appetizers',
                      'Entrées',
                      'Beverages',
                      'Desserts'
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 24),
                    height: 450,
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ItemCard(
                          price: index.toString(),
                          color: kCardColors[index],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

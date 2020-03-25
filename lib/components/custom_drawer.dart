import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/views/cart_view.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context, listen: false);

    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 220,
            child: DrawerHeader(
              padding:
                  EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.white,
                  Color(0xFFEBEBEB),
                  Colors.white,
                ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('images/elon.jpg'),
                    radius: 40,
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(loggedInUser.name,
                          style: kDefaultTextStyle.copyWith(
                              fontWeight: FontWeight.w900)),
                      SizedBox(height: 4),
                      Text(loggedInUser.email, style: kDefaultTextStyle),
                      SizedBox(height: 4),
                      RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: 'Credits : ',
                            style: kDefaultTextStyle.copyWith(
                              color: kGrey4,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\$${loggedInUser.credits.toStringAsFixed(2)}',
                            style: kDefaultTextStyle.copyWith(
                                color: kOrange4, fontSize: 20),
                          ),
                        ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text('Reload', style: kDefaultTextStyle),
                  onTap: () {
                    // TODO: Reload credits
                    print('Reload');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('My Cart', style: kDefaultTextStyle),
                  onTap: () {
                    Navigator.pushNamed(context, CartView.id);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('Receipts', style: kDefaultTextStyle),
                  onTap: () {
                    // TODO: Receipts view
                    print('receipt view');
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Log Out', style: kDefaultTextStyle),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

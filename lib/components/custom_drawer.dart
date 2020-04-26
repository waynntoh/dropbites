import 'package:drop_bites/views/main_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:provider/provider.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/views/cart_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drop_bites/views/account_view.dart';
import 'package:drop_bites/views/payment_view.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context, listen: false);

    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 230,
            child: DrawerHeader(
              padding:
                  EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.white,
                  kGrey0,
                  Colors.white,
                ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: kGrey1,
                    backgroundImage: AdvancedNetworkImage(
                      'http://hackanana.com/dropbites/user_images/${loggedInUser.email}.jpg',
                      disableMemoryCache: true
                    ),
                    radius: 40,
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        loggedInUser.name,
                        style: kDefaultTextStyle.copyWith(
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 4),
                      Text(loggedInUser.email, style: kDefaultTextStyle),
                      SizedBox(height: 8),
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
                            style: kNumeralTextStyle.copyWith(
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
                  leading: FaIcon(
                    FontAwesomeIcons.hamburger,
                    color: kOrange3,
                  ),
                  title: Text('Food Menu', style: kDefaultTextStyle),
                  onTap: () {
                    if (MainMenuView.scaffoldKey.currentContext ==
                        Scaffold.of(context).context) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, MainMenuView.id);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    size: 28,
                    color: Colors.yellow[600],
                  ),
                  title: Text('My Cart', style: kDefaultTextStyle),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CartView(email: loggedInUser.email),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.creditCard,
                    color: Colors.green[400],
                  ),
                  title: Text('Payment', style: kDefaultTextStyle),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(context, PaymentView.id);
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.userCircle,
                    color: Colors.blue[300],
                  ),
                  title: Text('My Account', style: kDefaultTextStyle),
                  onTap: () {
                    if (AccountView.scaffoldKey.currentContext ==
                        Scaffold.of(context).context) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AccountView.id);
                    }
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.signOutAlt,
                    color: kGrey1,
                  ),
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

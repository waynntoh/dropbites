import 'dart:io';
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:drop_bites/views/admin_menu.dart';
import 'package:drop_bites/views/main_menu_view.dart';
import 'package:drop_bites/views/orders_view.dart';
import 'package:drop_bites/views/reload_view.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/views/cart_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drop_bites/views/account_view.dart';

class UserDrawer extends StatefulWidget {
  static bool changedImage = false;
  static File newImageFile;

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  void onPlacedOrder(String email) {
    CustomSnackbar.showSnackbar(
      iconData: Icons.local_shipping,
      text: 'New order placed!',
      scaffoldKey: MainMenuView.scaffoldKey,
      duration: Duration(seconds: 5),
    );
  }

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
                gradient: LinearGradient(
                  colors: [kGrey0, Colors.white, kGrey0],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: CachedNetworkImage(
                        imageUrl:
                            'http://hackanana.com/dropbites/user_images/${loggedInUser.email}.jpg',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AccountView.changedImage
                                  ? FileImage(UserDrawer.newImageFile)
                                  : CachedNetworkImageProvider(
                                      'http://hackanana.com/dropbites/user_images/${loggedInUser.email}.jpg',
                                    ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => kSmallImageLoader,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
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
                  title: Text('Menu', style: kDefaultTextStyle),
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
                    if (MainMenuView.scaffoldKey.currentContext !=
                        Scaffold.of(context).context) {
                      // Pop drawer and current view, push to main menu
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, MainMenuView.id);
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
                    } else {
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
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.creditCard,
                    color: Colors.green[400],
                  ),
                  title: Text('Reload Credits', style: kDefaultTextStyle),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReloadView(email: loggedInUser.email),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.receipt,
                    size: 28,
                    color: Colors.teal[300],
                  ),
                  title: Text('My Orders', style: kDefaultTextStyle),
                  onTap: () {
                    if (OrdersView.scaffoldKey.currentContext ==
                        Scaffold.of(context).context) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdersView(
                            email: loggedInUser.email,
                          ),
                        ),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.userAlt,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountView(
                            email: loggedInUser.email,
                          ),
                        ),
                      );
                    }
                  },
                ),
                loggedInUser.isAdmin
                    ? ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.userShield,
                          color: Colors.indigo[300],
                        ),
                        title:
                            Text('Admin Privileges', style: kDefaultTextStyle),
                        onTap: () {
                          if (AdminMenu.scaffoldKey.currentContext ==
                              Scaffold.of(context).context) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminMenu(),
                              ),
                            );
                          }
                        },
                      )
                    : Container(),
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

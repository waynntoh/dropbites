import 'package:drop_bites/views/main_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GuestDrawer extends StatefulWidget {
  final Function showSnackbar;
  GuestDrawer({this.showSnackbar});

  @override
  _GuestDrawerState createState() => _GuestDrawerState();
}

class _GuestDrawerState extends State<GuestDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 180,
            child: DrawerHeader(
              padding:
                  EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kOrange0, kGrey0, Colors.white],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: kGrey1,
                    backgroundImage: AssetImage('images/dummy_image.png'),
                    radius: 40,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Guest',
                    style:
                        kDefaultTextStyle.copyWith(fontWeight: FontWeight.w900),
                  ),
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
                    }
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    size: 28,
                    color: kGrey1,
                  ),
                  title: Text('My Cart', style: kDefaultTextStyle),
                  onTap: () {
                    Navigator.pop(context);
                    widget.showSnackbar();
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.creditCard,
                    color: kGrey1,
                  ),
                  title: Text('Reload Credits', style: kDefaultTextStyle),
                  onTap: () {
                    Navigator.pop(context);
                    widget.showSnackbar();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.receipt,
                    size: 28,
                    color: kGrey1,
                  ),
                  title: Text('My Orders', style: kDefaultTextStyle),
                  onTap: () {
                    Navigator.pop(context);
                    widget.showSnackbar();
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.userCircle,
                    color: kGrey1,
                  ),
                  title: Text('My Account', style: kDefaultTextStyle),
                  onTap: () {
                    Navigator.pop(context);
                    widget.showSnackbar();
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.signOutAlt,
                    color: kGrey5,
                  ),
                  title: Text('Login', style: kDefaultTextStyle),
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

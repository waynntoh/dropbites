import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 170,
            child: DrawerHeader(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.white,
                  Color(0xFFEBEBEB),
                  Color(0xFFEBEBEB),
                  Colors.white,
                ]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('images/elon.jpg'),
                    radius: 25,
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Elon Musk',
                          style: kDefaultTextStyle.copyWith(
                              fontWeight: FontWeight.w900)),
                      SizedBox(height: 4),
                      Text('elonmusk@spacex.com', style: kDefaultTextStyle),
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
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Log Out', style: kDefaultTextStyle),
                  onTap: () {
                    // TODO: Drawer log out
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

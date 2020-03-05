import 'package:flutter/material.dart';

class MainMenuView extends StatefulWidget {
  static const String id = 'main_menu_view';

  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Main Menu'),
            RaisedButton(
              child: Text('Log Out'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  static const String id = 'menu_view';

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Main Menu'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/views/login_view.dart';
import 'package:drop_bites/views/register_view.dart';
import 'package:drop_bites/views/menu_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(button: kButtonTextStyle),
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginView.id,
      routes: {
        RegisterView.id: (context) => RegisterView(),
        MainMenu.id: (context) => MainMenu(),
        LoginView.id: (context) => LoginView(),
      },
    );
  }
}

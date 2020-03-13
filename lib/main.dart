import 'package:drop_bites/views/splash_view.dart';
import 'package:flutter/material.dart';

import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/views/login_view.dart';
import 'package:drop_bites/views/register_view.dart';
import 'package:drop_bites/views/main_menu_view.dart';
import 'utils/user.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => User(),
      child: MaterialApp(
        theme: ThemeData(
          textTheme: TextTheme(
              button: kButtonTextStyle,
              body1: kDefaultTextStyle,
              title: kDefaultTextStyle,
              caption: kDefaultTextStyle),
        ),
        initialRoute: SplashView.id,
        routes: {
          RegisterView.id: (context) => RegisterView(),
          MainMenuView.id: (context) => MainMenuView(),
          LoginView.id: (context) => LoginView(),
          SplashView.id: (context) => SplashView(),
        },
      ),
    );
  }
}

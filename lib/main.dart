import 'package:drop_bites/views/location_view.dart';
import 'package:drop_bites/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/views/login_view.dart';
import 'package:drop_bites/views/register_view.dart';
import 'package:drop_bites/views/main_menu_view.dart';
import 'package:drop_bites/views/account_view.dart';
import 'utils/user.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => User(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme:
              TextTheme(button: kButtonTextStyle, caption: kDefaultTextStyle),
        ),
        initialRoute: SplashView.id,
        routes: {
          LocationView.id: (context) => LocationView(),
          AccountView.id: (context) => AccountView(),
          RegisterView.id: (context) => RegisterView(),
          MainMenuView.id: (context) => MainMenuView(),
          LoginView.id: (context) => LoginView(),
          SplashView.id: (context) => SplashView(),
        },
      ),
    );
  }
}

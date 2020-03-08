import 'package:drop_bites/views/login_view.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  static const String id = 'splash_view';

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  bool _rememberMe = false;
  String savedEmail;
  String savedPassword;
  AnimationController controller;
  Animation animation;

  void getSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    bool newBool = prefs.get('remember_me');
    if (newBool != null) {
      _rememberMe = newBool;
    }

    if (_rememberMe) {
      savedEmail = prefs.get('email');
      savedPassword = prefs.get('password');
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    getSharedPreferences();
    Timer(Duration(seconds: 2, milliseconds: 500), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (a, b, c) => (_rememberMe)
              ? LoginView(
                  savedEmail: savedEmail,
                  savedPassword: savedPassword,
                )
              : LoginView(),
        ),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Hero(
        tag: 'logo',
        child: AnimatedBuilder(
          animation: controller,
          child: Image.asset('images/logo.png', scale: .5),
          builder: (context, child) {
            return Transform.rotate(
              angle: controller.value * 2.0 * pi,
              child: child,
            );
          },
        ),
      )),
    );
  }
}

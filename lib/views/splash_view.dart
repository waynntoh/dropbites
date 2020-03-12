import 'dart:math';
import 'dart:async';
import 'package:drop_bites/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
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
    Timer(Duration(seconds: 3), () {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Hero(
                tag: 'logo',
                child: AnimatedBuilder(
                  animation: controller,
                  child: Image.asset('images/logo.png', scale: .9),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: controller.value * 2.0 * pi,
                      child: child,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: 250,
              child: Hero(
                tag: 'title',
                child: Material(
                  borderRadius: BorderRadius.circular(90),
                  child: TypewriterAnimatedTextKit(
                    textAlign: TextAlign.start,
                    alignment: Alignment.topCenter,
                    isRepeatingAnimation: false,
                    speed: Duration(milliseconds: 250),
                    text: ['DropBites'],
                    textStyle: kSplashScreenTextStyle,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

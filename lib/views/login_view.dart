import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/rounded_button.dart';
import 'package:drop_bites/views/register_view.dart';

class LoginView extends StatefulWidget {
  static const String id = 'splash_view';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  String email;
  String password;

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
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
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor.withOpacity(controller.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Opacity(
          opacity: controller.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 90,
                      width: 90,
                    ),
                  ),
                  TyperAnimatedTextKit(
                    isRepeatingAnimation: false,
                    speed: Duration(milliseconds: 250),
                    text: ['DropBites'],
                    textStyle: kSplashScreenTextStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              RoundedButton(
                text: 'Login',
                color: kOrange0,
                onPressed: () => null,
              ),
              RoundedButton(
                text: 'Register',
                color: kOrange3,
                onPressed: () => Navigator.pushNamed(context, RegisterView.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

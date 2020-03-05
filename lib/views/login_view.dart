import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/rounded_button.dart';
import 'package:drop_bites/views/register_view.dart';
import 'package:drop_bites/views/main_menu_view.dart';
import 'package:drop_bites/components/reset_password_dialog.dart';

class LoginView extends StatefulWidget {
  static const String id = 'login_view';
  final String savedEmail;
  final String savedPassword;

  LoginView({this.savedEmail, this.savedPassword});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email;
  String password;
  bool _rememberMe = false;

  void _toggleRememberMe() async {
    setState(() {
      _rememberMe = !_rememberMe;
    });

    // Set remember me in shared preferences to false if disabled
    if (!_rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('remember_me', false);
    }
  }

  void _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', _rememberMe);
    prefs.setString('email', emailController.text);
    prefs.setString('password', passwordController.text);
    print(
        '${prefs.get('remember_me')}, ${prefs.get('email')}, ${prefs.get('password')}');
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ResetPasswordDialog();
      },
    );
  }

  void login() {
    // TODO: Login
  }

  void register() {
    // TODO: Register
  }

  @override
  void initState() {
    // Set user email and password into textfield
    if (widget.savedEmail != null) {
      emailController.text = widget.savedEmail;
      passwordController.text = widget.savedPassword;
      _rememberMe = true;
    }

    controller = AnimationController(
        duration: Duration(seconds: 1, milliseconds: 500), vsync: this);
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
                    speed: Duration(milliseconds: 175),
                    text: ['DropBites'],
                    textStyle: kSplashScreenTextStyle,
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'example.email.com',
                  prefixIcon: Icon(Icons.email, color: kOrange4),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: '******',
                  prefixIcon: Icon(Icons.lock, color: kOrange4),
                  // suffixIcon: Icon(Icons.visibility_off, color: kOrange4),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      'Remember Me',
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () => _toggleRememberMe(),
                  ),
                  Switch(
                    activeColor: kOrange4,
                    activeTrackColor: kOrange2,
                    inactiveTrackColor: kOrange2,
                    value: _rememberMe,
                    onChanged: (bool value) {
                      _toggleRememberMe();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RoundedButton(
                    text: 'Register',
                    color: kOrange0,
                    onPressed: () =>
                        Navigator.pushNamed(context, RegisterView.id),
                  ),
                  RoundedButton(
                    text: 'Login',
                    color: kOrange3,
                    onPressed: () {
                      if (_rememberMe) {
                        _saveUser();
                      }
                      Navigator.pushNamed(context, MainMenuView.id);
                    },
                  ),
                ],
              ),
              SizedBox(height: 14),
              InkWell(
                  onTap: () => _showResetDialog(),
                  child: Container(
                    height: 24,
                    width: 24,
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kOrange5),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

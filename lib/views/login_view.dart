import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/rounded_button.dart';
import 'package:drop_bites/views/register_view.dart';
import 'package:drop_bites/views/main_menu_view.dart';
import 'package:drop_bites/components/reset_password_dialog.dart';

class LoginView extends StatefulWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static const String id = 'login_view';
  final String savedEmail;
  final String savedPassword;

  LoginView({this.savedEmail, this.savedPassword});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  String email;
  String password;
  bool _rememberMe = false;
  AnimationController controller;
  Animation animation;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  void login() {
    // TODO: Login
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
      key: LoginView.scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white.withOpacity(controller.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Opacity(
          opacity: controller.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  Hero(
                    tag: 'title',
                    child: Material(
                      child: TyperAnimatedTextKit(
                        isRepeatingAnimation: false,
                        speed: Duration(milliseconds: 175),
                        text: ['DropBites'],
                        textStyle: kSplashScreenTextStyle,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              Hero(
                tag: 'emailTextField',
                child: Material(
                  child: TextField(
                    style: kDefaultTextStyle,
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
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Hero(
                tag: 'passwordTextField',
                child: Material(
                  child: TextField(
                    style: kDefaultTextStyle,
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      'Remember Me',
                    ),
                    onTap: () => _toggleRememberMe(),
                  ),
                  Switch(
                    activeColor: kOrange4,
                    activeTrackColor: kOrange2,
                    inactiveTrackColor: kOrange1,
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
                  Hero(
                    tag: 'registerButton',
                    child: RoundedButton(
                      text: 'Register',
                      color: kOrange0,
                      onPressed: () =>
                          Navigator.pushNamed(context, RegisterView.id),
                    ),
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
              SizedBox(height: 16),
              GestureDetector(
                child: Text(
                  'Forgot Password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kOrange6),
                ),
                onTap: () => {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ResetPasswordDialog();
                    },
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

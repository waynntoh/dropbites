import 'package:drop_bites/components/eula_dialog.dart';
import 'package:flutter/material.dart';

import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/rounded_button.dart';
import 'package:http/http.dart';

class RegisterView extends StatefulWidget {
  static const String id = 'register_view';

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  void _register() {
    showDialog(
      context: context,
      builder: (context) {
        return EulaDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var passwordController;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                    child: Text('DropBites', style: kSplashScreenTextStyle),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              style: kDefaultTextStyle,
              controller: fullNameController,
              textAlign: TextAlign.center,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'John Doe',
                prefixIcon: Icon(Icons.person, color: kOrange4),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Hero(
              tag: 'emailTextField',
              child: Material(
                child: TextField(
                  style: kDefaultTextStyle,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
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
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: '******',
                    prefixIcon: Icon(Icons.lock, color: kOrange4),
                    // suffixIcon: Icon(Icons.visibility_off, color: kOrange4),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              style: kDefaultTextStyle,
              controller: phoneNumberController,
              textAlign: TextAlign.center,
              decoration: kTextFieldDecoration.copyWith(
                hintText: '0123456789',
                prefixIcon: Icon(Icons.phone_android, color: kOrange4),
              ),
            ),
            SizedBox(height: 26),
            Hero(
              tag: 'registerButton',
              child: RoundedButton(
                color: kOrange0,
                text: 'Register',
                onPressed: () => _register(),
                width: 500,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Already have an account?'),
                SizedBox(width: 8),
                GestureDetector(
                  child: Text(
                    'Login',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, color: kOrange6),
                  ),
                  onTap: () => Navigator.pop(context),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:drop_bites/components/eula_dialog.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/rounded_button.dart';
import 'package:drop_bites/views/login_view.dart';
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class RegisterView extends StatefulWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static const String id = 'register_view';

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String registerUrl = '';
  bool eulaAgreed = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  void toggleEula({bool boolean}) {
    setState(() {
      if (boolean != null) {
        eulaAgreed = boolean;
      } else {
        eulaAgreed = !eulaAgreed;
      }
    });
  }

  void _register() {
    // Show EulaDialog only if eula is not agreed
    if (!eulaAgreed) {
      CustomSnackbar.showSnackbar(
          text: 'Please accept the terms of the EUlA',
          scaffoldKey: RegisterView.scaffoldKey,
          iconData: Icons.info);
      return;
    }

    Navigator.pop(context);
    CustomSnackbar.showSnackbar(
        text: 'Registration Successful',
        scaffoldKey: LoginView.scaffoldKey,
        iconData: Icons.check_circle);

    // String fullName = fullNameController.text;
    // String email = emailController.text;
    // String password = passwordController.text;
    // String phoneNumber = phoneNumberController.text;

    // http.post(registerUrl, body: {
    //   "full_name": fullName,
    //   "email": email,
    //   "password": password,
    //   "phone_number": phoneNumber,
    // }).then((res) {
    //   if (res.body == "success") {
    //     showSnackbar('Registration Successful', true);
    //   } else {
    //     showSnackbar('Registration Failed', false);
    //   }
    // }).catchError((err) {
    //   print(err);
    // });
  }

  @override
  Widget build(BuildContext context) {
    var passwordController;
    return Scaffold(
      key: RegisterView.scaffoldKey,
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
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: RichText(
                    text: TextSpan(
                      style: kDefaultTextStyle.copyWith(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(text: 'I accept the terms of the '),
                        TextSpan(
                          text: 'EULA',
                          style: TextStyle(color: kOrange5),
                        )
                      ],
                    ),
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return EulaDialog(toggleEula: toggleEula);
                    },
                  ),
                ),
                Checkbox(
                  activeColor: kOrange4,
                  // activeTrackColor: kOrange2,
                  // inactiveTrackColor: kOrange1,
                  value: eulaAgreed,
                  onChanged: (bool value) {
                    toggleEula();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
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

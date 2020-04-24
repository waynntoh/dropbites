import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/rounded_button.dart';
import 'package:drop_bites/views/register_view.dart';
import 'package:drop_bites/views/main_menu_view.dart';
import 'package:drop_bites/components/reset_password_dialog.dart';
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:http/http.dart' as http;

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
  bool loading = false;
  double loadingOpacity = 1;
  int readyToExit = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String loginUrl = 'http://hackanana.com/dropbites/php/login.php';

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
  }

  void _login() {
    // Start loading spinkit & block taps
    setState(() {
      loading = true;
      loadingOpacity = .5;
    });

    // Login through DB
    String email = emailController.text;
    String password = passwordController.text;

    http.post(loginUrl, body: {
      "email": email,
      "password": password,
    }).then((res) {
      List<String> echoes = res.body.split(',');
      if (echoes[0] == "Login Successful") {
        Navigator.pushNamed(context, MainMenuView.id);

        // Pass user data to provider
        final loggedInUser = Provider.of<User>(context, listen: false);
        loggedInUser.setName(echoes[1]);
        loggedInUser.setEmail(echoes[2]);
        loggedInUser.setPhoneNumber(echoes[3]);
        loggedInUser.setCredit(double.parse(echoes[4]));
        loggedInUser.setRegDate(DateTime.parse(echoes[5]));
        echoes[6] == '0' ? loggedInUser.setVerified(false) : loggedInUser.setVerified(true);
      } else {
        CustomSnackbar.showSnackbar(
            text: 'Login Failed',
            scaffoldKey: LoginView.scaffoldKey,
            iconData: Icons.error);
      }
      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    // Set user email and password into textfield
    if (widget.savedEmail != null) {
      emailController.text = widget.savedEmail;
      passwordController.text = widget.savedPassword;
      _rememberMe = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (readyToExit.isEven) {
          CustomSnackbar.showSnackbar(
              text: 'Press back again to exit',
              scaffoldKey: LoginView.scaffoldKey,
              iconData: Icons.exit_to_app);
        } else {
          SystemNavigator.pop();
        }
        readyToExit++;
        return null;
      },
      child: Scaffold(
        key: LoginView.scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: <Widget>[
              AbsorbPointer(
                absorbing: loading,
                child: Opacity(
                  opacity: loadingOpacity,
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
                              child: Text(
                                'DropBites',
                                style: kSplashScreenTextStyle,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
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
                                    hintText: 'Email Address',
                                    prefixIcon:
                                        Icon(Icons.email, color: kOrange4),
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
                                    hintText: 'Password',
                                    prefixIcon:
                                        Icon(Icons.lock, color: kOrange4),
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
                                    style: kDefaultTextStyle,
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
                                    onPressed: () => Navigator.pushNamed(
                                        context, RegisterView.id),
                                  ),
                                ),
                                RoundedButton(
                                  text: 'Login',
                                  color: kOrange3,
                                  onPressed: () {
                                    if (_rememberMe) {
                                      _saveUser();
                                    }
                                    _login();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            GestureDetector(
                              child: Text(
                                'Forgot Password?',
                                textAlign: TextAlign.center,
                                style: kDefaultTextStyle.copyWith(color: kOrange6),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ResetPasswordDialog();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              (loading) ? kSpinKitLoader : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

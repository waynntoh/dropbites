import 'dart:convert';
import 'dart:io';

import 'package:drop_bites/components/eula_dialog.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/components/rounded_button.dart';
import 'package:drop_bites/views/login_view.dart';
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static const String id = 'register_view';

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String registerUrl = 'http://hackanana.com/dropbites/php/registration.php';
  String uploadImageUrl =
      'http://hackanana.com/dropbites/php/upload_user_image.php';
  bool eulaAgreed = false;
  bool loading = false;
  double loadingOpacity = 1;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  File _userImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: RegisterView.scaffoldKey,
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
                    SizedBox(
                      height: 110,
                      width: 100,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: kGrey1,
                            backgroundImage: _userImage != null
                                ? FileImage(_userImage)
                                : AssetImage('images/dummy_image.png'),
                            radius: 50,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _getUserImage(),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: kGrey1,
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white,
                                  child: FaIcon(
                                    FontAwesomeIcons.cameraRetro,
                                    color: kOrange4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                    TextField(
                      style: kDefaultTextStyle,
                      controller: fullNameController,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Full Name',
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
                            hintText: 'Email Address',
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
                            hintText: 'Password',
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
                        hintText: 'Contact Number',
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
                              style: kDefaultTextStyle.copyWith(
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(text: 'I accept the terms of the '),
                                TextSpan(
                                  text: 'EULA',
                                  style: TextStyle(color: kOrange6),
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
                        Text(
                          'Already have an account?',
                          style: kDefaultTextStyle,
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          child: Text(
                            'Login',
                            style: kDefaultTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              color: kOrange6,
                            ),
                          ),
                          onTap: () => Navigator.pop(context),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            (loading) ? kSpinKitLoader : Container()
          ],
        ),
      ),
    );
  }

  void toggleEula({bool boolean}) {
    setState(() {
      if (boolean != null) {
        eulaAgreed = boolean;
      } else {
        eulaAgreed = !eulaAgreed;
      }
    });
  }

  bool emailIsValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  bool phoneNumberIsValid(String phoneNumber) {
    return RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(phoneNumber);
  }

  void _register() {
    // Check for valid email & phone number
    if (!emailIsValid(emailController.text)) {
      CustomSnackbar.showSnackbar(
          text: 'Invalid Email',
          scaffoldKey: RegisterView.scaffoldKey,
          iconData: Icons.error);
      return;
    } else if (!phoneNumberIsValid(phoneNumberController.text)) {
      CustomSnackbar.showSnackbar(
          text: 'Invalid Phone Number',
          scaffoldKey: RegisterView.scaffoldKey,
          iconData: Icons.error);
      return;
    }

    // Show EulaDialog only if eula is not agreed
    if (!eulaAgreed) {
      CustomSnackbar.showSnackbar(
          text: 'Please accept the terms of the EULA',
          scaffoldKey: RegisterView.scaffoldKey,
          iconData: Icons.info);
      return;
    } else {
      // Registration Confirmation
      RegisterView.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: kOrange3,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Registration Confirmation',
                    style: TextStyle(color: kOrange3),
                  ),
                ],
              ),
              FlatButton(
                color: kOrange3,
                child: Text(
                  'Register',
                  style: kDefaultTextStyle.copyWith(color: Colors.black),
                ),
                onPressed: () {
                  // Hide Snackbar
                  RegisterView.scaffoldKey.currentState.hideCurrentSnackBar();

                  // Start loading spinkit & block taps
                  setState(() {
                    loading = true;
                    loadingOpacity = .5;
                  });
                  // Post to DB
                  String fullName = fullNameController.text;
                  String email = emailController.text;
                  String password = passwordController.text;
                  String phoneNumber = phoneNumberController.text;

                  http.post(registerUrl, body: {
                    "full_name": fullName,
                    "email": email,
                    "password": password,
                    "phone_number": phoneNumber,
                  }).then((res) {
                    print(res.body);
                    if (res.body == "Registration Successful") {
                      uploadImage(_userImage);
                      Navigator.pop(context);
                    } else {
                      CustomSnackbar.showSnackbar(
                          text: 'Registration Failed',
                          scaffoldKey: RegisterView.scaffoldKey,
                          iconData: Icons.error);
                    }
                    setState(() {
                      loading = false;
                      loadingOpacity = 1;
                    });
                  }).catchError((err) {
                    print(err);
                  });
                },
              )
            ],
          ),
        ),
      );
    }
  }

  void uploadImage(File imageFile) async {
    if (imageFile == null) {
      imageFile = File('images/dummy_image.png');
    }

    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http.post(uploadImageUrl, body: {
      "encoded_string": base64Image,
      "email": emailController.text,
    }).then((res) {
      if (res.body == "Upload Successful") {
        CustomSnackbar.showSnackbar(
            text: 'Registration Successful',
            scaffoldKey: LoginView.scaffoldKey,
            iconData: Icons.check_circle);
      } else {
        CustomSnackbar.showSnackbar(
            text: 'Image Upload Failed',
            scaffoldKey: LoginView.scaffoldKey,
            iconData: Icons.error);
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future _getUserImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _userImage = image;
    });
  }
}

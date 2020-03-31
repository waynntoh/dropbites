import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:drop_bites/views/login_view.dart';

class ResetPasswordDialog extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final String resetPasswordUrl =
      'http://hackanana.com/dropbites/php/send_reset_email.php';

  void _resetPassword(String email) {
    http.post(resetPasswordUrl, body: {
      "email": email,
    }).then((res) {
      if (res.body == "Sent Successfully") {
        CustomSnackbar.showSnackbar(
            text: 'Reset Email Sent Successfully',
            scaffoldKey: LoginView.scaffoldKey,
            iconData: Icons.email);
      } else {
        CustomSnackbar.showSnackbar(
            text: 'Invalid Email',
            scaffoldKey: LoginView.scaffoldKey,
            iconData: Icons.error);
      }
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reset Password',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 23,
        ),
      ),
      content: SizedBox(
        height: 130,
        child: Column(
          children: <Widget>[
            Text(
                'A reset password email will be send to the inbox. \n(Note: Check the spam folder)'),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'example@email.com',
                prefixIcon: Icon(Icons.email, color: kOrange4),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Center(
          child: RaisedButton(
            color: kOrange3,
            child: Text(
              'Send Email',
            ),
            onPressed: () {
              if (emailController != null) {
                _resetPassword(emailController.text);
                Navigator.pop(context);
              } else {
                CustomSnackbar.showSnackbar(
                    text: 'Invalid Email',
                    scaffoldKey: LoginView.scaffoldKey,
                    iconData: Icons.error);
              }
            },
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class ResetPasswordDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reset Password'),
      content: SizedBox(
        height: 130,
        child: Column(
          children: <Widget>[
            Text(
                'A reset password email will be send to the inbox. \n(Note: Check the spam folder)'),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email, color: kOrange4),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Center(
          child: FlatButton(
            child: Text(
              'Send Email',
              style: TextStyle(color: kOrange5),
            ),
            onPressed: () {
              // TODO: Send reset email
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }
}

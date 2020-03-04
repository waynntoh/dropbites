import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  static const String id = 'register_view';

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Register View'),
      ),
    );
  }
}

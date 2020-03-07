import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class EulaDialog extends StatelessWidget {
  static const String eulaText = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('License Agreement'),
      content: SingleChildScrollView(
        child: Text(eulaText, textAlign: TextAlign.center),
      ),
    );
  }
}

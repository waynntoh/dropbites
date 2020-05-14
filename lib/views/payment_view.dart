import 'package:drop_bites/components/user_drawer.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PaymentView extends StatefulWidget {
  static const String id = 'payment_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  User loggedInUser;
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User>(context, listen: false);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: PaymentView.scaffoldKey,
        drawer: UserDrawer(),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 36,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  PaymentView.scaffoldKey.currentState.openDrawer();
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: kGrey3,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.menu,
                      color: kOrange4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Reload
            print('Reload');
          },
          backgroundColor: Colors.green[400],
          icon: FaIcon(FontAwesomeIcons.redoAlt),
          label: Text('Reload'),
        ),
      ),
    );
  }
}

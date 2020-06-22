import 'package:drop_bites/components/circle_button.dart';
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:drop_bites/components/rounded_button.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/views/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

class ReloadView extends StatefulWidget {
  static const String id = 'reload_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _ReloadViewState createState() => _ReloadViewState();
}

class _ReloadViewState extends State<ReloadView> {
  User loggedInUser;
  double height;
  double width;
  int reloadAmount = 25;

  void onSuccessfulReload(BuildContext context) {
    CustomSnackbar.showSnackbar(
      iconData: Icons.credit_card,
      text: 'Successfully reloaded \$$reloadAmount',
      scaffoldKey: ReloadView.scaffoldKey,
    );

    // Update local credits
    loggedInUser = Provider.of<User>(context, listen: false);
    double newCredits = loggedInUser.credits + reloadAmount;
    loggedInUser.setCredit(newCredits);

    // Refresh UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User>(context, listen: false);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: ReloadView.scaffoldKey,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 36,
              left: 16,
              child: Row(
                children: [
                  CircleButton(
                    color: kOrange3,
                    child: Icon(Icons.arrow_back_ios),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 54),
                  Text(
                    'Reload Credits',
                    style: kSplashScreenTextStyle.copyWith(
                        fontWeight: FontWeight.w900, fontSize: 30),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Center(
                child: SingleCircularSlider(
                  20,
                  2,
                  height: 250,
                  width: 250,
                  baseColor: Colors.green[50],
                  selectionColor: Colors.greenAccent[400],
                  handlerColor: Colors.teal,
                  primarySectors: 10,
                  secondarySectors: 25,
                  sliderStrokeWidth: 12.0,
                  shouldCountLaps: true,
                  handlerOutterRadius: 16,
                  showRoundedCapInSelection: true,
                  child: Padding(
                    padding: const EdgeInsets.all(42.0),
                    child: Center(
                      child: Text(
                        '\$$reloadAmount',
                        style: kNumeralTextStyle.copyWith(
                          color: kOrange4,
                          fontSize: 46,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  onSelectionChange: (init, end, laps) {
                    setState(() {
                      reloadAmount = end * 25;
                      if (reloadAmount == 0) {
                        reloadAmount = 500;
                      }
                    });
                  },
                  onSelectionEnd: (init, end, laps) {
                    if (reloadAmount == 0) {
                      setState(() {
                        reloadAmount = 500;
                      });
                    }
                  },
                ),
              ),
            ),
            Positioned(
              height: 64,
              width: width - 180,
              bottom: 120,
              left: 90,
              child: RoundedButton(
                text: 'Reload',
                onPressed: () {
                  ReloadView.scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 10),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.credit_card,
                                color: kOrange3,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Reload \$$reloadAmount?',
                                style: TextStyle(color: kOrange3),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              FlatButton(
                                color: kOrange0,
                                child: Text(
                                  'No',
                                  style: kDefaultTextStyle.copyWith(
                                      color: Colors.black),
                                ),
                                onPressed: () {
                                  // Hide Snackbar
                                  ReloadView.scaffoldKey.currentState
                                      .hideCurrentSnackBar();
                                },
                              ),
                              SizedBox(width: 16),
                              FlatButton(
                                color: kOrange3,
                                child: Text(
                                  'Yes',
                                  style: kDefaultTextStyle.copyWith(
                                      color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentView(
                                        reloadAmount: reloadAmount,
                                        onFinishReload: onSuccessfulReload,
                                      ),
                                    ),
                                  );

                                  // Hide Snackbar
                                  ReloadView.scaffoldKey.currentState
                                      .hideCurrentSnackBar();
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

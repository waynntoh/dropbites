import 'dart:convert';

import 'package:drop_bites/components/circle_button.dart';
import 'package:drop_bites/components/custom_snackbar.dart';
import 'package:drop_bites/components/rounded_button.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/utils/reload.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:drop_bites/views/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:http/http.dart' as http;

class ReloadView extends StatefulWidget {
  static const String id = 'reload_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  final String email;

  ReloadView({@required this.email});

  @override
  _ReloadViewState createState() => _ReloadViewState();
}

class _ReloadViewState extends State<ReloadView> {
  User loggedInUser;
  double height;
  double width;
  int reloadAmount = 25;
  bool loading = false;
  double loadingOpacity = 1;
  List<Reload> reloads = [];
  String getCartURL = 'http://hackanana.com/dropbites/php/get_reloads.php';

  void _getReloads() async {
    // Start loading spinkit & block taps
    setState(() {
      loading = true;
      loadingOpacity = .5;
    });

    http.post(getCartURL, body: {
      'email': widget.email,
    }).then((res) {
      if (res.body != 'No Orders') {
        setState(() {
          var extractdata = json.decode(res.body);
          List r = extractdata["reloads"];

          // Create a cart
          for (var reload in r) {
            // Create Reload objects
            Reload newReload = new Reload();
            newReload.initialize(
              reload['bill_id'],
              double.parse(reload['amount']),
              DateTime.parse(reload['reload_date']),
            );

            reloads.add(newReload);
          }
        });
      }
      // Stop loading spinkit & block taps
      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
    }).catchError((e) {
      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
      print(e);
    });
  }

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

    Reload newReload = new Reload();
    newReload.initialize('', reloadAmount.toDouble(), null);

    // Refresh UI
    setState(() {
      reloads.insert(0, newReload);
    });
  }

  @override
  void initState() {
    _getReloads();
    super.initState();
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
        body: AbsorbPointer(
          absorbing: loading,
          child: Opacity(
            opacity: loadingOpacity,
            child: Stack(
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
                  width: width,
                  height: height,
                  top: 32,
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
                  bottom: 100,
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
                Positioned(
                  height: 120,
                  width: width - 180,
                  top: 140,
                  left: 85,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          reloads.length > 2
                              ? '+ \$${reloads[2].amount.toStringAsFixed(0)}'
                              : '',
                          style: kNumeralTextStyle.copyWith(
                            color: kOrange1,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          reloads.length > 1
                              ? '+ \$${reloads[1].amount.toStringAsFixed(0)}'
                              : '',
                          style: kNumeralTextStyle.copyWith(
                            color: kOrange3,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          reloads.length != 0
                              ? '+ \$${reloads[0].amount.toStringAsFixed(0)}'
                              : '',
                          style: kNumeralTextStyle.copyWith(
                            color: kOrange5,
                            fontSize: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

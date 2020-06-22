import 'dart:async';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends StatefulWidget {
  final int reloadAmount;
  final Function onFinishReload;

  PaymentView({@required this.reloadAmount, @required this.onFinishReload});

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> _controller = Completer<WebViewController>();
    final loggedInUser = Provider.of<User>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Back to DropBites'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.onFinishReload(context);
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl:
                'http://hackanana.com/dropbites/php/reload_credits.php' +
                    '?email=' +
                    loggedInUser.email +
                    '&phone_number=' +
                    loggedInUser.phoneNumber +
                    '&name=' +
                    loggedInUser.name +
                    '&amount=' +
                    widget.reloadAmount.toString(),
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (value) {
              print(value);
              print(loading);
              setState(() {
                loading = false;
              });
            },
          ),
          loading
              ? Center(
                  child: kSpinKitLoader,
                )
              : Container(),
        ],
      ),
    );
  }
}

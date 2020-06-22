import 'dart:async';
import 'package:drop_bites/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends StatelessWidget {
  final int reloadAmount;
  final Function onFinishReload;

  PaymentView({@required this.reloadAmount, @required this.onFinishReload});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Completer<WebViewController> _controller = Completer<WebViewController>();
    final loggedInUser = Provider.of<User>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Back to DropBites'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              onFinishReload(context);
              Navigator.pop(context);
            }),
      ),
      body: Container(
        height: height,
        width: width,
        child: WebView(
          initialUrl: 'http://hackanana.com/dropbites/php/reload_credits.php' +
              '?email=' +
              loggedInUser.email +
              '&phone_number=' +
              loggedInUser.phoneNumber +
              '&name=' +
              loggedInUser.name +
              '&amount=' +
              reloadAmount.toString(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}

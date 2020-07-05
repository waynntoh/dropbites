import 'dart:convert';
import 'package:drop_bites/components/order_tile.dart';
import 'package:drop_bites/components/user_drawer.dart';
import 'package:drop_bites/utils/order.dart';
import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:http/http.dart' as http;

class OrdersView extends StatefulWidget {
  static const String id = 'order_view';
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  final String email;

  OrdersView({@required this.email});

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  bool loading = false;
  double loadingOpacity = 1;
  String getOrdersURL = 'http://hackanana.com/dropbites/php/get_orders.php';
  List orders = [];
  bool showSnackbar = false;

  void _getOrders() async {
    // Start loading spinkit & block taps
    setState(() {
      loading = true;
      loadingOpacity = .2;
    });

    http.post(getOrdersURL, body: {
      'email': widget.email,
    }).then((res) {
      if (res.body != 'No Orders') {
        setState(() {
          var extractdata = json.decode(res.body);
          orders = extractdata["orders"];
        });
      }
      // Start loading spinkit & block taps
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

  @override
  void initState() {
    _getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: OrdersView.scaffoldKey,
      drawer: UserDrawer(),
      backgroundColor: Colors.white,
      body: AbsorbPointer(
        absorbing: loading,
        child: Opacity(
          opacity: loadingOpacity,
          child: Stack(
            children: [
              Positioned(
                top: 36,
                left: 16,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        OrdersView.scaffoldKey.currentState.openDrawer();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            boxShadow: [kItemCardShadow]),
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
                    SizedBox(width: 72),
                    Text(
                      'My Orders',
                      style: kSplashScreenTextStyle.copyWith(
                          fontWeight: FontWeight.w900, fontSize: 30),
                    ),
                  ],
                ),
              ),
              Positioned(
                width: width,
                height: height,
                child: Container(
                  margin:
                      EdgeInsets.only(top: 100, left: 8, right: 8, bottom: 24),
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: orders.length != 0 ? orders.length : 1,
                    itemBuilder: (context, index) {
                      if (orders.length != 0) {
                        // New Order object
                        Order newOrder = new Order();
                        List<Map> ordersMap = [];

                        // Decode items json
                        var decoded = jsonDecode(orders[index]['order_items']);
                        for (var item in decoded['items']) {
                          ordersMap.add({
                            'item': item['item'],
                            'count': item['count'],
                            'subtotal': item['subtotal']
                          });
                        }

                        // Initialize Order object variables
                        newOrder.initialize(
                            email: widget.email,
                            orderID: orders[index]['order_id'],
                            items: ordersMap,
                            orderDate:
                                DateTime.parse(orders[index]['order_date']),
                            address: orders[index]['address'],
                            total: double.parse(orders[index]['total']));

                        return OrderTile(
                          order: newOrder,
                          color: kCardColors[index % 7],
                        );
                      } else {
                        return Container(
                          height: height / 1.5,
                          alignment: Alignment.center,
                          child: Text(
                            'No Order History',
                            style: kDefaultTextStyle.copyWith(
                              color: kOrange5,
                              fontSize: 22,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

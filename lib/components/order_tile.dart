import 'package:drop_bites/components/order_details_dialog.dart';
import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/utils/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final Color color;

  OrderTile({@required this.order, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 91,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, color],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [kButtonShadow]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Text(
                      'Order    ',
                      style: kDefaultTextStyle.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: kGrey6,
                      ),
                    ),
                    Text(
                      '#${order.orderID}',
                      style: kNumeralTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: kGrey6,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Text(
                      'Date    ',
                      style: kDefaultTextStyle.copyWith(
                        fontSize: 17,
                        color: kGrey4,
                      ),
                    ),
                    Text(
                      '${DateFormat.yMMMMd().format(order.orderDate)} ',
                      style: kNumeralTextStyle.copyWith(
                        fontSize: 17,
                        color: kGrey6,
                      ),
                    ),
                    Text(
                      '${DateFormat.Hm().format(order.orderDate)}',
                      style: kNumeralTextStyle.copyWith(
                        fontSize: 17,
                        color: kGrey5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Text(
                      'Total    ',
                      style: kDefaultTextStyle.copyWith(
                        fontSize: 17,
                        color: kGrey4,
                      ),
                    ),
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: kNumeralTextStyle.copyWith(
                        fontSize: 18,
                        color: kOrange5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_drop_down,
              size: 42,
              color: kGrey4,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => OrderDetailsDialog(order: order),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}

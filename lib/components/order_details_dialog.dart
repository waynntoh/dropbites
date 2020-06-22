import 'package:drop_bites/utils/constants.dart';
import 'package:drop_bites/utils/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsDialog extends StatelessWidget {
  final Order order;

  OrderDetailsDialog({@required this.order});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: Text(
        'ORDER DETAILS',
        style: kDefaultTextStyle.copyWith(fontSize: 24),
      ),
      content: Container(
        height: height / 1.58,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: <Widget>[
                Text(
                  'Order ID:  ',
                  style: kDefaultTextStyle.copyWith(
                    fontSize: 17,
                    color: kGrey6,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '#${order.orderID}',
                  style: kNumeralTextStyle.copyWith(
                    fontSize: 18,
                    color: kGrey6,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text(
                  'Date:  ',
                  style: kDefaultTextStyle.copyWith(
                    fontSize: 17,
                    color: kGrey6,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${DateFormat.yMMMMd().format(order.orderDate)} ${DateFormat.Hm().format(order.orderDate)}',
                  style: kNumeralTextStyle.copyWith(
                    fontSize: 17,
                    color: kGrey6,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text(
                  'Total:  ',
                  style: kDefaultTextStyle.copyWith(
                    fontSize: 17,
                    color: kGrey6,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: kNumeralTextStyle.copyWith(
                    fontSize: 17,
                    color: kGrey6,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Item', style: kDefaultTextStyle)),
                      DataColumn(
                        label: Text('Quantity', style: kDefaultTextStyle),
                        numeric: true,
                      )
                    ],
                    rows: _buildRows(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Delivered to',
              textAlign: TextAlign.center,
              style: kDefaultTextStyle.copyWith(
                fontSize: 17,
                color: kGrey6,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${order.address}',
              textAlign: TextAlign.center,
              style: kDefaultTextStyle.copyWith(
                fontSize: 15,
                color: kGrey6,
              ),
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.only(right: 6),
      actions: [
        OutlineButton(
          child: Text(
            'Close',
            style: kDefaultTextStyle.copyWith(color: kOrange5),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];

    for (var item in order.items) {
      DataRow newRow = new DataRow(
        cells: [
          DataCell(
            Text(
              item['item']['name'],
              style: kDefaultTextStyle.copyWith(fontSize: 15),
            ),
          ),
          DataCell(
            Text(
              item['count'].toString(),
              style: kNumeralTextStyle.copyWith(fontSize: 16),
            ),
          ),
        ],
      );

      rows.add(newRow);
    }

    return rows;
  }
}

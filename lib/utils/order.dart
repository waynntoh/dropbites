import 'package:drop_bites/utils/item.dart';
import 'package:random_string/random_string.dart';

class Order {
  String _orderID;
  String _email;
  List<Map> _items = [];
  DateTime _orderDate;
  String _address;
  double _total;

  void setUserEmail(String userEmail) {
    _email = userEmail;
  }

  void setAddress(String address) {
    _address = address;
  }

  void setOrderDate(DateTime orderDate) {
    _orderDate = orderDate;
  }

  void setTotal(double total) {
    _total = total;
  }

  void initialize({
    String orderID,
    String email,
    String address,
    List<Map> items,
    double total,
    DateTime orderDate,
  }) {
    _email = email;
    _address = address;
    _total = total;
    _orderDate = orderDate;

    if (orderID == null) {
      _orderID = randomAlphaNumeric(8).toUpperCase();
    } else {
      _orderID = orderID;
    }

    if (items == null) {
      return;
    } else {
      _items = items;
    }
  }

  void add(Item newItem, int count, double subtotal) {
    _items.add({'item': newItem, 'count': count, 'subtotal': subtotal});
  }

  void clear() {
    _items.clear();
  }

  get orderID => _orderID;
  get email => _email;
  get items => _items;
  get length => _items.length;
  get address => _address;
  get orderDate => _orderDate;
  get total => _total;

  Map toJson() => {
        'items': items,
      };
}

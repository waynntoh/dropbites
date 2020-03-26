import 'package:drop_bites/utils/item.dart';

class Cart {
  String _userEmail;
  List<Map> _items = [];

  void setUserEmail(String userEmail) {
    _userEmail = userEmail;
  }

  void add(Item newItem, int count, double subtotal) {
    _items.add({'item': newItem, 'count': count, 'subtotal': subtotal});
  }

  void drop(index) {
    _items.removeAt(index);
  }

  get userEmail => _userEmail;
  get items => _items;
  get length => _items.length;
}

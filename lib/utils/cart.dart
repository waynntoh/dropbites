import 'package:drop_bites/utils/item.dart';

class Cart {
  String _userEmail;
  List<Map> _items = [];

  void setUserEmail(String userEmail) {
    _userEmail = userEmail;
  }

  void add(Item newItem, int count) {
    _items.add({'name': newItem.name, 'count': count});
  }

  get userEmail => _userEmail;
  get items => _items;
  get length => _items.length;
}
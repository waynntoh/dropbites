class Item {
  String _name;
  String _id;
  double _price;
  int _rating;
  String _type;
  String _description;

  void setName(String name) {
    _name = name;
  }

  void setId(String id) {
    _id = id;
  }

  void setPrice(double price) {
    _price = price;
  }

  void setRating(int rating) {
    _rating = rating;
  }

  void setType(String type) {
    _type = type;
  }

  void setDescription(String desc) {
    _description = desc;
  }

  get name => _name;
  get id => _id;
  get price => _price;
  get rating => _rating;
  get type => _type;
  get description => _description;
}

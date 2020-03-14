class User {
  String fullName;
  String email;
  String phoneNumber;

  User({this.fullName, this.email, this.phoneNumber});

  void setName(String _fullName) {
    fullName = _fullName;
  }

  void setEmail(String _email) {
    email = _email;
  }

  void setPhoneNumber(String _phoneNumber) {
    phoneNumber = _phoneNumber;
  }

  get gFullName => fullName;
  get gEmail => email;
  get gPhoneNumber => phoneNumber;
}

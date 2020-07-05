import 'package:intl/intl.dart';

class User {
  String _name;
  String _email;
  String _phoneNumber;
  double _credits;
  DateTime _regDate;
  bool _verified;
  bool _isAdmin;

  void setName(String name) {
    _name = name;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  void setCredit(double credits) {
    _credits = credits;
  }

  void setRegDate(DateTime regDate) {
    _regDate =  regDate;
  }

  void setVerified(bool verified) {
    _verified = verified;
  }

  void setAdmin(bool isAdmin) {
    _isAdmin = isAdmin;
  }

  get name => _name;
  get email => _email;
  get phoneNumber => _phoneNumber;
  get credits => _credits;
  get regDate => DateFormat.yMMMMd().format(_regDate);
  get verified => _verified;
  get isAdmin => _isAdmin;
}

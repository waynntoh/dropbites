class Reload {
  String _billID;
  double _amount;
  DateTime _reloadDate;

  void initialize(String billID, double amount, DateTime reloadDate) {
    _billID = billID;
    _amount = amount;
    _reloadDate = reloadDate;
  }

  get billID => _billID;
  get amount => _amount;
  get reloadDate => _reloadDate;
}

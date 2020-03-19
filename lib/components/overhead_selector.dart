import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class OverheadSelector extends StatefulWidget {
  final List<String> selections;
  final List<String> types;
  final Function sort;

  OverheadSelector(
      {@required this.selections, @required this.types, @required this.sort});

  @override
  _OverheadSelectorState createState() => _OverheadSelectorState();
}

class _OverheadSelectorState extends State<OverheadSelector> {
  int _currentIndex = 0;
  bool _isSelected;

  List<Widget> _buildSelections() {
    return widget.selections.map((selection) {
      int index = widget.selections.indexOf(selection);
      _isSelected = _currentIndex == index;
      return Padding(
        padding: EdgeInsets.only(right: 13),
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.sort(widget.types[index]);
              _currentIndex = index;
            });
          },
          child: Text(
            selection,
            style: kDefaultTextStyle.copyWith(
              color: _isSelected ? kGrey6 : kGrey1,
              fontSize: _isSelected ? 20 : 17,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildSelections(),
    );
  }
}

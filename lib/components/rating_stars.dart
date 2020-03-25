import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  RatingStars({@required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildRatings(),
    );
  }

  List<Widget> _buildRatings() {
    List<Widget> stars = [];
    double _rating = rating;

    for (int i = 0; i < 5; i++) {
      if (_rating > 1) {
        stars.add(
          Icon(Icons.star, color: kOrange3),
        );
      } else if (_rating < 1 && _rating > 0) {
        stars.add(
          Icon(Icons.star_half, color: kOrange3),
        );
      } else if (_rating <= 0) {
        stars.add(
          Icon(Icons.star_border, color: kOrange3),
        );
      } else {
        stars.add(
          Icon(Icons.star_border, color: kOrange3),
        );
      }
      _rating--;
    }
    return stars;
  }
}

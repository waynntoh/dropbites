import 'package:flutter/material.dart';
import 'package:drop_bites/utils/constants.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  RatingStars({@required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildRatings(),
    );
  }

  List<Widget> _buildRatings() {
    List<Widget> stars = [];

    for (int i = 0; i < 5; i++) {
      (i < rating)
          ? stars.add(
              Icon(
                Icons.star,
                color: kOrange3,
              ),
            )
          : stars.add(
              Icon(
                Icons.star_border,
                color: kOrange3,
              ),
            );
    }
    return stars;
  }
}

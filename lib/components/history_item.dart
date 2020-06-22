import 'package:drop_bites/utils/constants.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      height: 110,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(right: 16),
          padding: EdgeInsets.all(12),
          width: 200,
          height: 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kGrey0,
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: kGrey1,
                blurRadius: 1,
                spreadRadius: .5,
                offset: Offset(1, 1.5),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Receipt No:',
                    style: kDefaultTextStyle.copyWith(color: kGrey6),
                  ),
                  Text(
                    'A0001293',
                    style: kNumeralTextStyle.copyWith(
                        fontWeight: FontWeight.w900, color: kGrey6),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total:',
                    style: kDefaultTextStyle.copyWith(color: kGrey4),
                  ),
                  Text(
                    'RM29.90',
                    style: kNumeralTextStyle.copyWith(
                      color: kGrey4,
                      fontSize: 17.5,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Date:',
                    style: kDefaultTextStyle.copyWith(color: kGrey4),
                  ),
                  Text(
                    '03/04/2020',
                    style: kNumeralTextStyle.copyWith(
                      color: kGrey4,
                      fontSize: 17.5,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

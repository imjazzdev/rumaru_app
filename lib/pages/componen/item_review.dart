import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ItemReview extends StatelessWidget {
  final String review;
  ItemReview({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(10),
      width: 150,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [Text(review)],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            15,
          ),
          boxShadow: [
            BoxShadow(
                blurRadius: 3,
                spreadRadius: 2,
                offset: Offset(1, 2),
                color: Colors.blue.withOpacity(0.1))
          ],
          color: Colors.white),
    );
  }
}

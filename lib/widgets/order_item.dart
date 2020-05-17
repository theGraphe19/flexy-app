import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final String size;
  final String price;

  OrderItem(this.size, this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(size),
          Text(price),
        ],
      ),
    );
  }
}

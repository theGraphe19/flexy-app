import 'package:flutter/material.dart';

import '../models/cart.dart';

class CartItem extends StatelessWidget {
  Cart item;

  CartItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(item.productName),
    );
  }
}

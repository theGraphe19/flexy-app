import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  Product product;
  String token;

  ProductItem(
    this.product,
    this.token,
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: <dynamic>[
              product,
              token,
            ],
            //arguments: <dynamic>[product.id, token],
          ),
          child: Center(child: Text(product.productImages[0])),
          // child: Image.asset(
          //   productImage.productImage,
          //   fit: BoxFit.cover,
          // ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.name),
        ),
      ),
    );
  }
}

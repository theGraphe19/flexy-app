import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/product_details_screen.dart';
import '../credentials.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final String token;

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
          ),
          child: Center(child: Text(product.subCategory)), //CHANGE TO IMAGE
          // child: Image.network(
          //   productImagesURL + product.productImages[0],
          //   fit: BoxFit.cover,
          // ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.name),
          trailing: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

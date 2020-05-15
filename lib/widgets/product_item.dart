import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_image.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  Product product;
  ProductImage productImage;

  ProductItem(this.product, this.productImage);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: <dynamic>[product, productImage],
          ),
          child: Image.asset(
            productImage.productImage,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.name),
        ),
      ),
    );
  }
}

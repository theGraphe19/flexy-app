import 'package:flexy/models/user.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../screens/product_details_screen.dart';

class ProductItemUnrelated extends StatefulWidget {
  final Product product;
  final User user;
  final Category category;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProductItemUnrelated(
    this.product,
    this.user,
    this.category,
    this.scaffoldKey,
  );

  @override
  _ProductItemUnrelatedState createState() => _ProductItemUnrelatedState();
}

class _ProductItemUnrelatedState extends State<ProductItemUnrelated> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailsScreen.routeName,
          arguments: <dynamic>[
            widget.product,
            widget.user.token,
            widget.category,
            widget.user
          ],
        );
      },
      child: Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://flexyindia.com/administrator/storage/app/product_images/${widget.product.productImages[0]}',
                fit: BoxFit.contain,
                height: 245.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                widget.product.name,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                '${widget.product.tagline}',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

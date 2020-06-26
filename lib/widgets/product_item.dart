import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final String token;
  final int categoryId;

  ProductItem(this.product, this.token, this.categoryId);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  SharedPreferences prefs;
  bool _isFavourite = false;

  void addDataToPrefs() async {
    prefs = await SharedPreferences.getInstance();
    String favs = prefs.getString('favourites-${widget.categoryId}');
    List<dynamic> favouriteList;
    if (favs != null)
      favouriteList = json.decode(favs);
    else
      favouriteList = [];
    favouriteList.add(widget.product.id);
    await prefs.setString(
        'favourites-${widget.categoryId}', json.encode(favouriteList));
    setState(() {
      _isFavourite = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: <dynamic>[
              widget.product,
              widget.token,
            ],
          ),
          child:
              Center(child: Text(widget.product.subCategory)), //CHANGE TO IMAGE
          // child: Image.network(
          //   productImagesURL + product.productImages[0],
          //   fit: BoxFit.cover,
          // ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(widget.product.name),
          trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: (_isFavourite) ? Colors.red : Colors.white,
            ),
            onPressed: () {
              print('pressed');
              addDataToPrefs();
            },
          ),
        ),
      ),
    );
  }
}

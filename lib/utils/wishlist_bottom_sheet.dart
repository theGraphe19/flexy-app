import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/product_provider.dart';
import '../providers/favourite_product_provider.dart';
import '../models/product.dart';
import '../models/user.dart';

class WishlistBottomSheet {
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;
  int categoryId;
  User user;
  ProductProvider _productProvider;
  FavouriteProductProvider _favouriteProductProvider;
  List<Product> _favouriteProducts;

  WishlistBottomSheet({
    @required this.context,
    @required this.scaffoldKey,
    @required this.categoryId,
    @required this.user,
  }) {
    _productProvider = Provider.of<ProductProvider>(context);
    _favouriteProductProvider =
        Provider.of<FavouriteProductProvider>(context, listen: true);
  }

  void _getFavouriteList() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String favs = _prefs.getString('favourites-$categoryId') ?? null;
    List<dynamic> favouriteList;
    if (favs != null) {
      favouriteList = json.decode(favs);
      _favouriteProducts = [];
      for (var i = 0; i < favouriteList.length; i++) {
        _favouriteProducts.add(_productProvider.getProduct(favouriteList[i]));
      }
    }
    _favouriteProductProvider.clear();
    _favouriteProductProvider.addItem(_favouriteProducts);
    print(favouriteList.toString());
    print(_favouriteProducts.toString());
  }

  void fireWishlist() {
    _getFavouriteList();

    scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        width: double.infinity,
        height: 450.0,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Wishlist'),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: (_favouriteProductProvider.favProductsList == null ||
                      _favouriteProductProvider.favProductsList.length == 0)
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Image.asset('assets/images/wait.png'),
                          ),
                          Text(
                            'No items added yet!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          _favouriteProductProvider.favProductsList.length,
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ProductItem(
                          // _favouriteProducts[index],
                          // index,
                          _favouriteProductProvider.favProductsList[index],
                          _productProvider.productsList.indexOf(
                              _favouriteProductProvider.favProductsList[index]),
                          user,
                          categoryId,
                          scaffoldKey,
                          true,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}

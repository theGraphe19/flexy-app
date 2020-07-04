import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/product_item.dart';
import '../HTTP_handler.dart';
import '../models/product.dart';
import '../widgets/loading_body.dart';
import '../models/user.dart';
import '../providers/product_provider.dart';
import '../utils/drawer.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int categoryId;
  var prodListCounterCalled = false;
  User _currentUser;
  var _onlyFavourites = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();

  List<Product> productList;
  ProductProvider _productProvider;

  var _radioValue = 0;

  getList() async {
    _onlyFavourites = false;
    prodListCounterCalled = true;
    _handler
        .getProductsList(context, _currentUser.token, categoryId.toString())
        .then((value) {
      productList = value;
      setState(() {});
    });
  }

  getWishlist() async {
    _onlyFavourites = true;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String favs = _prefs.getString('favourites-$categoryId');
    List<dynamic> favouriteList;
    if (favs != null) {
      favouriteList = json.decode(favs);
      productList.clear();
      for (var i = 0; i < favouriteList.length; i++)
        productList.add(_productProvider.getProduct(favouriteList[i]));
    } else {
      favouriteList = null;
      productList = null;
    }
    print(productList.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _currentUser = data['user'];
    print(_currentUser.token);
    categoryId = data['category_id'];
    print(categoryId);
    _productProvider = Provider.of<ProductProvider>(context);

    if (!prodListCounterCalled && !_onlyFavourites) getList();

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              print('more pressed');
              scaffoldKey.currentState.openDrawer();
            },
          ),
          title: Text('Products'),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  (_onlyFavourites) ? 'All Products' : 'My Wishlist',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        drawer: SideDrawer(_currentUser, scaffoldKey).drawer(context),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print('sort products');
                      _sortOptions(context);
                    },
                    child: Text(
                      'Sort',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    color: Colors.black12,
                    height: 25,
                    width: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('filter pressed');
                    },
                    child: Text(
                      'Filter',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            (productList == null)
                ? LoadingBody()
                : Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: productList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) =>
                          ProductItem(
                        productList[index],
                        _currentUser.token,
                        categoryId,
                        scaffoldKey,
                      ),
                    ),
                  ),
          ],
        ));
  }

  void _handleRadioValueChange1(int value) {
    if (value == 1) {
      print(productList[0].name);
      productList.sort((p1, p2) =>
          p1.productSizes[0].price.compareTo(p2.productSizes[0].price));
      print(productList[0].name);
    }
    if (value == 2) {
      print(productList[0].name);
      productList.sort((p1, p2) =>
          p1.productSizes[0].price.compareTo(p2.productSizes[0].price));
      productList = productList.reversed.toList();
      print(productList[0].name);
    }
    setState(() {
      _radioValue = value;
      Navigator.of(context).pop();
    });
  }

  void _sortOptions(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 200.0,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('SORT BY'),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Price - Low to High'),
                  Radio<int>(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange1,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Price - High to Low'),
                  Radio<int>(
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange1,
                  ),
                ],
              ),
            ],
          ),
        );
      });

  void handleClick(String value) {
    switch (value) {
      case 'All Products':
        getList();
        break;

      case 'My Wishlist':
        getWishlist();
        break;
    }
  }
}

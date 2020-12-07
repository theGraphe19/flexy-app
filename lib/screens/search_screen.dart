import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

import '../HTTP_handler.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../widgets/search_item.dart';

class SearchScreen extends StatefulWidget {
  final User currentUser;

  SearchScreen(this.currentUser);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> _products;
  bool productsController = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Product>> search(String search) async {
    List<Product> result = [];
    for (var i = 0; i < _products.length; i++) {
      if (_products[i].name.toLowerCase().contains(search.toLowerCase()) ||
          _products[i]
              .description
              .toLowerCase()
              .contains(search.toLowerCase()) ||
          _products[i].tagline.toLowerCase().contains(search.toLowerCase()) ||
          _products[i]
              .productTags
              .toLowerCase()
              .contains(search.toLowerCase())) {
        result.add(_products[i]);
      }
    }

    return (result.length == 0) ? null : result;
  }
  
  @override
  Widget build(BuildContext context) {
    if (!productsController) {
      productsController = true;
      HTTPHandler().searchData(widget.currentUser.token).then((value) {
        this._products = value;
      }).catchError((e) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Network error!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff6c757d),
          duration: Duration(seconds: 3),
        ));
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Product>(
            onSearch: search,
            onItemFound: (Product product, int index) {
              return SearchItem(
                product,
                widget.currentUser,
                _scaffoldKey,
              );
            },
            placeHolder: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/search.png',
                  height: 70.0,
                  width: 70.0,
                ),
                Text('Enter product name...'),
              ],
            ),
            onError: (error) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/wait.png',
                    height: 70.0,
                    width: 70.0,
                  ),
                  Text('No products match your search!'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

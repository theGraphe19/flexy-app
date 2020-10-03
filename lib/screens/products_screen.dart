import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../HTTP_handler.dart';
import '../models/product.dart';
import '../widgets/loading_body.dart';
import '../models/user.dart';
import '../providers/product_provider.dart';
import '../utils/drawer.dart';
import '../utils/wishlist_bottom_sheet.dart';
import './search_screen.dart';
import '../models/category.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Category category;
  var prodListCounterCalled = false;
  User currentUser;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();

  bool _productsLoaded = false;
  ProductProvider _productProvider;
  WishlistBottomSheet _wishlistBottomSheet;

  var _radioValue = 1;
  var _radioValue1 = 0;

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SearchScreen(currentUser),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  getList() async {
    prodListCounterCalled = true;
    _handler
        .getProductsList(context, currentUser.token, category.id.toString())
        .then((value) {
      setState(() {
        _productsLoaded = true;
      });
    }).catchError((e) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Network error!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff6c757d),
        duration: Duration(seconds: 3),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    currentUser = data['user'];
    print(currentUser.token);
    category = data['category'];
    print(category);
    _productProvider = Provider.of<ProductProvider>(context);
    _wishlistBottomSheet = WishlistBottomSheet(
      context: context,
      scaffoldKey: scaffoldKey,
      categoryId: category.id,
      user: currentUser,
    );

    if (!prodListCounterCalled) getList();

    return Scaffold(
      backgroundColor: Colors.white,
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
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              print('search');
              Navigator.of(context).push(_createRoute());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: () {
                _wishlistBottomSheet.fireWishlist();
              },
            ),
          )
        ],
      ),
      drawer: SideDrawer(currentUser, scaffoldKey).drawer(context),
      body: Column(
        children: <Widget>[
          Divider(),
          Expanded(
            child: (!_productsLoaded)
                ? LoadingBody()
                : GridView.builder(
                    itemCount: _productProvider.productsList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.59,
                    ),
                    itemBuilder: (BuildContext context, int index) =>
                        ProductItem(
                      index,
                      currentUser,
                      category.id,
                      scaffoldKey,
                      false,
                    ),
                  ),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 20.0,
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
                    _filterOptions(context);
                  },
                  child: Text(
                    'Filter',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleRadioValueChange1(int value) {
    if (value == 1) {
      print(_productProvider.productsList[0].name);
      _productProvider.productsList.sort((p1, p2) =>
          p1.productSizes[0].price.compareTo(p2.productSizes[0].price));
      print(_productProvider.productsList[0].name);
    }
    if (value == 2) {
      print(_productProvider.productsList[0].name);
      _productProvider.productsList.sort((p1, p2) =>
          p1.productSizes[0].price.compareTo(p2.productSizes[0].price));
      _productProvider.productList =
          _productProvider.productsList.reversed.toList();
      print(_productProvider.productsList[0].name);
    }
    setState(() {
      _radioValue = value;
      Navigator.of(context).pop();
    });
  }

  void _handleRadioValueChange2(int value) {
    List<Product> newList = [];
    _productProvider.productList = _productProvider.productsListDuplicate;
    if (value != 0) {
      for (var i = 0; i < _productProvider.productsList.length; i++) {
        if (_productProvider.productsList[i].subCategory
                .contains(category.subCategories[value - 1]) &&
            category.subCategories[value - 1]
                .contains(_productProvider.productsList[i].subCategory)) {
          newList.add(_productProvider.productsList[i]);
        }
      }
      _productProvider.productList = newList;
    }
    print(value);
    setState(() {
      _radioValue1 = value;
      Navigator.of(context).pop();
    });
  }

  void _filterOptions(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 350.0,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('FILTER BY'),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Divider(),
              Container(
                height: 30.0,
                child: RadioListTile(
                  title: Text(
                    'All Products',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  value: 0,
                  groupValue: _radioValue1,
                  onChanged: _handleRadioValueChange2,
                ),
              ),
              Column(
                children: category.subCategories.map((subCat) {
                  return Container(
                    height: 30.0,
                    child: RadioListTile(
                      title: Text(
                        subCat,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                        ),
                      ),
                      value: (category.subCategories.indexOf(subCat, 0) + 1),
                      groupValue: _radioValue1,
                      onChanged: _handleRadioValueChange2,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      });

  void _sortOptions(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 150.0,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('SORT BY'),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: 30.0,
                child: RadioListTile(
                  title: Text(
                    'Price - Low to High',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange1,
                ),
              ),
              SizedBox(height: 15.0),
              SizedBox(
                height: 30.0,
                child: RadioListTile(
                  title: Text(
                    'Price - High to Low',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  value: 2,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange1,
                ),
              ),
            ],
          ),
        );
      });
}

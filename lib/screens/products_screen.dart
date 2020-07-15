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

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int categoryId;
  var prodListCounterCalled = false;
  User currentUser;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();

  List<Product> productList;
  ProductProvider _productProvider;
  WishlistBottomSheet _wishlistBottomSheet;

  var _radioValue = 1;
  var _radioValue1 = 0;

  getList() async {
    prodListCounterCalled = true;
    _handler
        .getProductsList(context, currentUser.token, categoryId.toString())
        .then((value) {
      productList = value;
      setState(() {});
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
    categoryId = data['category_id'];
    print(categoryId);
    _productProvider = Provider.of<ProductProvider>(context);
    _wishlistBottomSheet = WishlistBottomSheet(
      context: context,
      scaffoldKey: scaffoldKey,
      categoryId: categoryId,
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
            child: (productList == null)
                ? LoadingBody()
                : GridView.builder(
                    itemCount: productList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.59,
                    ),
                    itemBuilder: (BuildContext context, int index) =>
                        ProductItem(
                      productList[index],
                      currentUser,
                      categoryId,
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

  void _handleRadioValueChange2(int value) {
    List<Product> newList = [];
    productList = _productProvider.productsList;
    if (value != 0) {
      print('old length' + newList.length.toString());
      for (var i = 0; i < productList.length; i++) {
        if (value == 1) {
          if (productList[i].productSizes[0].price <= 500) {
            newList.add(productList[i]);
          }
        } else if (value == 2) {
          if (productList[i].productSizes[0].price <= 1000 &&
              productList[i].productSizes[0].price > 500) {
            newList.add(productList[i]);
          }
        } else {
          if (productList[i].productSizes[0].price > 1000) {
            newList.add(productList[i]);
          }
        }
      }
      print('new length' + newList.length.toString());
      productList = newList;
    }
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
          height: 250.0,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('FILTER BY'),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('All products'),
                  Radio<int>(
                    value: 0,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange2,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Below 500'),
                  Radio<int>(
                    value: 1,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange2,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('501 - 1000'),
                  Radio<int>(
                    value: 2,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange2,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Above 1000'),
                  Radio<int>(
                    value: 3,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange2,
                  ),
                ],
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
}

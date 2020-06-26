import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../HTTP_handler.dart';
import '../models/product.dart';
import './my_orders_screen.dart';
import './start_screen.dart';
import '../widgets/loading_body.dart';
import '../models/user.dart';
import '../providers/product_provider.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int categoryId;
  var prodListCounterCalled = false;
  User _currentUser;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();

  List<Product> productList;
  ProductProvider _productProvider;

  getList() async {
    prodListCounterCalled = true;
    _handler
        .getProductsList(context, _currentUser.token, categoryId.toString())
        .then((value) {
      productList = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _currentUser = data['user'];
    print(_currentUser.token);
    categoryId = data['category_id'];
    print(categoryId);

    if (!prodListCounterCalled) getList();
    if (prodListCounterCalled) {
      _productProvider = Provider.of<ProductProvider>(context);
      print(_productProvider.products.toString());
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Products'),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'My Orders',
                  'LogOut',
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
        body: (productList == null)
            ? LoadingBody()
            : GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: productList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) =>
                    ProductItem(productList[index], _currentUser.token),
              ));
  }

  void handleClick(String value) {
    switch (value) {
      case 'My Orders':
        Navigator.of(context).pushNamed(
          MyOrdersScreen.routeName,
          arguments: _currentUser.token,
        );
        break;
      case 'LogOut':
        _handler.logOut(_currentUser.token).then((loggedOut) {
          if (loggedOut)
            Navigator.of(context).popAndPushNamed(
              StartScreen.routeName,
            );
          else
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('LogOut failed'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ));
        });
        break;
    }
  }
}

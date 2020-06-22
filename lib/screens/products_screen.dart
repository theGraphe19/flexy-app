import 'package:flutter/material.dart';

import '../widgets/product_item.dart';
import '../HTTP_handler.dart';
import '../models/product.dart';
import './my_orders_screen.dart';
import './start_screen.dart';
import '../widgets/loading_body.dart';
import '../models/user.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String token = '';
  var prodListCounterCalled = false;
  User _currentUser;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();

  List<Product> productList;

  getList() async {
    prodListCounterCalled = true;
    _handler.getProductsList(token).then((value) {
      productList = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = ModalRoute.of(context).settings.arguments as User;
    token = _currentUser.token;
    print(token);

    if (!prodListCounterCalled) getList();

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
      body: (_currentUser.status == 1)
          ? (productList == null)
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
                      ProductItem(productList[index], token),
                )
          : (_currentUser.status == -1) ? notAllowed() : notAllowedYet(),
    );
  }

  Widget notAllowed() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                'About Flexy : ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            ),
            SizedBox(height: 10.0),
            Divider(),
            Container(
              width: double.infinity,
              child: Text(
                'You have been banned by admin! Please contact XXXXXXXXXX',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  Widget notAllowedYet() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                'About Flexy : ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            ),
            SizedBox(height: 10.0),
            Divider(),
            Container(
              width: double.infinity,
              child: Text(
                'Categories : ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text('List of categories go here'),
          ],
        ),
      );

  void handleClick(String value) {
    switch (value) {
      case 'My Orders':
        Navigator.of(context).pushNamed(
          MyOrdersScreen.routeName,
          arguments: token,
        );
        break;
      case 'LogOut':
        _handler.logOut(token).then((loggedOut) {
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

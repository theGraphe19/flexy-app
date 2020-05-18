import 'package:flutter/material.dart';

import '../widgets/product_item.dart';
import '../HTTP_handler.dart';
import '../models/product.dart';
import './my_orders_screen.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String token = '';
  var prodListCounterCalled = false;

  List<Product> productList = [];

  getList() async {
    prodListCounterCalled = true;
    HTTPHandler().getProductsList(token).then((value) {
      productList = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    token = ModalRoute.of(context).settings.arguments;
    print(token);
    if (!prodListCounterCalled) getList();
    return Scaffold(
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
      body: GridView.builder(
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
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'My Orders':
        Navigator.of(context).pushNamed(
          MyOrdersScreen.routeName,
          arguments: token,
        );
        break;
      case 'LogOut':
        break;
    }
  }
}

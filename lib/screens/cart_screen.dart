import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HTTP_handler.dart';
import '../widgets/cart_item.dart';
import '../models/cart.dart';
import '../widgets/loading_body.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> items;
  bool itemsHandler = false;

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    if (!itemsHandler) {
      itemsHandler = true;
      _getToken().then((String token) {
        HTTPHandler().getCartItems(token).then((value) {
          items = value;
          setState(() {});
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: (items == null)
          ? LoadingBody()
          : Container(
              padding: const EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) =>
                    CartItem(items[index]),
              ),
            ),
    );
  }
}

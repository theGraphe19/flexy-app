import 'package:flutter/material.dart';

import '../HTTP_handler.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    HTTPHandler().getCartItems('MZqXyfF8LGtry8Fd5YCqQRrOnZULg3svg9d38qj26TWh55JGMYDtk1XsNY64');
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Center(child: Text('Here goes the products'),),
    );
  }
}

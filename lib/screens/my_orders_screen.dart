import 'package:flutter/material.dart';

import '../HTTP_handler.dart';
import '../models/order.dart';
import '../widgets/my_order_item.dart';

class MyOrdersScreen extends StatefulWidget {
  static const routeName = '/my-orders-screen';

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Order> myOrders = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var orderController = false;

  String token;

  void _getMyOrders() {
    orderController = true;
    HTTPHandler().getMyOrders(token).then((value) {
      myOrders = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    token = ModalRoute.of(context).settings.arguments;
    print('Token : $token');

    if (orderController == false) _getMyOrders();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: (myOrders.isNotEmpty)
            ? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: myOrders.length,
                itemBuilder: (BuildContext context, int index) =>
                    MyOrderItem(myOrders[index], scaffoldKey, token),
              )
            : Center(
                child: Text(
                  'You have no orders',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25.0,
                  ),
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../HTTP_handler.dart';
import '../models/order_details.dart';
import '../widgets/loading_body.dart';
import '../widgets/my_order_item.dart';

class MyOrderDetailsScreen extends StatefulWidget {
  static const routeName = '/my-order-details-screen';

  @override
  _MyOrderDetailsScreenState createState() => _MyOrderDetailsScreenState();
}

class _MyOrderDetailsScreenState extends State<MyOrderDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int orderId;
  bool orderController = false;
  String token;
  List<OrderDetails> orders;

  void _getOrderDetails() {
    orderController = true;
    HTTPHandler().getOrderDetails(token, orderId).then((value) {
      this.orders = value;
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context).settings.arguments as List<dynamic>;
    token = data[0];
    orderId = data[1];

    if (!orderController) _getOrderDetails();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Order Details'),
        ),
        body: (orders == null)
            ? LoadingBody()
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: orders.length,
                  itemBuilder: (BuildContext context, int index) => MyOrderItem(
                    orders[index],
                    _scaffoldKey,
                    token,
                  ),
                ),
              ));
  }
}

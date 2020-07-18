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
  List<Order> myOrders;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var orderController = false;

  String token;

  void _getMyOrders() {
    orderController = true;
    HTTPHandler().getMyOrders(token).then((value) {
      myOrders = value;
      setState(() {});
    }).catchError((e) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Network error!', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xff6c757d),
        duration: Duration(seconds: 3),
      ));
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
        child: (myOrders != null)
            ? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: myOrders.length,
                itemBuilder: (BuildContext context, int index) =>
                    MyOrderItem(myOrders[index], scaffoldKey, token),
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset('assets/images/wait.png'),
                    ),
                    Text(
                      'You have no orders yet!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

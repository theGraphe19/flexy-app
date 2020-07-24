import 'package:flutter/material.dart';

import '../HTTP_handler.dart';
import '../models/order_details.dart';
import '../widgets/loading_body.dart';
import '../widgets/my_order_item.dart';
import './bill_screen.dart';

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
                itemBuilder: (BuildContext context, int index) {
                  if (orders[index].quantity != '0')
                    return MyOrderItem(
                      orders[index],
                      _scaffoldKey,
                      token,
                    );
                  else
                    return Container();
                },
              ),
            ),
      floatingActionButton: GestureDetector(
        onTap: () {
          print('tapped : ${orders[0].billId}');
          Navigator.of(context).pushNamed(
            BillScreen.routeName,
            arguments: orders[0],
          );
        },
        child: Container(
          height: 70.0,
          width: 70.0,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Image.asset("assets/images/download.png"),
        ),
      ),
    );
  }
}

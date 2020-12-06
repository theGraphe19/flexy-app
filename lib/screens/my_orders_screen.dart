import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';
import '../HTTP_handler.dart';
import '../models/order.dart';
import './my_order_details_screen.dart';
import './categories_screen.dart';

/*
  <a target="_blank" href="https://icons8.com/icons/set/bill">Bill icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
 */

class MyOrdersScreen extends StatefulWidget {
  static const routeName = '/my-orders-screen';

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Order> myOrders;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var orderController = false;
  User _currentUser;

  void _getMyOrders() {
    orderController = true;
    HTTPHandler().getMyOrders(_currentUser.token).then((value) {
      myOrders = value;
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
    _currentUser = ModalRoute.of(context).settings.arguments as User;
    print('Token : ${_currentUser.token}');

    if (orderController == false) _getMyOrders();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Text('My Orders'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
              CategoriesScreen.routeName,
              (Route<dynamic> route) => false,
              arguments: _currentUser,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Image.asset(
                      'assets/images/bill.png',
                      height: 60.0,
                      width: 60.0,
                    ),
                    title: Text('Order : ${myOrders[index].id.toString()}'),
                    subtitle: Text(
                        'Placed on : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(myOrders[index].timeStamp))}'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => Navigator.of(context).pushNamed(
                          MyOrderDetailsScreen.routeName,
                          arguments: <dynamic>[
                            _currentUser,
                            myOrders[index].id,
                          ]),
                    ),
                  );
                })
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

import 'package:flexy/widgets/check_out_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HTTP_handler.dart';
import '../models/cart.dart';
import '../widgets/loading_body.dart';

class CheckOutFromCart extends StatefulWidget {
  static const routeName = '/check-out-screen';

  @override
  CheckOutFromCartState createState() => CheckOutFromCartState();
}

class CheckOutFromCartState extends State<CheckOutFromCart> {
  List<Cart> items;
  bool itemsHandler = false;
  String token;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int grandTotal = 0;

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
          setState(() {
            for (Cart cart in items) {
              grandTotal += cart.productPrice;
            }
          });
        });
      });
    }
    _getToken().then((value) {
      setState(() {
        token = value;
      });
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Confirm Order'),
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
                    CheckOutItem(items[index], this, index, token, scaffoldKey),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Confirm Order for : Rs. $grandTotal'),
        icon: Icon(Icons.done),
      ),
    );
  }
}

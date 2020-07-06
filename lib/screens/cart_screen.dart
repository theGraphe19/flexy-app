import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../HTTP_handler.dart';
import '../widgets/cart_item.dart';
import '../models/cart.dart';
import '../widgets/loading_body.dart';
import '../screens/check_out_screen.dart';
import '../models/user.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  List<Cart> items;
  User currentUser;
  bool itemsHandler = false;
  String token;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    if (!itemsHandler) {
      currentUser = ModalRoute.of(context).settings.arguments as User;
      itemsHandler = true;
      _getToken().then((String token) {
        HTTPHandler().getCartItems(token).then((value) {
          items = value;
          setState(() {});
        }).catchError((e) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Network error!', style: TextStyle(color: Colors.white),),
            backgroundColor: Color(0xff6c757d),
            duration: Duration(seconds: 3),
          ));
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
        title: Text('Cart'),
      ),
      body: (items == null)
          ? LoadingBody()
          : (items != null && items.length != 0)
              ? Container(
                  padding: const EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) => CartItem(
                        items[index], this, index, token, scaffoldKey, 1),
                  ),
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
                        'No items added!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (items.isEmpty) {
            Toast.show(
              "Please add items to cart first!",
              context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER,
            );
          } else {
            setState(() {
              Navigator.of(context).pushNamed(
                CheckOutFromCart.routeName,
                arguments: currentUser,
              );
            });
          }
        },
        label: Text('CheckOut From Cart'),
        icon: Icon(Icons.payment),
      ),
    );
  }
}

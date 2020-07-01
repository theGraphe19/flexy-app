import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';
import '../screens/cart_screen.dart';
import '../HTTP_handler.dart';

class CartItem extends StatelessWidget {
  Cart item;
  CartScreenState _parent;
  int index;

  CartItem(this.item, this._parent, this.index);

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: InkWell(
          onTap: () {
            print("Tap - In Cart");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Row(children: [
                Image(
                    image: AssetImage('assets/icon/icon.png'),
                    fit: BoxFit.cover,
                    height: 75.0,
                    width: 75.0),
                SizedBox(width: 10.0),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.productName,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold)),
                  Text("x${item.quantity}        Size : ${item.productSize}",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15.0,
                          color: Colors.grey))
                ])
              ])),
              IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.black,
                  onPressed: () {
                    _parent.setState(() {
                      _parent.items.removeAt(index);
                      _getToken().then((value) {
                        HTTPHandler().removeFromCart(value, item.id.toString());
                      });
                    });
                  })
            ],
          )),
    );
  }
}

import 'package:flexy/models/product_color.dart';
import 'package:flexy/models/product_details.dart';
import 'package:flexy/models/product_size.dart';
import 'package:flexy/screens/check_out_screen.dart';
import 'package:flexy/utils/cart_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';
import '../screens/cart_screen.dart';
import '../HTTP_handler.dart';

class CheckOutItem extends StatelessWidget {
  Cart item;
  CheckOutFromCartState _parent;
  int index;
  String token;
  final GlobalKey<ScaffoldState> scaffoldKey;
  ProductDetails productDetails;

  CheckOutItem(
      this.item, this._parent, this.index, this.token, this.scaffoldKey);

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Item ${index+1} :",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text(
                  "Name : ${item.productName}",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "Size : ${item.productSize}",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                      color: Colors.grey),
                ),
                Text(
                  "Quantity : x${item.quantity}",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                      color: Colors.grey),
                ),
                Divider(thickness: 2.0, color: Colors.grey,),
                Text(
                  "Total Price : ${item.productPrice * item.quantity} (${item.productPrice} * ${item.quantity})",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                      color: Colors.grey),
                ),
              ]),
        ),
      ),
    );
  }
}

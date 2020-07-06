import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../utils/dailod_cart_utils.dart';
import '../screens/check_out_screen.dart';
import '../models/product_details.dart';

class CheckOutItem extends StatelessWidget {
  Cart item;
  CheckOutFromCartState _parent;
  int index;
  String token;
  final GlobalKey<ScaffoldState> scaffoldKey;
  ProductDetails productDetails;

  CheckOutItem(
    this.item,
    this._parent,
    this.index,
    this.token,
    this.scaffoldKey,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: GestureDetector(
        onTap: () {
          DialogCartUtils().showCustomDialog(context,
              title: "Product Details", item: item, scaffoldKey: scaffoldKey);
        },
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
                    "Item ${index + 1} :",
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
                  Divider(
                    thickness: 2.0,
                    color: Colors.grey,
                  ),
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
      ),
    );
  }
}

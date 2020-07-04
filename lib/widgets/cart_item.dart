import 'package:flexy/models/product_color.dart';
import 'package:flexy/models/product_details.dart';
import 'package:flexy/models/product_size.dart';
import 'package:flexy/utils/cart_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';
import '../screens/cart_screen.dart';
import '../HTTP_handler.dart';

class CartItem extends StatelessWidget {
  Cart item;
  CartScreenState _parent;
  int index;
  String token;
  final GlobalKey<ScaffoldState> scaffoldKey;
  ProductDetails productDetails;
  CartItem(this.item, this._parent, this.index, this.token, this
  .scaffoldKey);

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
          child: Column(
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
                  Text("x${item.quantity}        Size : ${item.productSize}      ID : ${item.id} + ${item.productId}",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15.0,
                          color: Colors.grey))
                ])
              ])),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.update),
                    color: Colors.black,
                    onPressed: () {
                      print("Update Order");
                      print(item.id);
                      HTTPHandler().getProductDetails(item.productId, token).then((value) {
                        productDetails = value;
                        print(productDetails.product.name);
                        var colorList = new List<List<String>>();
                        var qtyList = new List<List<int>>();
                        for (ProductSize productSize in productDetails.product.productSizes) {
                          var temp1 = new List<String>();
                          var temp2 = new List<int>();
                          for (ProductColor productColor in productSize.colors) {
                            if (!temp1.contains(productColor.color)) {
                              temp1.add(productColor.color);
                              temp2.add(productColor.quantity);
                            }
                          }
                          colorList.add(temp1);
                          qtyList.add(temp2);
                        }
                        CartBottomSheet().showBottomSheet(
                            context,
                            productDetails.product,
                            scaffoldKey,
                            colorList,
                            qtyList,
                            token,
                            true
                        );
                      });
                    },
                  ),
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
                    },
                  ),
                ],
              ),
              Divider(),
            ],
          )),
    );
  }
}

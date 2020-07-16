import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';
import '../screens/cart_screen.dart';
import '../HTTP_handler.dart';
import '../screens/product_details_screen.dart';
import '../models/product_details.dart';

class CartItem extends StatelessWidget {
  Cart item;
  CartScreenState _parent;
  int index;
  String token;
  final GlobalKey<ScaffoldState> scaffoldKey;
  ProductDetails productDetails;
  int categoryId;

  CartItem(this.item, this._parent, this.index, this.token, this.scaffoldKey,
      this.categoryId);

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
          /*border: Border.all(color: Colors.grey, width: 1.0),*/
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(children: [
                Image.network(
                    'https://developers.thegraphe.com/flexy/storage/app/product_images/${item.productImages[0]}',
                    fit: BoxFit.fill,
                    height: 120.0,
                    width: 90.0),
                SizedBox(width: 10.0),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (item.productName.length > 15)
                            ? "Name : ${item.productName.substring(0, 15)}..."
                            : "Name : ${item.productName}",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Quantity : x${item.quantity}",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey),
                      ),
                      Text(
                        "Size : ${item.productSize}",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey),
                      ),
                      Text(
                        "Color : ${item.colorName}",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey),
                      ),
                      Text(
                        "Net Price : ${item.productPrice * item.quantity} (${item.productPrice} * ${item.quantity})",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey),
                      ),
                    ]),
              ]),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        print("Update Order");
                        print(item.id);
                        HTTPHandler()
                            .getProductDetails(item.productId, token)
                            .then((value) {
                          productDetails = value;
                          Navigator.of(context).pushNamed(
                            ProductDetailsScreen.routeName,
                            arguments: <dynamic>[
                              productDetails.product,
                              token,
                              categoryId,
                              _parent.currentUser,
                              true,
                              _parent
                            ],
                          );
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
                      },
                      child: Container(
                        height: 40.0,
                        child: Center(
                          child: Text(
                            "Update Order",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 30.0,
                    width: 1.0,
                    color: Colors.black12,
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _parent.setState(() {
                          _parent.items.removeAt(index);
                          _getToken().then((value) {
                            HTTPHandler()
                                .removeFromCart(value, item.id.toString()).catchError((e) {
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  'Network error!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Color(0xff6c757d),
                                duration: Duration(seconds: 3),
                              ));
                            });
                          });
                        });
                      },
                      child: Container(
                        height: 40.0,
                        child: Center(
                          child: Text(
                            "Delete",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 2.0,),
            ],
          ),
        ),
      ),
    );
  }
}

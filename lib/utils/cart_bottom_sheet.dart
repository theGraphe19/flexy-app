import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_size.dart';
import '../HTTP_handler.dart';

class CartBottomSheet {
  void showBottomSheet(
      BuildContext newContext,
      Product product,
      GlobalKey<ScaffoldState> scaffoldKey,
      List<List<String>> colorList,
      List<List<int>> qtyList,
      String token,
      bool isAnUpdate) async {
    final sizeList = product.productSizes;
    int quantitySelected = 1;
    PersistentBottomSheetController _controller;
    String sizeSelected = sizeList[0].size;
    String colorSelected = colorList[0][0];
    var someList = colorList[0];
    int someInt1 = 0, someInt2 = 0;
    _controller = scaffoldKey.currentState.showBottomSheet((newContext) {
      return Container(
        decoration: BoxDecoration(
          /*border: Border.all(color: Colors.grey),*/
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Color(0xfff0f0f0),
        ),
        height: 400.0,
        padding: const EdgeInsets.all(13.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  product.name,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(newContext).pop(),
                )
              ],
            ),
            SizedBox(height: 15.0),
            DropdownButton<String>(
              value: sizeSelected,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 40,
              elevation: 30,
              isExpanded: true,
              dropdownColor: Colors.white,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                _controller.setState(() {
                  someInt1 = sizeList.indexWhere(
                      (element) => (element.size.contains(newValue) &&
                          newValue.contains(element.size)),
                      0);
                  sizeSelected = newValue;
                  someList = colorList[someInt1];
                  colorSelected = colorList[someInt1][0];
                });
              },
              items:
                  sizeList.map<DropdownMenuItem<String>>((ProductSize value) {
                return DropdownMenuItem<String>(
                  value: value.size,
                  child: Text(
                    value.size,
                    style: TextStyle(fontSize: 15.0),
                  ),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: colorSelected,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 40,
              elevation: 30,
              isExpanded: true,
              dropdownColor: Colors.white,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                _controller.setState(() {
                  colorSelected = newValue;
                  someInt2 = colorList[someInt1].indexOf(newValue);
                });
              },
              items: someList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 20.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Color(
                                  int.parse(value.substring(1, 7), radix: 16) +
                                      0xFF000000)),
                        ),
                      ],
                    ));
              }).toList(),
            ),
            SizedBox(height: 40.0),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Select Quantity : ',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 50.0,
                    margin: const EdgeInsets.only(bottom: 5.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _controller.setState(() {
                              if (quantitySelected > 1) quantitySelected--;
                            });
                          },
                          child: Icon(
                            Icons.indeterminate_check_box,
                            size: 40.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          quantitySelected.toString(),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller.setState(() {
                              if (quantitySelected <
                                  product
                                      .productSizes[someInt1]
                                      .colors[someInt2]
                                      .quantity) quantitySelected++;
                            });
                          },
                          child: Icon(
                            Icons.add_box,
                            size: 40.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (isAnUpdate == false) {
                    print(
                        '$token => ${product.productId} => $sizeSelected => ${quantitySelected.toString()} => $colorSelected');
                    HTTPHandler()
                        .addToCart(
                      token,
                      product.productId.toString(),
                      sizeSelected,
                      quantitySelected.toString(),
                      colorSelected,
                    )
                        .then((value) {
                      Navigator.of(newContext).pop();
                      if (value == true) {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Product Added to Your Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 3),
                        ));
                      } else {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Failed to Add the Product to the Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 3),
                        ));
                      }
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
                  } else {
                    print(
                        '$token => ${product.productId} => $sizeSelected => ${quantitySelected.toString()} => $colorSelected');
                    HTTPHandler()
                        .updateCart(
                      token,
                      product.productId.toString(),
                      sizeSelected,
                      quantitySelected.toString(),
                      colorSelected,
                    )
                        .then((value) {
                      Navigator.of(newContext).pop();
                      if (value == true) {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Cart Updated',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 3),
                        ));
                      } else {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Failed to Update Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 3),
                        ));
                      }
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
                },
                child: Container(
                  height: 50.0,
                  child: Center(
                    child: Text(
                      isAnUpdate ? "Update Cart" : "Add to Cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(newContext).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1.0, color: Theme.of(newContext).primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

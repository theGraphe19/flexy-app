import 'package:flexy/HTTP_handler.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../models/product.dart';

class CartBottomSheet {
  void showBottomSheet(
      BuildContext newContext,
      Product product,
      GlobalKey<ScaffoldState> scaffoldKey,
      List<String> sizeList,
      List<List<String>> colorList,
      List<List<int>> qtyList,
      String token) async {
    final qtyNumber = new TextEditingController();
    PersistentBottomSheetController _controller;
    String sizeSelected = sizeList[0];
    String colorSelected = colorList[0][0];
    var someList = colorList[0];
    int someInt1 = 0, someInt2 = 0;
    _controller = scaffoldKey.currentState.showBottomSheet((newContext) {
      return Container(
        color: Colors.blueAccent.withOpacity(0.2),
        height: 400.0,
        padding: const EdgeInsets.all(15.0),
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
                    fontSize: 15.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(newContext).pop(),
                )
              ],
            ),
            Text('Size selector dropdown'),
            DropdownButton<String>(
              value: sizeSelected,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 40,
              elevation: 30,
              isExpanded: true,
              dropdownColor: Colors.white,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String newValue) {
                _controller.setState(() {
                  someInt1 = sizeList.indexOf(newValue);
                  sizeSelected = newValue;
                  someList = colorList[someInt1];
                  colorSelected = colorList[someInt1][0];
                  print(someInt1);
                  print(someList);
                });
              },
              items: sizeList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
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
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String newValue) {
                _controller.setState(() {
                  someInt2 = colorList[someInt1].indexOf(colorSelected);
                  print(someInt2);
                });
              },
              items: someList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 40.0,),
            TextField(
              controller: qtyNumber,
              keyboardType: TextInputType.number,
              decoration: InputDecoration.collapsed(
                hintText: 'Enter Quantity',
              ),
            ),
            SizedBox(height: 40.0,),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  HTTPHandler().addToCart(token, sizeSelected, int.parse(qtyNumber.text), colorSelected).then((value) {
                    if (int.parse(qtyNumber.text) <=
                        qtyList[someInt1][someInt2]) {
                      Toast.show('Added to Cart', newContext);
                    } else {
                      Toast.show('Some Error Occured', newContext);
                    }
                  });
                },
                child: Container(
                  height: 50.0,
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Color(0xff252427),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2.0, color: Color(0xff252427)),
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

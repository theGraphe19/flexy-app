import 'package:flutter/material.dart';

import '../models/product_details.dart';
import '../models/product.dart';
import '../models/product_size.dart';
import '../models/product_color.dart';
import '../HTTP_handler.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();
  BuildContext context;
  ProductDetails productDetails;
  Product product;
  List<ProductSize> size;
  ProductColor color;
  List<int> quantity;
  int price;
  List<ProductColor> colors;

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  int _getTotalQuantity(List<int> quantity) {
    int net = 0;
    for (var i in quantity) net += i;

    return net;
  }

  void showCustomDialog(
    BuildContext context, {
    @required String title,
    String okBtnText = "Ok",
    String cancelBtnText = "Cancel",
    ProductDetails productDetails,
    Product product,
    List<ProductSize> size,
    ProductColor color,
    List<int> quantity,
    int price,
    String token,
    GlobalKey<ScaffoldState> scaffoldKey,
    @required List<ProductColor> colors,
  }) {
    this.context = context;
    this.productDetails = productDetails;
    this.product = product;
    this.size = size;
    this.color = color;
    this.quantity = quantity;
    this.price = price;
    this.colors = colors;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(title),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                orderImage(),
                SizedBox(height: 10.0),
                orderDescription(),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(okBtnText),
                onPressed: () {
                  List<Map<String, dynamic>> orderList = [];
                  for (var i = 0; i < quantity.length; i++) {
                    if (quantity[i] != 0) {
                      orderList.add({
                        'size': size[i].size,
                        'quantity': quantity[i],
                      });
                    }
                    print(orderList.toString());
                  }
                  HTTPHandler()
                      .placeOrder(
                    product.productId,
                    token,
                    color.color,
                    orderList,
                  )
                      .then((value) {
                    Navigator.of(context).pop();
                    if (value['status'] == 'success') {
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'Order Placed Successfully!',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xff6c757d),
                        duration: Duration(seconds: 3),
                      ));
                    } else {
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          '${value['messege']}',
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
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(cancelBtnText),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget orderImage() => Container(
        width: 380.0,
        height: 380.0,
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: NetworkImage(
              'https://developers.thegraphe.com/flexy/storage/app/product_images/${product.productImages[0]}',
            ),
            fit: BoxFit.contain,
          ),
        ),
      );

  Widget orderDescription() => Container(
        width: MediaQuery.of(context).size.width -
            160, // 100-width of image, 20*2 - margin, 10*2 - padding
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                productDetails.product.name,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Divider(
              height: 1.5,
              color: Colors.black,
            ),
            SizedBox(height: 5.0),
            orderDescriptiontile('Id', productDetails.product.id.toString()),
            SizedBox(height: 5.0),
            orderDescriptiontile('Category', productDetails.product.category),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (color == null) Text('Color'),
                if (color == null) Text('No Color')
              ],
            ),
            Divider(),
            orderDescriptiontile('Size (Color)', 'Quantity'),
            Divider(),
            Column(
              children: size.map((e) {
                if (quantity[size.indexOf(e, 0)] != 0)
                  return Column(
                    children: <Widget>[
                      orderDescriptiontile(
                          '${size[size.indexOf(e, 0)].size} ( ${colors[size.indexOf(e)].colorName} )',
                          quantity[size.indexOf(e, 0)].toString()),
                    ],
                  );
                else
                  return Container();
              }).toList(),
            ),
            // orderDescriptiontile('Quantity', this.quantity),
            // SizedBox(height: 5.0),
            Divider(),
            orderDescriptiontile(
                'Total Quantity', _getTotalQuantity(quantity).toString()),
          ],
        ),
      );

  Widget orderDescriptiontile(String title, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Text(title)),
          Flexible(
            child: Text(
              value.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
}

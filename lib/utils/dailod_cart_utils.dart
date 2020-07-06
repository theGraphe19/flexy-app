import 'package:flutter/material.dart';

import '../models/cart.dart';

class DialogCartUtils {
  static DialogCartUtils _instance = new DialogCartUtils.internal();
  BuildContext context;
  Cart item;
  String size;
  String color;
  String quantity;
  int price;

  DialogCartUtils.internal();

  factory DialogCartUtils() => _instance;

  void showCustomDialog(
    BuildContext context, {
    @required String title,
    String okBtnText = "Ok",
    Cart item,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    this.context = context;
    this.item = item;
    this.size = item.productSize;
    this.color = item.color;
    this.quantity = item.quantity.toString();
    this.price = item.productPrice;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              height: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  orderImage(),
                  SizedBox(height: 10.0),
                  orderDescription(),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(okBtnText),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget orderImage() => Container(
        height: 350.0,
        width: 400.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: NetworkImage(
              'https://developers.thegraphe.com/flexy/storage/app/product_images/${item.productImages[0]}',
            ),
            fit: BoxFit.contain,
          ),
        ),
      );

  Widget orderDescription() => Flexible(
        child: Container(
          width: MediaQuery.of(context).size.width -
              160, // 100-width of image, 20*2 - margin, 10*2 - padding
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Text(
                  item.productName,
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
              orderDescriptiontile('Id', item.productId.toString()),
              SizedBox(height: 5.0),
              orderDescriptiontile('Size', this.size),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Color'),
                  Container(
                    height: 20.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Color(
                            int.parse(this.color.substring(1, 7), radix: 16) +
                                0xFF000000)),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              orderDescriptiontile('Quantity', this.quantity),
              SizedBox(height: 5.0),
              orderDescriptiontile('Price/Pc', this.price.toString()),
              SizedBox(height: 5.0),
              orderDescriptiontile('Net Amount',
                  (int.parse(quantity) * price).toStringAsFixed(2)),
            ],
          ),
        ),
      );

  Widget orderDescriptiontile(String title, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title),
          Text(
            value.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}

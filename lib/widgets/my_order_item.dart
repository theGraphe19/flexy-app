import 'package:flutter/material.dart';

import '../models/order.dart';

class MyOrderItem extends StatelessWidget {
  Order order = Order();

  MyOrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              order.productName,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            color: Colors.black,
            height: 1.5,
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: titleValue('Size', order.productSize.toString()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: titleValue('Quantity', order.quantity.toString()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: titleValue('Price',
                '${order.amount} ( ${order.pricePerPc} x ${order.quantity} )'),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: orderStatus(order.status),
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget titleValue(String title, String value) => RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$title : ',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black87,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget orderStatus(int status) {
    String text;
    Color color;

    switch (status) {
      case -1:
        text = 'REJECTED';
        color = Colors.red;
        break;
      case 0:
        text = 'PENDING';
        color = Colors.yellow[700];
        break;
      case 1:
        text = 'ACCEPTED';
        color = Colors.green;
        break;
      case 2:
        text = 'DISPATCHED';
        color = Colors.blue;
        break;
      case 3:
        text = 'COMPLETED';
        color = Colors.grey;
        break;
    }

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

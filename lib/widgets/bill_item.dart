import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../models/order.dart';

class BillItem extends StatelessWidget {
  final Bill bill;
  final Order order;

  BillItem(this.bill, this.order);

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
            child: titleValue('Order Id', bill.orderId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: titleValue('Product Id', bill.productId),
          ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: orderStatus(order.status),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () => print('bill download'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Download Bill',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     GestureDetector(
          //       onTap: () {
          //         print('tapped : ${order.id}');
          //         // Navigator.of(context).pushNamed(
          //         //   BillScreen.routeName,
          //         //   arguments: order,
          //         // );
          //       },
          //       child: Padding(
          //         padding: const EdgeInsets.all(10.0),
          //         child: Text(
          //           'Show Bill',
          //           style: TextStyle(
          //             color: Colors.blue[900],
          //             fontSize: 15.0,
          //             fontWeight: FontWeight.bold,
          //             decoration: TextDecoration.underline,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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

    switch (status) {
      case -1:
        text = 'REJECTED';
        break;
      case 0:
        text = 'PENDING';
        break;
      case 1:
        text = 'ACCEPTED';
        break;
      case 2:
        text = 'DISPATCHED';
        break;
      case 3:
        text = 'COMPLETED';
        break;
    }

    return titleValue('Status', text);
  }
}

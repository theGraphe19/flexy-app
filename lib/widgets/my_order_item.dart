import 'package:flexy/HTTP_handler.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../models/order.dart';
import '../screens/bill_screen.dart';

class MyOrderItem extends StatelessWidget {
  Order order = Order();
  GlobalKey<ScaffoldState> scaffoldKey;
  String token;

  MyOrderItem(this.order, this.scaffoldKey, this.token);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print('tapped : ${order.id}');
                  Navigator.of(context).pushNamed(
                    BillScreen.routeName,
                    arguments: order,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Show Bill',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              order.status == 3
                  ? GestureDetector(
                      onTap: () {
                        print("Add Remark");
                        final remark = new TextEditingController();
                        PersistentBottomSheetController _controllerSub =
                            scaffoldKey.currentState
                                .showBottomSheet((newContext) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            height: 200.0,
                            child: Column(
                              children: [
                                TextField(
                                  controller: remark,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Remark',
                                  ),
                                ),
                                SizedBox(height: 40.0),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      if (remark.text.isNotEmpty) {
                                        HTTPHandler()
                                            .addRemarks(order.productId, token,
                                                remark.text)
                                            .then((value) {
                                          print(value);
                                          Navigator.of(context).pop();
                                          if (value == 1) {
                                            scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text('Remark Added!'),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 3),
                                            ));
                                          } else if (value == -1) {
                                            scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text('Remark already added!'),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 3),
                                            ));
                                          } else {
                                            scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text('Failed to Add Remark!'),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 3),
                                            ));
                                          }
                                        }).catchError((e) {
                                          print('Error => $e');
                                        });
                                      } else {
                                        Toast.show(
                                            'Enter a Valid Remark', newContext);
                                      }
                                    },
                                    child: Container(
                                      height: 50.0,
                                      child: Center(
                                        child: Text(
                                          "Add Remark",
                                          style: TextStyle(
                                              color: Color(0xff252427),
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 1.0,
                                            color: Color(0xff252427)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Add Remark',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: orderStatus(order.status),
                    ),
            ],
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

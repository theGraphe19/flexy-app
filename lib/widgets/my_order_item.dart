import 'package:flexy/HTTP_handler.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../models/order.dart';
import '../screens/bill_screen.dart';

/* 
  <a target="_blank" href="https://icons8.com/icons/set/in-transit">In Transit icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
  <a target="_blank" href="https://icons8.com/icons/set/hourglass">Hourglass icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
  <a target="_blank" href="https://icons8.com/icons/set/inspection">Inspection icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
  <a target="_blank" href="https://icons8.com/icons/set/download">Download icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
*/

class MyOrderItem extends StatelessWidget {
  Order order = Order();
  GlobalKey<ScaffoldState> scaffoldKey;
  String token;

  MyOrderItem(this.order, this.scaffoldKey, this.token);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(children: [
                    Image.asset(
                      "assets/images/user.png",
                      height: 120.0,
                      width: 90.0,
                    ),
                    /*
                      Image.network(
                          'https://developers.thegraphe.com/flexy/storage/app/product_images/${order.productImages[0]}',
                          fit: BoxFit.fill,
                          height: 120.0,
                          width: 90.0),*/
                    SizedBox(width: 10.0),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name : ${order.productName}",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Quantity : x${order.quantity}",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey),
                          ),
                          Text(
                            "Rate : ${order.pricePerPc}",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey),
                          ),
                          Text(
                            "Net Amount : Rs. ${order.amount} (${order.pricePerPc} * ${order.quantity})",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey),
                          ),
                        ]),
                  ]),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                print('tapped : ${order.id}');
                Navigator.of(context).pushNamed(
                  BillScreen.routeName,
                  arguments: order,
                );
              },
              child: CircleAvatar(
                radius: 18.0,
                child: Image.asset("assets/images/download.png"),
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 10,
            child: GestureDetector(
              onTap: () {
                if (order.status == 3) {
                  print("Add Remark");
                  final remark = new TextEditingController();
                  PersistentBottomSheetController _controllerSub =
                      scaffoldKey.currentState.showBottomSheet((newContext) {
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
                                fontSize: 15.0, fontWeight: FontWeight.w400),
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
                                      .addRemarks(
                                          order.productId, token, remark.text)
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
                                        content: Text('Remark already added!'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3),
                                      ));
                                    } else {
                                      scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text('Failed to Add Remark!'),
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
                                      width: 1.0, color: Color(0xff252427)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                }
              },
              child: CircleAvatar(
                radius: 18.0,
                child: orderStatusImage(order.status),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: orderStatus(order.status),
          ),
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
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget orderStatusImage(int status) {
    String someVal = "assets/images/";

    switch (status) {
      case -1:
        someVal += "rejected.png";
        break;
      case 0:
        someVal += "pending.png";
        break;
      case 1:
        someVal += "accepted.png";
        break;
      case 2:
        someVal += "dispatched.png";
        break;
      case 3:
        someVal += "completed.png";
        break;
    }

    return Image.asset(someVal);
  }
}

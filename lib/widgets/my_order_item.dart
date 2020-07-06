import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../models/order.dart';
import '../models/product_details.dart';
import '../screens/bill_screen.dart';
import '../HTTP_handler.dart';
import './loading_body.dart';

/* 
  <a target="_blank" href="https://icons8.com/icons/set/in-transit">In Transit icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
  <a target="_blank" href="https://icons8.com/icons/set/hourglass">Hourglass icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
  <a target="_blank" href="https://icons8.com/icons/set/inspection">Inspection icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
  <a target="_blank" href="https://icons8.com/icons/set/download">Download icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
*/

class MyOrderItem extends StatefulWidget {
  Order order = Order();
  GlobalKey<ScaffoldState> scaffoldKey;
  String token;

  MyOrderItem(this.order, this.scaffoldKey, this.token);

  @override
  _MyOrderItemState createState() => _MyOrderItemState();
}

class _MyOrderItemState extends State<MyOrderItem> {
  HTTPHandler _handler = HTTPHandler();

  ProductDetails _productDetails;
  bool productsHandler = false;

  getProductDetails() {
    productsHandler = true;
    _handler
        .getProductDetails(int.parse(widget.order.productId), widget.token)
        .then((value) {
      _productDetails = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!productsHandler) getProductDetails();

    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: (_productDetails == null)
          ? LoadingBody()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
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
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                    'https://developers.thegraphe.com/flexy/storage/app/product_images/${_productDetails.product.productImages[0]}',
                                    fit: BoxFit.fill,
                                    height: 180.0,
                                    width: 120.0),
                                SizedBox(width: 10.0),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (widget.order.productName.length > 15)
                                            ? "Name : ${widget.order.productName.substring(0, 17)}..."
                                            : "Name : ${widget.order.productName}",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Quantity : x${widget.order.quantity}",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15.0,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "Rate : ${widget.order.pricePerPc}",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15.0,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "Net Amount : Rs. ${widget.order.amount} (${widget.order.pricePerPc} * ${widget.order.quantity})",
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
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                      bottom: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  print('tapped : ${widget.order.id}');
                                  Navigator.of(context).pushNamed(
                                    BillScreen.routeName,
                                    arguments: widget.order,
                                  );
                                },
                                child: Container(
                                  height: 60.0,
                                  width: 60.0,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child:
                                      Image.asset("assets/images/download.png"),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Download',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.order.status == 3) {
                                    print("Add Remark");
                                    final remark = new TextEditingController();
                                    widget.scaffoldKey.currentState
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
                                                    _handler
                                                        .addRemarks(
                                                            widget.order
                                                                .productId,
                                                            widget.token,
                                                            remark.text)
                                                        .then((value) {
                                                      print(value);
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (value == 1) {
                                                        widget.scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              'Remark Added!', style: TextStyle(color: Colors.white),),
                                                                  backgroundColor: Color(0xff6c757d),
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ));
                                                      } else if (value == -1) {
                                                        widget.scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              'Remark already added!', style: TextStyle(color: Colors.white),),
                                                                  backgroundColor: Color(0xff6c757d),
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ));
                                                      } else {
                                                        widget.scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              'Failed to Add Remark!', style: TextStyle(color: Colors.white),),
                                                                  backgroundColor: Color(0xff6c757d),
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ));
                                                      }
                                                    }).catchError((e) {
                                                      print('Error => $e');
                                                    });
                                                  } else {
                                                    Toast.show(
                                                        'Enter a Valid Remark',
                                                        newContext);
                                                  }
                                                },
                                                child: Container(
                                                  height: 50.0,
                                                  child: Center(
                                                    child: Text(
                                                      "Add Remark",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff252427),
                                                          fontSize: 24.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color:
                                                            Color(0xff252427)),
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
                                child: Container(
                                  height: 60.0,
                                  width: 60.0,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: orderStatusImage(widget.order.status),
                                ),
                              ),
                            ),
                            Container(
                              child: orderStatus(widget.order.status),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

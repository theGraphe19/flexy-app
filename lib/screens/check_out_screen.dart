import 'package:flexy/models/user.dart';
import 'package:flexy/widgets/check_out_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../HTTP_handler.dart';
import '../models/cart.dart';
import '../widgets/loading_body.dart';

class CheckOutFromCart extends StatefulWidget {
  static const routeName = '/check-out-screen';

  @override
  CheckOutFromCartState createState() => CheckOutFromCartState();
}

class CheckOutFromCartState extends State<CheckOutFromCart> {
  List<Cart> items;
  User _currentUser;
  bool itemsHandler = false;
  String token;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int grandTotal = 0;

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    if (!itemsHandler) {
      _currentUser = ModalRoute.of(context).settings.arguments as User;
      itemsHandler = true;
      _getToken().then((String token) {
        HTTPHandler().getCartItems(token).then((value) {
          items = value;
          setState(() {
            grandTotal = 0;
            for (Cart cart in items) {
              grandTotal += cart.productPrice * cart.quantity;
            }
          });
        });
      });
    }
    _getToken().then((value) {
      setState(() {
        token = value;
      });
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Confirm Order'),
      ),
      body: (items == null)
          ? LoadingBody()
          : Container(
              padding: const EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) =>
                    CheckOutItem(items[index], this, index, token, scaffoldKey),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("Enter Mb. Number");
          final mbNumber = new TextEditingController();
          PersistentBottomSheetController _controllerSub =
          scaffoldKey.currentState
              .showBottomSheet((newContext) {
            return Container(
              padding: EdgeInsets.all(16.0),
              height: 200.0,
              child: Column(
                children: [
                  TextField(
                    controller: mbNumber,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: 'Enter Mobile Number',
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        if (mbNumber.text == _currentUser.mobileNo) {
                          itemsHandler = false;
                          _getToken().then((value) {
                            HTTPHandler().placeOrderFromCart(value).then((value) {
                              if (value) {
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Order Placed'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 3),
                                ));
                                setState(() {
                                  itemsHandler = false;
                                  items = null;
                                });
                              } else {
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Failed to Place Order'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ));
                                setState(() {
                                  itemsHandler = false;
                                  items = null;
                                });
                              }
                            });
                          });
                        } else {
                          Toast.show(
                              "Mobile Numbers Don't Match!", context);
                        }
                      },
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Place Order",
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
        label: Text('Confirm Order for : Rs. $grandTotal'),
        icon: Icon(Icons.done),
      ),
    );
  }
}
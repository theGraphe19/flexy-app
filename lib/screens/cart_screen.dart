import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

import '../models/product_details.dart';
import '../models/cart.dart';
import '../HTTP_handler.dart';
import '../models/cart_overview.dart';
import '../widgets/loading_body.dart';
import '../models/user.dart';
import './check_out_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  List<CartOverView> items;
  HTTPHandler _handler = HTTPHandler();
  User currentUser;
  bool itemsHandler = false;
  String token;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductDetails productDetails;
  int colorSelected;

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  getCart() {
    _handler.getCartItems(token).then((value) {
      items = value;
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    if (!itemsHandler) {
      currentUser = ModalRoute.of(context).settings.arguments as User;
      itemsHandler = true;
      _getToken().then((String token) {
        this.token = token;
        getCart();
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
        title: Text('Cart'),
      ),
      body: (items == null)
          ? LoadingBody()
          : (items != null && items.length != 0)
              ? Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(bottom: 50.0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Image.asset(
                              'assets/images/bill.png',
                              height: 60.0,
                              width: 60.0,
                            ),
                            title: Text(
                                '${items[index].cartItems[0].productName}'),
                            subtitle: Text(
                                'Added on : ${DateFormat('dd-MM-yyyy').format(items[index].cartItems[0].timeStamp)}'),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: <Widget>[
                                Image.network(
                                  'https://flexyindia.com/administrator/storage/app/product_images/${items[index].cartItems[0].productImages[0]}',
                                  frameBuilder: (BuildContext context,
                                      Widget child,
                                      int frame,
                                      bool wasSynchronouslyLoaded) {
                                    return Center(
                                      child: Container(
                                        width: double.infinity,
                                        height: 300.0,
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                                Divider(),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            print('pressed updat');
                                            _showModal(items[index]);
                                          },
                                          child: Container(
                                            height: 40.0,
                                            color: Colors.pink.withOpacity(0),
                                            child: Center(
                                              child: Text(
                                                "Update Order",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 30.0,
                                        width: 1.0,
                                        color: Colors.black12,
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            _handler
                                                .removeItemFromCart(
                                                    token, items[index].id)
                                                .then((value) {
                                              if (value) {
                                                itemsHandler = false;
                                                scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    'Removed from Cart!',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Color(0xff6c757d),
                                                  duration:
                                                      Duration(seconds: 3),
                                                ));
                                                setState(() {});
                                              } else {
                                                scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    'Error! Try again.',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Color(0xff6c757d),
                                                  duration:
                                                      Duration(seconds: 3),
                                                ));
                                              }
                                            }).catchError((e) {
                                              scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  'Network error!',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor:
                                                    Color(0xff6c757d),
                                                duration: Duration(seconds: 3),
                                              ));
                                            });
                                          },
                                          child: Container(
                                            height: 40.0,
                                            color: Colors.pink.withOpacity(0),
                                            child: Center(
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0),
                        ],
                      );
                    },
                  ),
                )
              : Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset('assets/images/wait.png'),
                      ),
                      Text(
                        'No items added!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (items.isEmpty) {
            Toast.show(
              "Please add items to cart first!",
              context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER,
            );
          } else {
            setState(() {
              Navigator.of(context).pushNamed(
                CheckOutFromCart.routeName,
                arguments: currentUser,
              );
            });
          }
        },
        label: Text('CheckOut From Cart'),
        icon: Icon(Icons.payment),
      ),
    );
  }

  void _showModal(CartOverView item) async {
    List<Map<String, dynamic>> quantityPerSIze = [];
    List<String> deletedIds = [];

    for (Cart c in item.cartItems) {
      quantityPerSIze.add({
        'id': c.id,
        'size': c.productSize,
        'quantity': c.quantity,
        'color': c.color,
        'colorName': c.colorName
      });
    }

    showModalBottomSheet(
      context: scaffoldKey.currentContext,
      builder: (BuildContext context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  // height: double.maxFinite,
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image(
                                  height: 80.0,
                                  width: 80.0,
                                  image: NetworkImage(
                                    'https://flexyindia.com/administrator/storage/app/product_images/${item.cartItems[0].productImages[0]}',
                                  ),
                                ),
                                Text(item.cartItems[0].productName),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.close),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: quantityPerSIze.map((e) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e['size'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 20.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color: Color(int.parse(
                                                  e['color'].substring(1, 7),
                                                  radix: 16) +
                                              0xFF000000),
                                        ),
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        e['colorName'],
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (e['quantity'] >= 2)
                                              e['quantity'] -= 1;
                                          });
                                        },
                                        child: Icon(
                                          Icons.indeterminate_check_box,
                                          size: 30.0,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(e['quantity'].toString()),
                                      SizedBox(width: 10.0),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            e['quantity'] += 1;
                                          });
                                        },
                                        child: Icon(
                                          Icons.add_box,
                                          size: 30.0,
                                        ),
                                      ),
                                      SizedBox(width: 15.0),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            quantityPerSIze.remove(e);
                                            deletedIds.add(e['id'].toString());
                                          });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: 25.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            String updateParam = '';
                            for (var i = 0; i < quantityPerSIze.length; i++) {
                              print('id here');
                              if (i == (quantityPerSIze.length - 1))
                                updateParam += quantityPerSIze[i]['id'].toString() +
                                    '* ' +
                                    quantityPerSIze[i]['quantity'].toString();
                              else
                                updateParam += quantityPerSIze[i]['id'].toString() +
                                    '* ' +
                                    quantityPerSIze[i]['quantity'].toString() +
                                    '** **';
                            }

                            print(updateParam);

                            _handler
                                .updateItemFromCartItem(updateParam)
                                .then((value) {
                              if (value) {
                                String deleteParam = '';
                                for (var i = 0; i < deletedIds.length; i++) {
                                  if (i == (deletedIds.length - 1))
                                    deleteParam += deletedIds[i];
                                  else
                                    deleteParam += deletedIds[i] + '* ';
                                }

                                if (deleteParam == '') {
                                  Navigator.of(context).pop();
                                  getCart();
                                } else {
                                  _handler
                                      .deleteItemFromCartItem(deleteParam)
                                      .then((value) {
                                    Navigator.of(context).pop();
                                    getCart();
                                  }).catchError((e) {
                                    print(e);
                                    scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        'Network error!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Color(0xff6c757d),
                                      duration: Duration(seconds: 3),
                                    ));
                                  });
                                }
                              } else {
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    'Error! Try again.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Color(0xff6c757d),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            }).catchError((e) {
                              print(e);
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  'Network error!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Color(0xff6c757d),
                                duration: Duration(seconds: 3),
                              ));
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../models/product_details.dart';
import '../models/product_size.dart';
import '../utils/form_validator.dart';
import '../widgets/order_item.dart';
import '../HTTP_handler.dart';
import './products_screen.dart';
import '../credentials.dart';

enum OrderState {
  orderPending,
  orderDone,
}

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _remarkController = TextEditingController();
  final _quantityController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductDetails productDetails = ProductDetails();

  HTTPHandler _handler = HTTPHandler();

  List<Map<String, dynamic>> _orders = [];

  String token = '';
  String _size = '';

  ProgressDialog progressDialog;

  OrderState state = OrderState.orderPending;

  List<Map<String, dynamic>> _getDataSource() {
    List<Map<String, dynamic>> _dataSource = [];
    for (var i = 0; i < productDetails.productSizeList.length; i++)
      _dataSource.add({
        "display": productDetails.productSizeList[i].size,
        "value": productDetails.productSizeList[i].size,
      });

    return _dataSource;
  }

  void _confirmOrder() async {
    await progressDialog.show();
    _handler
        .placeOrder(
      productDetails.product.id,
      token,
      _orders,
    )
        .then((response) async {
      await progressDialog.show();
      if (response['status'].contains('success')) {
        setState(() {
          state = OrderState.orderDone;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Order placed!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ));
      } else
        _scaffoldKey.currentState
            .showSnackBar(snackBar('Order couldn\'t be placed'));

      await progressDialog.hide();
    });
    await progressDialog.hide();
  }

  void _addRemarks() async {
    await progressDialog.show();
    print(_remarkController.text);
    _handler
        .addRemarks(
      productDetails.product.id,
      token,
      _remarkController.text,
    )
        .then((value) async {
      await progressDialog.hide();
      if (!value) {
        _scaffoldKey.currentState
            .showSnackBar(snackBar('Remarks couldn\'t be added'));
      } else {
        Navigator.of(context).popAndPushNamed(
          ProductsScreen.routeName,
          arguments: token,
        );
      }
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments as List<dynamic>;

    productDetails = arguments[0];
    token = arguments[1];

    print(productDetails.product.description + token);
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
    progressDialog.style(
      message: 'Please wait!',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title:
            Text((state == OrderState.orderPending) ? 'ORDER' : 'Add a remark'),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.done),
              onPressed: (state == OrderState.orderPending)
                  ? _confirmOrder
                  : _addRemarks,
            ),
          ),
          (state == OrderState.orderPending)
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).popAndPushNamed(
                      ProductsScreen.routeName,
                      arguments: token,
                    ),
                  ),
                ),
        ],
      ),
      body: (state == OrderState.orderPending)
          ? SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          orderImage(),
                          orderDescription(),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      allProducts(),
                      SizedBox(height: 15.0),
                      total(),
                      SizedBox(height: 15.0),
                      addProduct(),
                    ],
                  ),
                ),
              ),
            )
          : remarkScreen(),
    );
  }

  Widget remarkScreen() => Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Leave a remark',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _remarkController,
              decoration: InputDecoration(
                hintText: 'Please add a remark about this product',
              ),
              maxLines: 5,
              minLines: 1,
            ),
          ],
        ),
      );

  Widget orderImage() => Container(
        height: 100.0,
        width: 100.0,
        decoration: BoxDecoration(
          color: Colors.grey[350],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(
              productImagesURL + productDetails.productImages[0],
            ),
            fit: BoxFit.contain,
          ),
        ),
      );

  Widget orderDescription() => Container(
        height: 100.0,
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
            orderDescriptiontile('Type', productDetails.product.productType),
            SizedBox(height: 5.0),
            orderDescriptiontile('Category', productDetails.product.category),
          ],
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

  Widget addProduct() => Column(
        children: <Widget>[
          DropDownFormField(
            titleText: 'Available Size',
            autovalidate: false,
            hintText: 'Please select any one',
            validator: (value) =>
                FormValidator().validateDropDownSelector(value),
            value: _size,
            onSaved: (value) {
              setState(() {
                _size = value;
              });
            },
            onChanged: (value) {
              setState(() {
                _size = value;
              });
            },
            dataSource: _getDataSource(),
            textField: "display",
            valueField: "value",
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
            ),
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.bottomRight,
            child: RaisedButton.icon(
              color: Colors.blue,
              onPressed: () {
                if (_size.isEmpty || _quantityController.text.isEmpty) {
                  _scaffoldKey.currentState
                      .showSnackBar(snackBar('Select size and add quantity'));
                  return;
                }
                var quantity = int.parse(_quantityController.text);

                ProductSize productSize;
                for (var i = 0;
                    i < productDetails.productSizeList.length;
                    i++) {
                  if (productDetails.productSizeList[i].size.contains(_size)) {
                    productSize = productDetails.productSizeList[i];
                    print(productSize.price);
                    break;
                  }
                }

                if (quantity > int.parse(productSize.quantity)) {
                  _scaffoldKey.currentState.showSnackBar(
                      snackBar('Only ${productSize.quantity} available.'));
                  return;
                }

                _orders.add({
                  'size': _size,
                  'quantity': quantity,
                  'price': productSize.price,
                });
                print(_orders.toString());
                _quantityController.text = '';
                setState(() {});
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text(
                'ADD',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      );

  Widget snackBar(String text) => SnackBar(
        content: Text(text),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );

  Widget allProducts() => Flexible(
        fit: FlexFit.tight,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10.0),
              width: double.infinity,
              child: Text(
                'Order Details',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Divider(
              height: 1.5,
              color: Colors.black,
            ),
            SizedBox(height: 10.0),
            Flexible(
              fit: FlexFit.tight,
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (BuildContext context, int index) {
                  return OrderItem(
                    _orders[index]['size'],
                    '${_orders[index]['quantity'].toString()} (${_orders[index]['price']} x ${_orders[index]['quantity']})',
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget total() {
    var totalAmt = 0;

    for (var i = 0; i < _orders.length; i++)
      totalAmt += int.parse(_orders[i]['price']) * _orders[i]['quantity'];

    return Align(
      alignment: Alignment.bottomRight,
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: 'Total amount : ',
            style: TextStyle(color: Colors.black87),
          ),
          TextSpan(
            text: totalAmt.toString(),
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }
}

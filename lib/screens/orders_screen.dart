import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '../models/product_details.dart';
import '../models/product_size.dart';
import '../utils/form_validator.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _quantityController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductDetails productDetails = ProductDetails();

  List<Map<String, dynamic>> _orders = [];

  String _size = '';

  List<Map<String, dynamic>> _getDataSource() {
    List<Map<String, dynamic>> _dataSource = [];
    for (var i = 0; i < productDetails.productSizeList.length; i++)
      _dataSource.add({
        "display": productDetails.productSizeList[i].size,
        "value": productDetails.productSizeList[i].size,
      });

    return _dataSource;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productDetails =
        ModalRoute.of(context).settings.arguments as ProductDetails;

    print(productDetails.product.description);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Text('ORDER'),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.done),
              onPressed: () => print('Confirm Order'),
            ),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
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
    );
  }

  Widget orderImage() => Container(
        height: 100.0,
        width: 100.0,
        decoration: BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(
              'assets/icon/icon.png', //  CHANGE THE IMAGE TO PRODUCT IMAGE
            ),
            fit: BoxFit.cover,
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

                if (quantity > int.parse(productSize.inStock)) {
                  _scaffoldKey.currentState.showSnackBar(
                      snackBar('Only ${productSize.inStock} available.'));
                  return;
                }

                _orders.add({
                  'size': _size,
                  'quantity': quantity,
                  'price': productSize.price,
                });
                print(_orders.toString());
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

  Widget allProducts() => Expanded(
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
            Expanded(
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

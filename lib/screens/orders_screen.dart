import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '../models/product_details.dart';
import '../utils/form_validator.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _quantityController = TextEditingController();
  ProductDetails productDetails = ProductDetails();

  String _size;

  List<Map<String, String>> _getDataSource() {
    List<Map<String, String>> _dataSource = [];
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
            SizedBox(height: 10.0),
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
                onPressed: () => print('add'),
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
}

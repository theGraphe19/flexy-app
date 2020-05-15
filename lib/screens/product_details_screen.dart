import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_image.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';

  Product product;
  ProductImage productImage;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments as List<dynamic>;
    product = arguments[0];
    productImage = arguments[1];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flexy - ${product.name.toUpperCase()}',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[350],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            //IMAGE
            Container(
              width: double.infinity,
              height: 400.0,
              child: Image.asset(
                productImage.productImage,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10.0),
            //NAME
            Text(
              product.name.toUpperCase(),
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            //DESCRIPTION
            Text(product.description),
            SizedBox(height: 10.0),
            //CATEGORY
            titleValue('CATEGORY', product.category),
            SizedBox(height: 10.0),
            //PRODUCT TYPE
            titleValue('TYPE', product.productType),
          ],
        ),
      ),
    );
  }

  Widget titleValue(String title, String value) => RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '${title} : ',
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
}

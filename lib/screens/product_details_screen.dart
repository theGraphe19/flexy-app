import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_details.dart';
import '../HTTP_handler.dart';
import './orders_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product-details-screen';

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product product;
  String token;

  ProductDetails productDetails;

  var currentActiveIndex = 0;

  getProductDetails() {
    HTTPHandler().getProductDetails(product.id, token).then((value) {
      productDetails = value;
      print(productDetails.product.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    product = arguments[0] as Product;
    token = arguments[1] as String;
    print('Token : $token');
    getProductDetails();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flexy - ${product.name.toUpperCase()}',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.grey[350],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: GridTile(
            child: Column(
              children: <Widget>[
                //IMAGE
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 400.0,
                  color: Colors.grey[350],
                  child: Center(
                    child: (product.productImages.length > 0)
                        ? imagePageView()
                        : Text(product.productImages[0]),
                  ),
                  // child: Image.asset(
                  //   productImage.productImage,
                  //   fit: BoxFit.cover,
                  // ),
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
            footer: orderButton(),
          ),
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

  Widget imagePageView() => PageView.builder(
        itemCount: product.productImages.length,
        onPageChanged: (int currentIndex) {
          setState(() {
            currentActiveIndex = currentIndex;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: double.infinity,
            height: 400.0,
            color: Colors.white,
            child: Center(
              child: Text(product.productImages[currentActiveIndex]),
            ),
          );
        },
      );

  Widget orderButton() => GridTileBar(
        backgroundColor: Colors.blue,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              OrdersScreen.routeName,
              arguments: <dynamic>[
                productDetails,
                token,
              ],
            );
          },
          child: Text(
            'ORDER NOW',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      );
}

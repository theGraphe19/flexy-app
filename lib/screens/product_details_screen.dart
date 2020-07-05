import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_details.dart';
import '../HTTP_handler.dart';
import '../widgets/loading_body.dart';
import '../widgets/product_item.dart';
import '../utils/cart_bottom_sheet.dart';
import '../models/product_size.dart';
import '../models/product_color.dart';
import '../utils/order_bottom_sheet.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product-details-screen';

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product product;
  String token;
  int categoryId;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  bool productsController = false;

  ProductDetails productDetails;

  var currentActiveIndex = 0;

  getProductDetails() {
    productsController = true;
    HTTPHandler().getProductDetails(product.productId, token).then((value) {
      productDetails = value;
      print(productDetails.product.name);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    product = arguments[0] as Product;
    token = arguments[1] as String;
    print('Token : $token');
    if (!productsController) getProductDetails();
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          '${product.name}',
        ),
      ),
      body: (productDetails == null)
          ? LoadingBody()
          : Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: <Widget>[
                      //IMAGE
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        height: 400.0,
                        color: Colors.white,
                        child: Center(
                          child: (product.productImages.length > 0)
                              ? imagePageView()
                              : Image.network(
                                  'https://developers.thegraphe.com/flexy/storage/app/product_images/${product.productImages[currentActiveIndex]}'),
                        ),
                      ),
                      orderButton(),
                      SizedBox(height: 10.0),
                      //NAME
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //DESCRIPTION
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                            Divider(),
                            Text(product.description),
                            SizedBox(height: 20.0),
                            Text(
                              "Product Tags",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                            Divider(),
                            Text(product.productTags),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                //CATEGORY
                                titleValue('Category', product.category),
                                SizedBox(width: 10.0),
                                //PRODUCT TYPE
                                //titleValue('TYPE', product.productType),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        padding: EdgeInsets.only(left: 16.0),
                        width: double.infinity,
                        child: Text(
                          'Suggested Products',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          child: GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10.0),
                        itemCount: productDetails.relatedProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2/3.91,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) =>
                            ProductItem(
                          productDetails.relatedProducts[index],
                          token,
                          categoryId,
                          scaffoldKey,
                        ),
                      )),
                    ],
                  ),
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
              child: Image.network(
                  'https://developers.thegraphe.com/flexy/storage/app/product_images/${product.productImages[currentActiveIndex]}'),
              //child: Text(product.productImages[currentActiveIndex]),
            ),
          );
        },
      );

  Widget orderButton() => GridTileBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(width: 30.0),
            GestureDetector(
              onTap: () {
                for (Product prodt in productDetails.relatedProducts) {
                  print(prodt.name + prodt.id);
                }
                var colorList = new List<List<String>>();
                var qtyList = new List<List<int>>();
                for (ProductSize productSize in product.productSizes) {
                  var temp1 = new List<String>();
                  var temp2 = new List<int>();
                  for (ProductColor productColor in productSize.colors) {
                    if (!temp1.contains(productColor.color)) {
                      temp1.add(productColor.color);
                      temp2.add(productColor.quantity);
                    }
                  }
                  colorList.add(temp1);
                  qtyList.add(temp2);
                }
                OrderBottomSheet().showBottomSheet(
                  context,
                  product,
                  scaffoldKey,
                  colorList,
                  qtyList,
                  token,
                  productDetails,
                );
              },
              child: Text(
                'ORDER NOW',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                for (Product prodt in productDetails.relatedProducts) {
                  print(prodt.name + prodt.id);
                }
                var colorList = new List<List<String>>();
                var qtyList = new List<List<int>>();
                for (ProductSize productSize in product.productSizes) {
                  var temp1 = new List<String>();
                  var temp2 = new List<int>();
                  for (ProductColor productColor in productSize.colors) {
                    if (!temp1.contains(productColor.color)) {
                      temp1.add(productColor.color);
                      temp2.add(productColor.quantity);
                    }
                  }
                  colorList.add(temp1);
                  qtyList.add(temp2);
                }
                CartBottomSheet().showBottomSheet(context, product, scaffoldKey,
                    colorList, qtyList, token, false);
              },
              child: Text(
                'Add To Cart',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(width: 30.0),
          ],
        ),
      );
}

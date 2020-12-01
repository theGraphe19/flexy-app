import 'package:flexy/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../HTTP_handler.dart';
import '../models/category.dart';
import '../screens/product_details_screen.dart';
import '../utils/cart_bottom_sheet.dart';
import '../models/product.dart';
import '../models/product_color.dart';
import '../models/product_size.dart';
import '../providers/product_provider.dart';
import '../providers/favourite_product_provider.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final int productIndex;
  final User user;
  final Category category;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isWishList;

  ProductItem(
    this.product,
    this.productIndex,
    this.user,
    this.category,
    this.scaffoldKey,
    this.isWishList,
  );

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  SharedPreferences prefs;
  bool retreiveDataHandler = false;
  ProductProvider _productProvider;

  @override
  Widget build(BuildContext context) {
    _productProvider = Provider.of<ProductProvider>(context);

    return (widget.isWishList &&
            !(_productProvider.productsList[widget.productIndex].isFav))
        ? SizedBox()
        : GestureDetector(
            onTap: () {
              _productProvider.productList =
                  _productProvider.productsListDuplicate;
              Navigator.of(context).pushNamed(
                ProductDetailsScreen.routeName,
                arguments: <dynamic>[
                  widget.product,
                  widget.user.token,
                  widget.category,
                  widget.user
                ],
              );
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://developers.thegraphe.com/flexy/storage/app/product_images/${_productProvider.productsList[widget.productIndex].productImages[0]}',
                      fit: BoxFit.contain,
                      height: 245.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Text(
                      _productProvider.productsList[widget.productIndex].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Text(
                      '${_productProvider.productsList[widget.productIndex].tagline}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (_productProvider
                          .productsList[widget.productIndex].tagline.length <=
                      15)
                    SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          var colorList = new List<List<String>>();
                          var qtyList = new List<List<int>>();
                          for (ProductSize productSize in _productProvider
                              .productsList[widget.productIndex].productSizes) {
                            var temp1 = new List<String>();
                            var temp2 = new List<int>();
                            for (ProductColor productColor
                                in productSize.colors) {
                              if (!temp1.contains(productColor.color)) {
                                temp1.add(productColor.color);
                                temp2.add(productColor.quantity);
                              }
                            }
                            colorList.add(temp1);
                            qtyList.add(temp2);
                          }
                          CartBottomSheet(_productProvider
                                  .productsList[widget.productIndex])
                              .showBottomSheet(context, widget.scaffoldKey,
                                  colorList, qtyList, widget.user.token, false);
                        },
                      ),
                      Container(
                        height: 20.0,
                        width: 2.0,
                        color: Colors.black12,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: (_productProvider
                                  .productsList[widget.productIndex].isFav)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          print('pressed');
                          HTTPHandler()
                              .addFavourite(widget.user.id.toString(),
                                  widget.product.productId.toString())
                              .then((value) {
                            print(value);
                            if (value) {
                              _productProvider.productsList[widget.productIndex]
                                  .isFav = true;
                              widget.scaffoldKey.currentState
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  'Added to wishlist!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Color(0xff6c757d),
                                duration: Duration(seconds: 2),
                              ));
                              setState(() {});
                              widget.scaffoldKey.currentState.setState(() {});
                            }
                          }).catchError((e) {
                            print(e);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

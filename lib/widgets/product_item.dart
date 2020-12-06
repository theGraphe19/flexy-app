import 'package:flexy/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../models/wishlist.dart';
import '../HTTP_handler.dart';
import '../models/category.dart';
import '../screens/product_details_screen.dart';
import '../utils/cart_bottom_sheet.dart';
import '../models/product.dart';
import '../models/product_color.dart';
import '../models/product_size.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final User user;
  final Category category;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isWishlist;

  ProductItem(
    this.product,
    this.user,
    this.category,
    this.scaffoldKey,
    this.isWishlist,
  );

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  SharedPreferences prefs;
  bool retreiveDataHandler = false;
  ProductProvider _productProvider;
  WishlistProvider _wishlistProvider;
  HTTPHandler _handler = HTTPHandler();

  bool check() {
    for (Wishlist w in _wishlistProvider.wishList) {
      if (w.product.product.id == widget.product.id) return true;
    }

    return false;
  }

  Wishlist getWishList() {
    for (Wishlist w in _wishlistProvider.wishList) {
      if (w.product.product.id == widget.product.id) return w;
    }
  }

  @override
  Widget build(BuildContext context) {
    _productProvider = Provider.of<ProductProvider>(context);
    _wishlistProvider = Provider.of<WishlistProvider>(context);

    return (widget.isWishlist && !check())
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
                      'https://developers.thegraphe.com/flexy/storage/app/product_images/${widget.product.productImages[0]}',
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
                      widget.product.name,
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
                      '${widget.product.tagline}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
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
                          for (ProductSize productSize
                              in widget.product.productSizes) {
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
                          CartBottomSheet(widget.product).showBottomSheet(
                              context,
                              widget.scaffoldKey,
                              colorList,
                              qtyList,
                              widget.user.token,
                              false);
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
                          color: (check()) ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          print('pressed');
                          if (check()) {
                            Wishlist w = getWishList();
                            _handler
                                .removeItemFromWishList(
                              context,
                              widget.user.id.toString(),
                              w.id.toString(),
                            )
                                .then((value) {
                              _wishlistProvider.removeItem(w);
                              widget.scaffoldKey.currentState
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  'Removed from wishlist!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Color(0xff6c757d),
                                duration: Duration(seconds: 2),
                              ));
                              setState(() {});
                              widget.scaffoldKey.currentState.setState(() {});
                            }).catchError((e) {
                              print(e);
                            });
                          } else {
                            _handler
                                .addFavourite(
                              context,
                              widget.user.id.toString(),
                              widget.product.productId.toString(),
                            )
                                .then((value) {
                              print(value);
                              if (value) {
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
                          }
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

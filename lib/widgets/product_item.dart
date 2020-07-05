import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../screens/product_details_screen.dart';
import '../utils/cart_bottom_sheet.dart';
import '../models/product_color.dart';
import '../models/product_size.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final String token;
  final int categoryId;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProductItem(
    this.product,
    this.token,
    this.categoryId,
    this.scaffoldKey,
  );

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  SharedPreferences prefs;
  bool _isFavourite = false;
  bool retreiveDataHandler = false;

  void addDataToPrefs() async {
    prefs = await SharedPreferences.getInstance();
    String favs = prefs.getString('favourites-${widget.categoryId}');
    List<dynamic> favouriteList;
    if (favs != null)
      favouriteList = json.decode(favs);
    else
      favouriteList = [];
    if (!_isFavourite) {
      favouriteList.add(widget.product.id);
      await prefs.setString(
          'favourites-${widget.categoryId}', json.encode(favouriteList));
    } else {
      favouriteList.remove(widget.product.id);
      await prefs.setString(
          'favourites-${widget.categoryId}', json.encode(favouriteList));
    }
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
          (_isFavourite) ? 'Removed from wishlist!' : 'Added to wishlist!'),
      backgroundColor: (_isFavourite) ? Colors.yellow[700] : Colors.green,
      duration: Duration(seconds: 2),
    ));
    setState(() {
      _isFavourite = !_isFavourite;
    });
  }

  void retreiveDataFromPrefs() async {
    retreiveDataHandler = true;
    prefs = await SharedPreferences.getInstance();
    String favs = prefs.getString('favourites-${widget.categoryId}');
    print(favs);
    List<dynamic> favouriteList;
    if (favs != null)
      favouriteList = json.decode(favs);
    else
      favouriteList = [];

    if (favouriteList.length == 0) {
      _isFavourite = false;
    } else {
      if (favouriteList.contains(widget.product.id)) _isFavourite = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!retreiveDataHandler) retreiveDataFromPrefs();
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        ProductDetailsScreen.routeName,
        arguments: <dynamic>[widget.product, widget.token, widget.categoryId],
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://developers.thegraphe.com/flexy/storage/app/product_images/${widget.product.productImages[0]}',
                  fit: BoxFit.cover,
                  height: 250.0,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.name),
                  Text("Price"),
                ],
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
                      for (ProductColor productColor in productSize.colors) {
                        if (!temp1.contains(productColor.color)) {
                          temp1.add(productColor.color);
                          temp2.add(productColor.quantity);
                        }
                      }
                      colorList.add(temp1);
                      qtyList.add(temp2);
                    }
                    CartBottomSheet().showBottomSheet(
                        context,
                        widget.product,
                        widget.scaffoldKey,
                        colorList,
                        qtyList,
                        widget.token,
                        false);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: (_isFavourite) ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    print('pressed');
                    addDataToPrefs();
                  },
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );

/*ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: <dynamic>[
              widget.product,
              widget.token,
              widget.categoryId
            ],
          ),
          child: Image.network(
            'https://developers.thegraphe.com/flexy/storage/app/product_images/${widget.product.productImages[0]}',
            fit: BoxFit.contain,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(widget.product.name),
          trailing: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  var colorList = new List<List<String>>();
                  var qtyList = new List<List<int>>();
                  for (ProductSize productSize in widget.product.productSizes) {
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
                  CartBottomSheet().showBottomSheet(
                    context,
                    widget.product,
                    widget.scaffoldKey,
                    colorList,
                    qtyList,
                    widget.token,
                    false
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: (_isFavourite) ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  print('pressed');
                  addDataToPrefs();
                },
              ),
            ],
          ),
        ),
      ),
    );*/
  }
}

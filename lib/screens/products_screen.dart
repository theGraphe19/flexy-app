import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../HTTP_handler.dart';
import '../models/product.dart';
import '../widgets/loading_body.dart';
import '../models/user.dart';
import '../providers/product_provider.dart';
import '../utils/drawer.dart';
import '../utils/wishlist_bottom_sheet.dart';
import './search_screen.dart';
import '../models/category.dart';
import '../models/chat.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Category category;
  var prodListCounterCalled = false;
  User currentUser;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();

  bool _productsLoaded = false;
  ProductProvider _productProvider;
  WishlistBottomSheet _wishlistBottomSheet;

  var _radioValue = 1;
  var _radioValue1 = 0;

  var hasUnread = false;

  Map<String, bool> checkboxesValues = {};

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SearchScreen(currentUser),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  getList() async {
    prodListCounterCalled = true;
    _handler
        .getProductsList(context, currentUser.token, category.id.toString())
        .then((value) {
      setState(() {
        _productsLoaded = true;
      });
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

  void checkUnreadMsgs() {
    _handler.getChats(currentUser.token).then((value) {
      for (Chat c in value[0].chats) {
        if (c.status == 0) {
          print("for chats ");
          setState(() {
            hasUnread = true;
          });
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    currentUser = data['user'];
    print(currentUser.token);
    category = data['category'];
    print(category);
    _productProvider = Provider.of<ProductProvider>(context);
    _wishlistBottomSheet = WishlistBottomSheet(
      context: context,
      scaffoldKey: scaffoldKey,
      user: currentUser,
    );

    if (!prodListCounterCalled) {
      getList();
      checkUnreadMsgs();

      for (String s in category.subCategories) {
        checkboxesValues[s] = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('more pressed');
            scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text(category.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              print('search');
              Navigator.of(context).push(_createRoute());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: () {
                _wishlistBottomSheet.fireWishlist();
              },
            ),
          )
        ],
      ),
      drawer: SideDrawer(currentUser, scaffoldKey, hasUnread).drawer(context),
      body: Column(
        children: <Widget>[
          Divider(),
          Expanded(
            child: (!_productsLoaded)
                ? LoadingBody()
                : GridView.builder(
                    itemCount: _productProvider.productsList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                    ),
                    itemBuilder: (BuildContext context, int index) =>
                        ProductItem(
                      _productProvider.productsList[index],
                      currentUser,
                      category,
                      scaffoldKey,
                      false,
                    ),
                  ),
          ),
          Divider(),
          Container(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    print('sort products');
                    _sortOptions(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 11.0,
                    height: 25.0,
                    alignment: Alignment.center,
                    color: Colors.pink.withOpacity(0),
                    child: Text(
                      'Sort',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black12,
                  height: 25,
                  width: 2,
                ),
                GestureDetector(
                  onTap: () {
                    print('filter pressed');
                    _filterOptions(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 11.0,
                    height: 25.0,
                    alignment: Alignment.center,
                    color: Colors.pink.withOpacity(0),
                    child: Text(
                      'Filter',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleRadioValueChange1(int value) {
    List p = _productProvider.productsListDuplicate;
    if (value == 1) {
      print(_productProvider.productsList[0].name);
      _productProvider.productList = p;
      print(_productProvider.productsList[0].name);
    }
    if (value == 2) {
      print(_productProvider.productsList[0].name);
      p.sort((p1, p2) =>
          p1.productSizes[0].price.compareTo(p2.productSizes[0].price));
      _productProvider.productList = p.reversed.toList();
      print(_productProvider.productsList[0].name);
    }
    if (value == 3) {
      print(_productProvider.productsList[0].name);
      p.sort(
          (p1, p2) => p1.name.toLowerCase().compareTo(p2.name.toLowerCase()));
      _productProvider.productList = p;
      print(_productProvider.productsList[0].name);
    }
    setState(() {
      _radioValue = value;
      Navigator.of(context).pop();
    });
  }

  void _filterOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: 350.0,
            margin: const EdgeInsets.only(
              top: 10.0,
              left: 10.0,
              right: 10.0,
            ),
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('FILTER BY'),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  // Container(
                  //   height: 30.0,
                  //   child: RadioListTile(
                  //     title: Text(
                  //       'All Products',
                  //       style: TextStyle(
                  //         color: Colors.black87,
                  //         fontSize: 15.0,
                  //       ),
                  //     ),
                  //     value: 0,
                  //     groupValue: _radioValue1,
                  //     onChanged: _handleRadioValueChange2,
                  //   ),
                  // ),
                  Column(
                    children: category.subCategories.map((subCat) {
                      return Container(
                        child: CheckboxListTile(
                          title: Text(
                            subCat,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15.0,
                            ),
                          ),
                          value: checkboxesValues[subCat],
                          // onChanged: (value) {
                          //   print(value);
                          // },
                          // value: (category.subCategories.indexOf(subCat, 0) + 1),
                          // groupValue: _radioValue1,
                          onChanged: (value) {
                            checkboxesValues[subCat] = value;

                            List<Product> newList = [];
                            _productProvider.productList =
                                _productProvider.productsListDuplicate;

                            var allFalse = false;

                            for (var s in checkboxesValues.keys) {
                              if (checkboxesValues[s]) {
                                allFalse = true;
                                break;
                              }
                            }

                            if (allFalse) {
                              for (var s in checkboxesValues.keys) {
                                if (checkboxesValues[s]) {
                                  for (var p in _productProvider.productsList) {
                                    if (p.subCategory.contains(s) ||
                                        s.contains(p.subCategory)) {
                                      newList.add(p);
                                    }
                                  }
                                }
                              }

                              _productProvider.productList = newList;
                            }

                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          );
        });
  }

  void _sortOptions(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 200.0,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('SORT BY'),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: 30.0,
                child: RadioListTile(
                  title: Text(
                    'Price - Low to High',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange1,
                ),
              ),
              SizedBox(height: 15.0),
              SizedBox(
                height: 30.0,
                child: RadioListTile(
                  title: Text(
                    'Price - High to Low',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  value: 2,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange1,
                ),
              ),
              SizedBox(height: 15.0),
              SizedBox(
                height: 30.0,
                child: RadioListTile(
                  title: Text(
                    'By Name (A - Z)',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  value: 3,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange1,
                ),
              ),
            ],
          ),
        );
      });
}

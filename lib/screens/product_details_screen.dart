import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/product_details.dart';
import '../HTTP_handler.dart';
import '../widgets/loading_body.dart';
import '../widgets/product_item_unrelated.dart';
import '../models/product_size.dart';
import '../models/product_color.dart';
import '../utils/dialog_utils.dart';
import './cart_screen.dart';
import '../models/user.dart';
import './search_screen.dart';
import '../utils/wishlist_bottom_sheet.dart';
import '../providers/product_provider.dart';

/*
<a target="_blank" href="https://icons8.com/icons/set/like">Heart icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
<a target="_blank" href="https://icons8.com/icons/set/shopping-cart">Shopping Cart icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
*/

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product-details-screen';

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product product;
  String token;
  int categoryId;
  User user;
  HTTPHandler _handler = HTTPHandler();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  bool productsController = false;
  ProductDetails productDetails;
  var currentActiveIndex = 0;
  int selectedSize = 0;
  int colorSelected = 0;
  int quantitySelected = 1;
  bool isAnUpdate;
  CartScreenState _changeCartState;
  WishlistBottomSheet _wishlistBottomSheet;
  List<int> quantities;
  int cartId;
  ProductProvider _productProvider;

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SearchScreen(user),
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

  getProductDetails() {
    productsController = true;
    _handler.getProductDetails(product.productId, token).then((value1) {
      productDetails = value1;
      print(productDetails.product.productColors[0].sizes.length);
      print(quantities);
      if (quantities == null) {
        quantities = [];
        for (var i = 0; i < product.productColors[0].sizes.length; i++)
          quantities.add(0);
      }
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    _productProvider = Provider.of<ProductProvider>(context);
    _wishlistBottomSheet = WishlistBottomSheet(
      context: context,
      categoryId: categoryId,
      scaffoldKey: scaffoldKey,
      user: user,
    );
    List<dynamic> arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    product = arguments[0] as Product;
    token = arguments[1] as String;
    user = arguments[3] as User;
    categoryId = arguments[2];
    if (arguments.length > 4) {
      isAnUpdate = arguments[4] as bool;
      _changeCartState = arguments[5] as CartScreenState;
      quantities = arguments[6];
      if (!productsController) if (product.productColors[0].color != null) {
        for (var i = 0; i < product.productColors.length; i++) {
          if (product.productColors[i].color.contains(arguments[7]) &&
              arguments[7].contains(product.productColors[i].color)) {
            colorSelected = i;
            break;
          }
        }
      } else {
        colorSelected = 0;
      }
      cartId = arguments[8];
    } else {
      isAnUpdate = false;
    }
    print('Token : $token');
    if (!productsController) getProductDetails();

    Runes input = new Runes(' \u{20B9}');

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: (productDetails == null)
          ? LoadingBody()
          : Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
              ),
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 70.0),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //IMAGE
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.6,
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: (product.productImages.length > 0)
                                    ? imagePageView()
                                    : PhotoView(
                                        backgroundDecoration:
                                            BoxDecoration(color: Colors.white),
                                        imageProvider: NetworkImage(
                                            'https://developers.thegraphe.com/flexy/storage/app/product_images/${product.productImages[currentActiveIndex]}'),
                                      ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      for (var i = 0;
                                          i < product.productImages.length;
                                          i++)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                            vertical: 10.0,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (currentActiveIndex == i)
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Colors.grey,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/search-outline.png',
                                      frameBuilder: (
                                        BuildContext context,
                                        Widget child,
                                        int frame,
                                        bool wasSynchronouslyLoaded,
                                      ) {
                                        return GestureDetector(
                                          onTap: () {
                                            print('search');
                                            Navigator.of(context)
                                                .push(_createRoute());
                                          },
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColorLight),
                                            ),
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 10.0),
                                    Image.asset(
                                      'assets/images/cart-outline.png',
                                      frameBuilder: (
                                        BuildContext context,
                                        Widget child,
                                        int frame,
                                        bool wasSynchronouslyLoaded,
                                      ) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              CartScreen.routeName,
                                              arguments: user,
                                            );
                                          },
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColorLight),
                                            ),
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 10.0),
                                    Image.asset(
                                      'assets/images/wishlist-outline.png',
                                      frameBuilder: (
                                        BuildContext context,
                                        Widget child,
                                        int frame,
                                        bool wasSynchronouslyLoaded,
                                      ) {
                                        return GestureDetector(
                                          onTap: () {
                                            print('return to favs');
                                            _wishlistBottomSheet.fireWishlist();
                                          },
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColorLight),
                                            ),
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: double.infinity,
                          child: Text(
                            '${product.name}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: double.infinity,
                          child: Text(
                            '${String.fromCharCodes(input)} ${product.productSizes[selectedSize].price}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  'Available Colors : ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              (product.productColors[0].color != null)
                                  ? Container(
                                      height: 90.0,
                                      margin:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: product.productColors
                                              .map(
                                                (ProductColor productColor) =>
                                                    GestureDetector(
                                                  onTap: () {
                                                    colorSelected = product
                                                        .productColors
                                                        .indexOf(
                                                            productColor, 0);

                                                    quantities = [];
                                                    for (var i = 0;
                                                        i <
                                                            product
                                                                .productColors[
                                                                    colorSelected]
                                                                .sizes
                                                                .length;
                                                        i++) quantities.add(0);
                                                    setState(() {});
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                          ),
                                                          color: Color(int.parse(
                                                                  product
                                                                      .productColors[product
                                                                          .productColors
                                                                          .indexOf(
                                                                              productColor,
                                                                              0)]
                                                                      .color
                                                                      .substring(
                                                                          1, 7),
                                                                  radix: 16) +
                                                              0xFF000000),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.done,
                                                            color: (colorSelected ==
                                                                    product
                                                                        .productColors
                                                                        .indexOf(
                                                                            productColor,
                                                                            0))
                                                                ? Colors.white
                                                                : Colors
                                                                    .transparent,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.0),
                                                      Text(product
                                                          .productColors[product
                                                              .productColors
                                                              .indexOf(
                                                                  productColor,
                                                                  0)]
                                                          .colorName),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList()),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      width: double.infinity,
                                      child: Text(
                                        'No Color',
                                        textAlign: TextAlign.start,
                                      ),
                                    )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  'Select Quantity : ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Column(
                                children: product
                                    .productColors[colorSelected].sizes
                                    .map((ProductSize productSize) {
                                  int index = product
                                      .productColors[colorSelected].sizes
                                      .indexOf(productSize, 0);
                                  print(index);
                                  return Container(
                                    height: 50.0,
                                    margin: const EdgeInsets.only(bottom: 5.0),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            productSize.size,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (quantities[index] > 0)
                                                    quantities[index]--;
                                                });
                                              },
                                              child: Icon(
                                                Icons.indeterminate_check_box,
                                                size: 40.0,
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Text(quantities[index].toString()),
                                            SizedBox(width: 10.0),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  quantities[index]++;
                                                });
                                              },
                                              child: Icon(
                                                Icons.add_box,
                                                size: 40.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  'Product Details : ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(product.description),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  'Suggested Products :',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 360.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10.0),
                            itemCount: productDetails.relatedProducts.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ProductItemUnrelated(
                                productDetails.relatedProducts[index],
                                user,
                                categoryId,
                                scaffoldKey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: orderButton(),
                    ),
                  ),
                ],
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

  Widget imagePageView() => Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: BouncingScrollPhysics(),
          itemCount: product.productImages.length,
          onPageChanged: (int currentIndex) {
            setState(() {
              currentActiveIndex = currentIndex;
            });
          },
          loadingBuilder: (BuildContext context, ImageChunkEvent event) =>
              Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                backgroundColor: Colors.red[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          ),
          builder: (BuildContext context, int index) =>
              PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
                'https://developers.thegraphe.com/flexy/storage/app/product_images/${product.productImages[currentActiveIndex]}'),
          ),
          backgroundDecoration: BoxDecoration(color: Colors.white),
        ),
      );

  Widget orderButton() => Container(
        margin: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          bottom: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                int prize = 0;
                for (int i = 0; i < quantities.length; i++) {
                  if (quantities[i] != 0)
                    prize +=
                        product.productColors[colorSelected].sizes[i].price *
                            quantities[i];
                }
                if (prize == 0) {
                  Toast.show(
                    'Please select quantity',
                    context,
                    gravity: Toast.CENTER,
                  );
                } else {
                  if (product.productColors[0].color == null) colorSelected = 0;
                  DialogUtils().showCustomDialog(
                    context,
                    title: 'Confirm Order Details',
                    productDetails: productDetails,
                    product: product,
                    size: product.productColors[colorSelected].sizes,
                    quantity: quantities,
                    color: product.productColors[colorSelected],
                    price: prize,
                    token: token,
                    scaffoldKey: scaffoldKey,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                  right: 25.0,
                  left: 30.0,
                ),
                child: Text(
                  'Order Now',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (isAnUpdate == false) {
                  int prize = 0;
                  for (int i = 0; i < quantities.length; i++) {
                    if (quantities[i] != 0)
                      prize +=
                          product.productColors[colorSelected].sizes[i].price *
                              quantities[i];
                  }
                  if (prize == 0) {
                    Toast.show(
                      'Please select quantity',
                      context,
                      gravity: Toast.CENTER,
                    );
                  } else {
                    List<Map<String, dynamic>> orderList = [];
                    for (var i = 0; i < quantities.length; i++) {
                      orderList.add({
                        'size':
                            product.productColors[colorSelected].sizes[i].size,
                        'quantity': quantities[i],
                      });
                      print(orderList.toString());
                    }
                    _handler
                        .addToCart(
                      product.productId,
                      token,
                      product.productColors[colorSelected].color,
                      orderList,
                    )
                        .then((value) {
                      if (value == true) {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Product Added to Your Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 3),
                        ));
                      } else {
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Failed to Add the Product to the Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 3),
                        ));
                      }
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
                } else {
                  _handler
                      .removeItemFromCart(
                    token,
                    cartId,
                  )
                      .then((value) {
                    print('removed');
                    if (value) {
                      int prize = 0;
                      for (int i = 0; i < quantities.length; i++) {
                        if (quantities[i] != 0)
                          prize += product
                                  .productColors[colorSelected].sizes[i].price *
                              quantities[i];
                      }
                      if (prize == 0) {
                        Toast.show(
                          'Please select quantity',
                          context,
                          gravity: Toast.CENTER,
                        );
                      } else {
                        List<Map<String, dynamic>> orderList = [];
                        for (var i = 0; i < quantities.length; i++) {
                          if (quantities[i] != 0)
                            orderList.add({
                              'size': product
                                  .productColors[colorSelected].sizes[i].size,
                              'quantity': quantities[i],
                            });
                          print(orderList.toString());
                        }
                        _handler
                            .addToCart(
                          product.productId,
                          token,
                          product.productSizes[selectedSize]
                              .colors[colorSelected].color,
                          orderList,
                        )
                            .then((value) {
                          if (value == true) {
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                'Product Updated in Your Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Color(0xff6c757d),
                              duration: Duration(seconds: 3),
                            ));
                          } else {
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                'Failed to Add the Product to the Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Color(0xff6c757d),
                              duration: Duration(seconds: 3),
                            ));
                          }
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
                    } else {
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'Error! Please try again.',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xff6c757d),
                        duration: Duration(seconds: 3),
                      ));
                    }
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
              },
              child: Container(
                margin: const EdgeInsets.only(left: 25.0),
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 12.0,
                  left: 30.0,
                  right: 20.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Text(
                  isAnUpdate ? 'Update Cart' : 'Add To Cart',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

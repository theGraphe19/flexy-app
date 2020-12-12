import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../models/product_details.dart';
import '../HTTP_handler.dart';
import '../widgets/loading_body.dart';
import '../widgets/product_item_unrelated.dart';
import '../models/product_size.dart';
import '../models/product_color.dart';
import './cart_screen.dart';
import '../models/user.dart';
import './search_screen.dart';
import '../utils/wishlist_bottom_sheet.dart';
import '../providers/product_provider.dart';
import '../screens/image_zoom_screen.dart';
import './categories_screen.dart';

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
  Category category;
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
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

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

    _handler.getProductDetails(product.productId, token).then((value1) async {
      productDetails = value1;
      print(productDetails.product.productColors[0].sizes.length);
      print(quantities);
      if (quantities == null) {
        quantities = [];
        for (var i = 0; i < product.productColors[0].sizes.length; i++)
          quantities.add(0);
      }

      // Assigning value to video player
      for (String s in product.productImages) {
        List ext = s.split('.');
        if (ext.contains('mp4')) {
          _controller = VideoPlayerController.network(
            'https://developers.thegraphe.com/flexy/storage/app/product_images/${s}',
          );
          await _controller.setLooping(true);

          _initializeVideoPlayerFuture = _controller.initialize();
        }
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
      scaffoldKey: scaffoldKey,
      user: user,
    );
    List<dynamic> arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    product = arguments[0] as Product;
    token = arguments[1] as String;
    user = arguments[3] as User;
    category = arguments[2];
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
                  Container(
                    height: MediaQuery.of(context).size.height - 70,
                    child: SingleChildScrollView(
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
                                          backgroundDecoration: BoxDecoration(
                                              color: Colors.white),
                                          imageProvider: NetworkImage(
                                              'https://flexyindia.com/administrator/storage/app/product_images/${product.productImages[currentActiveIndex]}'),
                                        ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                        'assets/images/home.png',
                                        frameBuilder: (
                                          BuildContext context,
                                          Widget child,
                                          int frame,
                                          bool wasSynchronouslyLoaded,
                                        ) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                CategoriesScreen.routeName,
                                                (route) => false,
                                                arguments: user,
                                              );
                                            },
                                            child: Container(
                                              height: 30.0,
                                              width: 30.0,
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                              _wishlistBottomSheet
                                                  .fireWishlist();
                                            },
                                            child: Container(
                                              height: 30.0,
                                              width: 30.0,
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                if ((product.productImages[currentActiveIndex]
                                        .split('.'))
                                    .contains('mp4'))
                                  Center(
                                    child: Opacity(
                                      opacity: 0.75,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (_controller.value.isPlaying) {
                                              _controller.pause();
                                            } else {
                                              _controller.play();
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: 50.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _controller.value.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            width: double.infinity,
                            child: Text(
                              (category.name
                                          .toLowerCase()
                                          .contains('bottomwear') ||
                                      category.name
                                          .toLowerCase()
                                          .contains('bottomwears'))
                                  ? 'MRP: ${String.fromCharCodes(input)} ${product.productSizes[selectedSize].price}'
                                  : 'WSP: ${String.fromCharCodes(input)} ${product.productSizes[selectedSize].price}',
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
                                        height: 95.0,
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
                                                          i++)
                                                        quantities.add(0);
                                                      setState(() {});
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            color: Color(int.parse(
                                                                    product
                                                                        .productColors[product
                                                                            .productColors
                                                                            .indexOf(productColor,
                                                                                0)]
                                                                        .color
                                                                        .substring(
                                                                            1,
                                                                            7),
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
                                                        Text(
                                                          '${product.productColors[product.productColors.indexOf(productColor, 0)].colorName.split(' ')[0]}\n${product.productColors[product.productColors.indexOf(productColor, 0)].colorName.split(' ').length > 1 ? product.productColors[product.productColors.indexOf(productColor, 0)].colorName.split(' ')[1] : " "}',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
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
                                      margin:
                                          const EdgeInsets.only(bottom: 5.0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
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
                                          Row(
                                            children: [
                                              Text(
                                                (category.name
                                                            .toLowerCase()
                                                            .contains(
                                                                'bottomwear') ||
                                                        category.name
                                                            .toLowerCase()
                                                            .contains(
                                                                'bottomwears'))
                                                    ? 'MRP: ${String.fromCharCodes(input)} ${productSize.price}'
                                                    : 'WSP: ${String.fromCharCodes(input)} ${productSize.price}',
                                              ),
                                              SizedBox(width: 10.0),
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
                                              Text(
                                                  quantities[index].toString()),
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
                                  child: Html(data: product.description),
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
                                  category,
                                  scaffoldKey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget imagePageView() => PageView.builder(
        itemCount: product.productImages.length,
        onPageChanged: (int currentIndex) {
          setState(() {
            currentActiveIndex = currentIndex;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          List<String> ext =
              (product.productImages[currentActiveIndex] as String).split('.');
          print(ext[ext.length - 1]);
          if (ext[ext.length - 1] == 'mp4') {
            // _controller = VideoPlayerController.network(
            //   'https://developers.thegraphe.com/flexy/storage/app/product_images/${product.productImages[currentActiveIndex]}',
            // );

            // _initializeVideoPlayerFuture = _controller.initialize();

            return FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: 0.5,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ));
                }
              },
            );
          } else
            return GestureDetector(
              onTap: () {
                print('tapped');
                Navigator.of(context).pushNamed(
                  ImageZoomScreen.routeName,
                  arguments: [
                    currentActiveIndex,
                    product.productImages,
                  ],
                );
              },
              child: Hero(
                tag: product.productImages[currentActiveIndex],
                child: Container(
                  width: double.infinity,
                  height: 400.0,
                  color: Colors.white,
                  child: Center(
                    child: Image(
                      image: NetworkImage(
                        'https://flexyindia.com/administrator/storage/app/product_images/${product.productImages[currentActiveIndex]}',
                      ),
                    ),
                  ),
                ),
              ),
            );
        },
      );

  Widget orderButton() => Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (isAnUpdate == false) {
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
                            prize += product.productColors[colorSelected]
                                    .sizes[i].price *
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
                  height: 50.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    (isAnUpdate) ? 'Update Cart' : 'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                CartScreen.routeName,
                arguments: user,
              ),
              child: Container(
                width: 60.0,
                height: 50.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     // GestureDetector(
        //     //   onTap: () {
        //     //     List<ProductColor> colorList = [];
        //     //     int prize = 0;
        //     //     for (int i = 0; i < quantities.length; i++) {
        //     //       if (quantities[i] != 0) {
        //     //         prize +=
        //     //             product.productColors[colorSelected].sizes[i].price *
        //     //                 quantities[i];
        //     //         colorList.add(product.productColors[colorSelected]);
        //     //       }
        //     //     }
        //     //     if (prize == 0) {
        //     //       Toast.show(
        //     //         'Please select quantity',
        //     //         context,
        //     //         gravity: Toast.CENTER,
        //     //       );
        //     //     } else {
        //     //       if (product.productColors[0].color == null) colorSelected = 0;
        //     //       DialogUtils().showCustomDialog(
        //     //         context,
        //     //         title: 'Confirm Order Details',
        //     //         productDetails: productDetails,
        //     //         product: product,
        //     //         size: product.productColors[colorSelected].sizes,
        //     //         quantity: quantities,
        //     //         color: product.productColors[colorSelected],
        //     //         price: prize,
        //     //         token: token,
        //     //         scaffoldKey: scaffoldKey,
        //     //         colors: colorList,
        //     //       );
        //     //     }
        //     //   },
        //     //   child: Container(
        //     //     height: 50.0,
        //     //     width: 150.0,
        //     //     alignment: Alignment.center,
        //     //     decoration: BoxDecoration(
        //     //       shape: BoxShape.rectangle,
        //     //       border: Border.all(
        //     //         width: 0.5,
        //     //         color: Colors.grey[300],
        //     //       ),
        //     //     ),
        //     //     child: Text(
        //     //       'Buy Now',
        //     //       style: TextStyle(
        //     //         color: Colors.black87,
        //     //         fontWeight: FontWeight.w500,
        //     //         fontSize: 18.0,
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),
        //     SizedBox(width: 10.0),

        //   ],
        // ),
      );
}

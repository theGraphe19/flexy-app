import 'package:flexy/models/user.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../models/product.dart';
import '../models/product_details.dart';
import '../HTTP_handler.dart';
import '../widgets/loading_body.dart';
import '../widgets/product_item.dart';
import '../models/product_size.dart';
import '../models/product_color.dart';
import '../models/remark.dart';
import '../utils/dialog_utils.dart';
import '../screens/cart_screen.dart';

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
  List<Remark> _remarks;
  int quantitySelected = 1;
  bool isAnUpdate;
  CartScreenState _changeCartState;

  getProductDetails() {
    productsController = true;
    _handler.remarkOfProduct(token, product.productId).then((value) {
      _remarks = value;
      _handler.getProductDetails(product.productId, token).then((value1) {
        productDetails = value1;
        print(productDetails.product.name);
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
    List<dynamic> arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    product = arguments[0] as Product;
    token = arguments[1] as String;
    user = arguments[3] as User;
    if (arguments.length > 4) {
      isAnUpdate = arguments[3] as bool;
      _changeCartState = arguments[4] as CartScreenState;
    } else {
      isAnUpdate = false;
    }
    print('Token : $token');
    if (!productsController) getProductDetails();

    Runes input = new Runes(' \u{20B9}');

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      // appBar: AppBar(
      //   title: Text(
      //     '${product.name}',
      //   ),
      // ),
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
                                    : Image.network(
                                        'https://developers.thegraphe.com/flexy/storage/app/product_images/${product.productImages[currentActiveIndex]}'),
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
                                              border: Border.all(
                                                  color: Colors.grey),
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
                        SizedBox(height: 5.0),
                        Container(
                          height: 30.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: product.productTags
                                .split(',')
                                .map((String tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 5.0,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Text(tag),
                                    ))
                                .toList(),
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
                                  'Available Sizes : ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                height: 30.0,
                                margin: const EdgeInsets.only(bottom: 5.0),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: product.productSizes
                                      .map((ProductSize productSize) =>
                                          GestureDetector(
                                            onTap: () {
                                              selectedSize = product
                                                  .productSizes
                                                  .indexOf(productSize, 0);
                                              colorSelected = 0;
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: 50.0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 5.0,
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                border: Border.all(
                                                    color: Colors.grey),
                                                color: (selectedSize ==
                                                        product.productSizes
                                                            .indexOf(
                                                                productSize, 0))
                                                    ? Theme.of(context)
                                                        .accentColor
                                                    : Colors.white,
                                              ),
                                              child: Center(
                                                  child: Text(
                                                productSize.size,
                                                style: TextStyle(
                                                  color: (selectedSize ==
                                                          product.productSizes
                                                              .indexOf(
                                                                  productSize,
                                                                  0))
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                              )),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
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
                                  'Available Colors : ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                height: 50.0,
                                margin: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: product
                                              .productSizes[selectedSize].colors
                                              .map(
                                                (ProductColor productColor) =>
                                                    GestureDetector(
                                                  onTap: () {
                                                    colorSelected = product
                                                        .productSizes[
                                                            selectedSize]
                                                        .colors
                                                        .indexOf(
                                                            productColor, 0);
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    width: 50.0,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      color: Color(int.parse(
                                                              product
                                                                  .productSizes[
                                                                      selectedSize]
                                                                  .colors[product
                                                                      .productSizes[
                                                                          selectedSize]
                                                                      .colors
                                                                      .indexOf(
                                                                          productColor)]
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
                                                                    .productSizes[
                                                                        selectedSize]
                                                                    .colors
                                                                    .indexOf(
                                                                        productColor,
                                                                        0))
                                                            ? Colors.white
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList()),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        '${product.productSizes[selectedSize].colors[colorSelected].quantity} available',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
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
                              Container(
                                height: 50.0,
                                margin: const EdgeInsets.only(bottom: 5.0),
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (quantitySelected > 1)
                                            quantitySelected--;
                                        });
                                      },
                                      child: Icon(
                                        Icons.indeterminate_check_box,
                                        size: 40.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      quantitySelected.toString(),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (quantitySelected <
                                              product
                                                  .productSizes[selectedSize]
                                                  .colors[colorSelected]
                                                  .quantity) quantitySelected++;
                                        });
                                      },
                                      child: Icon(
                                        Icons.add_box,
                                        size: 40.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
                              child: ProductItem(
                                productDetails.relatedProducts[index],
                                user,
                                categoryId,
                                scaffoldKey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  'Customer Reviews : ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 5.0),
                                child: SizedBox(
                                  height: _remarks.length * 50.0,
                                  child: ListView(
                                    primary: false,
                                    children: _remarks
                                        .map(
                                          (Remark remark) => Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Text(
                                                      _remarks[_remarks
                                                              .indexOf(remark)]
                                                          .userName,
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    user.id == _remarks[_remarks.indexOf(remark)].userId ?
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        onTap: ()=>updateRemark(_remarks.indexOf(remark)),
                                                        child: Container(
                                                          height: 25.0,
                                                          width: 70.0,
                                                          child: Center(
                                                            child: Text(
                                                              "Update",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorLight,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                width: 1.0,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorLight),
                                                          ),
                                                        ),
                                                      ),
                                                    ) : Text(""),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text((_remarks[_remarks.indexOf(
                                                                remark)]
                                                            .remarks
                                                            .length >=
                                                        250)
                                                    ? '${_remarks[_remarks.indexOf(remark)].remarks.substring(0, 249)}...'
                                                    : _remarks[_remarks
                                                            .indexOf(remark)]
                                                        .remarks),
                                                Divider(),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
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

  void updateRemark(int remarkIndex) {
    final newRemark = new TextEditingController();
    scaffoldKey.currentState.showBottomSheet((newContext) {
      return Container(
        padding: EdgeInsets.all(16.0),
        height: 180.0,
        decoration: BoxDecoration(
          /*border: Border.all(color: Colors.grey),*/
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
          color: Color(0xfff0f0f0),
        ),
        child: Column(
          children: [
            TextField(
              controller: newRemark,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              style:
              TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: 'Enter New Remark',
              ),
            ),
            SizedBox(height: 40.0),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (newRemark.text.isNotEmpty) {
                    HTTPHandler()
                          .updateRemark(product.productId.toString(), user.token, newRemark.text)
                          .then((value) {
                            Navigator.of(context).pop();
                        if (value==1) {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Remark Updated', style: TextStyle(color: Colors.white),),
                            backgroundColor: Color(0xff6c757d),
                            duration: Duration(seconds: 3),
                          ));
                        } else {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Failed to Update Remark.', style: TextStyle(color: Colors.white),),
                            backgroundColor: Color(0xff6c757d),
                            duration: Duration(seconds: 3),
                          ));
                        }
                        setState(() {
                          productsController = false;
                        });
                      });
                  } else {
                    Toast.show("Enter Remark!", context);
                  }
                },
                child: Container(
                  height: 40.0,
                  child: Center(
                    child: Text(
                      "Update Remark",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border:
                    Border.all(width: 1.0, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
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
            ),
          );
        },
      );

  Widget orderButton() => GridTileBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                int prize = 0;
                for (var i = 0; i < product.productSizes.length; i++) {
                  if (product.productSizes[i].size
                          .contains(product.productSizes[selectedSize].size) &&
                      product.productSizes[selectedSize].size
                          .contains(product.productSizes[i].size)) {
                    prize = product.productSizes[i].price;
                    break;
                  }
                }
                DialogUtils().showCustomDialog(
                  context,
                  title: 'Confirm Order Details',
                  productDetails: productDetails,
                  product: product,
                  size: product.productSizes[selectedSize].size,
                  quantity: quantitySelected.toString(),
                  color: product
                      .productSizes[selectedSize].colors[colorSelected].color,
                  price: prize,
                  token: token,
                  scaffoldKey: scaffoldKey,
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
                if (isAnUpdate == false) {
                  HTTPHandler()
                      .addToCart(
                    token,
                    product.productId.toString(),
                    product.productSizes[selectedSize].size,
                    quantitySelected.toString(),
                    product
                        .productSizes[selectedSize].colors[colorSelected].color,
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
                  });
                } else {
                  print(token);
                  print(product.productId.toString());
                  print(product.productSizes[selectedSize].size);
                  print(quantitySelected.toString());
                  print(product
                      .productSizes[selectedSize].colors[colorSelected].color);
                  HTTPHandler()
                      .updateCart(
                    token,
                    product.productId.toString(),
                    product.productSizes[selectedSize].size,
                    quantitySelected.toString(),
                    product
                        .productSizes[selectedSize].colors[colorSelected].color,
                  )
                      .then((value) {
                    if (value == true) {
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'Cart Updated',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xff6c757d),
                        duration: Duration(seconds: 3),
                      ));
                    } else {
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'Failed to Update Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xff6c757d),
                        duration: Duration(seconds: 3),
                      ));
                    }
                    _changeCartState.setState(() {});
                  });
                }
                ;
              },
              child: Text(
                isAnUpdate ? 'Update Cart' : 'Add To Cart',
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../models/cart_overview.dart';
import '../models/cart.dart';
import '../models/product_details.dart';
import '../models/product_size.dart';
import '../models/product_color.dart';
import '../utils/dialog_utils.dart';
import '../HTTP_handler.dart';

class CheckOutItem extends StatelessWidget {
  CartOverView item;
  int index;
  String token;
  final GlobalKey<ScaffoldState> scaffoldKey;
  ProductDetails productDetails;
  int prize = 0;
  ProgressDialog progressDialog;
  List<ProductColor> colorsList = [];
  int quantity;

  CheckOutItem(
    this.item,
    this.index,
    this.token,
    this.scaffoldKey,
  ) {
    this.quantity = 0;
    for (Cart c in item.cartItems) {
      quantity += c.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
    progressDialog.style(
      message: 'Please wait!',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );

    for (int i = 0; i < item.cartItems.length; i++) {
      if (item.cartItems[i].quantity != 0) {
        prize += item.cartItems[i].productPrice * item.cartItems[i].quantity;
        colorsList.add(ProductColor.onlyColor(
          color: item.cartItems[i].color,
          colorName: item.cartItems[i].colorName,
        ));
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: GestureDetector(
        onTap: () async {
          await progressDialog.show();
          HTTPHandler()
              .getProductDetails(item.cartItems[0].productId, token)
              .then((value) async {
            await progressDialog.hide();
            this.productDetails = value;
            List<int> quantity = [];
            List<ProductSize> sizes = [];
            for (var i = 0; i < item.cartItems.length; i++) {
              quantity.add(item.cartItems[i].quantity);
              sizes.add(ProductSize.mapToProductSizeFromColors({
                'size': item.cartItems[i].productSize,
                'price': item.cartItems[i].productPrice.toString(),
              }));
            }
            DialogUtils().showCustomDialog(
              context,
              title: 'Item Details',
              cancelBtnText: 'OK',
              color: ProductColor.onlyColor(
                color: item.cartItems[0].color,
                colorName: item.cartItems[0].colorName,
              ),
              okBtnText: '',
              price: prize,
              product: productDetails.product,
              productDetails: productDetails,
              quantity: quantity,
              scaffoldKey: scaffoldKey,
              size: sizes,
              token: token,
              colors: colorsList,
            );
          }).catchError((e) {
            print(e);
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                'Network error!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xff6c757d),
              duration: Duration(seconds: 3),
            ));
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xfff0f0f0), width: 1.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item ${index + 1} :",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text(
                    "Name : ${item.cartItems[0].productName}",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Date : ${DateFormat('dd-MM-yyyy').format(item.cartItems[0].timeStamp)}",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        color: Colors.grey),
                  ),
                  Text(
                    "Total Quantity : ${this.quantity}",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        color: Colors.grey),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

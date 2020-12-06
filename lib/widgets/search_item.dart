import 'package:flutter/material.dart';

import '../HTTP_handler.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/category.dart';
import '../screens/product_details_screen.dart';

class SearchItem extends StatelessWidget {
  final Product product;
  final User user;
  final GlobalKey<ScaffoldState> scaffoldKey;

  SearchItem(
    this.product,
    this.user,
    this.scaffoldKey,
  );

  int getCategory(List<Category> categories) {
    for (var i = 0; i < categories.length; i++) {
      if (categories[i].name.contains(product.category) &&
          product.category.contains(categories[i].name)) {
        return categories[i].id;
      }
    }

    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        'https://developers.thegraphe.com/flexy/storage/app/product_images/${product.productImages[0]}',
        fit: BoxFit.cover,
      ),
      title: Text(product.name),
      subtitle: Text(product.tagline),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () {
        HTTPHandler()
            .getCategoriesList(context, user.token)
            .then((List<Category> value) {
          int cId = getCategory(value);
          if (cId != -1) {
            Navigator.of(context).popAndPushNamed(
              ProductDetailsScreen.routeName,
              arguments: <dynamic>[
                product,
                user.token,
                cId,
                user,
              ],
            );
          } else {
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                'Something went wrong! Pleease contact admin.',
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
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../HTTP_handler.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/category.dart';
import '../screens/product_details_screen.dart';

class SearchItem extends StatelessWidget {
  final Product product;
  final User user;
  final GlobalKey<ScaffoldState> scaffoldKey;
  CategoryProvider categoryProvider;

  SearchItem(
    this.product,
    this.user,
    this.scaffoldKey,
  );

  Category getCategory() {
    for (var i = 0; i < categoryProvider.categoryList.length; i++) {
      if (categoryProvider.categoryList[i].name.contains(product.category) &&
          product.category.contains(categoryProvider.categoryList[i].name)) {
        return categoryProvider.categoryList[i];
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    categoryProvider = Provider.of<CategoryProvider>(context);
    return ListTile(
      leading: Image.network(
        'https://flexyindia.com/administrator/storage/app/product_images/${product.productImages[0]}',
        fit: BoxFit.cover,
      ),
      title: Text(product.name),
      subtitle: Text(product.tagline),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () {
        var c = getCategory();
        if (c != null) {
          Navigator.of(context).popAndPushNamed(
            ProductDetailsScreen.routeName,
            arguments: <dynamic>[
              product,
              user.token,
              c,
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
      },
    );
  }
}

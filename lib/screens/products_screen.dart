import 'package:flutter/material.dart';

import '../widgets/product_item.dart';
import '../dummy_data.dart';
import '../models/user.dart';
import '../HTTP_handler.dart';
import '../models/product.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  User currentUser;

  List<Product> productList = [];

  getList() async {
    HTTPHandler().getProductsList(currentUser.token).then((value) {
      productList = value;
      setState(() {});
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as User;
    print(currentUser.token);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: productList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) =>
              ProductItem(productList[index])),
    );
  }
}

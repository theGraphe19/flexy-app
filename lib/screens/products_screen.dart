import 'package:flutter/material.dart';

import '../widgets/product_item.dart';
import '../dummy_data.dart';
import '../models/user.dart';
import '../HTTP_handler.dart';

class ProductsScreen extends StatelessWidget {
  static const routeName = '/products-screen';

  User currentUser;

  var dummyData = DummyData();

  getList() async {
    HTTPHandler().getProductsList(currentUser.token);
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as User;
    print(currentUser.token);
    getList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: dummyData.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) => ProductItem(
                dummyData.products[index],
                dummyData.productImages[index],
              )),
    );
  }
}

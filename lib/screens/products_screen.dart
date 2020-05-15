import 'package:flutter/material.dart';

import '../widgets/product_item.dart';
import '../dummy_data.dart';

class ProductsScreen extends StatelessWidget {
  static const routeName = '/products-screen';

  var dummyData = DummyData();

  @override
  Widget build(BuildContext context) {
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

import 'package:flutter/foundation.dart';

import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  Map<String, Product> _products = {};
  List<Product> _productList = [];
  List<Product> _productListDuplicate = [];

  Map<String, Product> get products {
    return {..._products};
  }

  set productList(List<Product> productList) => this._productList = productList;

  List<Product> get productsList {
    return [..._productList];
  }

  List<Product> get productsListDuplicate {
    return [..._productListDuplicate];
  }

  void addItem(List<Product> productItems) {
    this._productList = productItems;
    this._productListDuplicate = productItems;
    productItems.forEach((Product product) {
      _products.putIfAbsent(product.id.toString(), () => product);
    });
    notifyListeners();
    print('Products added successfully');
  }

  Product getProduct(String productId) {
    return _products[productId];
  }

  int getProductPos(Product p) => _productList.indexOf(p);

  void clear() {
    _products = {};
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';

import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  Map<String, Product> _products = {};

  Map<String, Product> get products {
    return {..._products};
  }

  void addItem(List<Product> productItems) {
    productItems.forEach((Product product) {
      _products.putIfAbsent(product.id.toString(), () => product);
    });
    notifyListeners();
    print('Products added successfully');
  }

  void removeProduct(int productId) {
    print('removing item');
    _products.remove(productId.toString());
    notifyListeners();
  }

  void clear() {
    _products = {};
    notifyListeners();
  }
}

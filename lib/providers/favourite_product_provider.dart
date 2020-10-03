import 'package:flutter/foundation.dart';

import '../models/product.dart';

class FavouriteProductProvider with ChangeNotifier {
  List<Product> _favProductList = [];

  List<Product> get favProductsList {
    return _favProductList;
  }

  void addItem(List<Product> productItems) {
    this._favProductList = productItems;
    notifyListeners();
    print('Favourite Products added successfully');
  }

  void removeItem(Product product) {
    int index = _favProductList.indexOf(product);
    _favProductList.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _favProductList = [];
    notifyListeners();
  }
}

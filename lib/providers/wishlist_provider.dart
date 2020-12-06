import 'package:flutter/foundation.dart';

import '../models/wishlist.dart' as Item;

class WishlistProvider with ChangeNotifier {
  List<Item.Wishlist> _wishList = [];

  List<Item.Wishlist> get wishList => [..._wishList];

  void addItems(List<Item.Wishlist> items) {
    this._wishList = items;

    notifyListeners();
    print('wishlist saved');
  }

  void removeItem(Item.Wishlist wishList) {
    _wishList.remove(wishList);
    notifyListeners();
  }

  void clear() {
    _wishList = [];
    notifyListeners();
  }
}

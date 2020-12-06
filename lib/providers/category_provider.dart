import 'package:flutter/foundation.dart';

import '../models/category.dart' as cat;

class CategoryProvider with ChangeNotifier {
  List<cat.Category> _categoryList = [];

  List<cat.Category> get categoryList => [..._categoryList];

  set categoryList(List<cat.Category> categories) {
    this._categoryList = categories;
    notifyListeners();
    print('added categories');
  }

  void clear() {
    this._categoryList = [];
    notifyListeners();
  }
}

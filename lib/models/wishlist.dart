import 'package:flexy/models/product_details.dart';

import './order_details.dart';

class Wishlist {
  int id;
  ProductDetails product;

  Wishlist({
    this.id,
    this.product,
  });

  Wishlist.fromMap(Map<dynamic, dynamic> map) {
    this.id = int.parse(map['wishlist id']);
    this.product = ProductDetails.mapToProductDetails(map['product']);
  }
}

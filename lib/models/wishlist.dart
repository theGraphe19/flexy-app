import './product_details.dart';
import './category.dart';

class Wishlist {
  int id;
  Category category;
  ProductDetails product;

  Wishlist({
    this.id,
    this.category,
    this.product,
  });

  Wishlist.fromMap(Map<dynamic, dynamic> map) {
    this.id = int.parse(map['wishlist id']);
    this.category = Category.frommap(map['category_details']);
    this.product = ProductDetails.mapToProductDetails(map['product']);
  }
}

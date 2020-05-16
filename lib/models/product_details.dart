import './product.dart';
import './product_size.dart';

class ProductDetails {
  List<Product> productList;
  List<ProductSize> productSizeList;
  List<dynamic> productImages;
  //  CHNGE STRING TO PRODUCT IMAGES ONCE IMAGE IS UPLOADED ON SERVER

  ProductDetails({
    this.productList,
    this.productSizeList,
    this.productImages,
  }) {
    this.productList = [];
    this.productSizeList = [];
    this.productImages = [];
  }

  void mapToProductDetails(Map<dynamic, dynamic> map) {
    for (var i = 0; i < map['product'].length; i++) {
      Product product = Product();
      product.mapToDetails(map['product'][i]);
      productList.add(product);
    }
    for (var i = 0; i < map['product_sizes'].length; i++) {
      ProductSize productSize = ProductSize();
      productSize.mapToProductSize(map['product_sizes'][i]);
      productSizeList.add(productSize);
    }
    productImages = map['product_images'];
  }
}

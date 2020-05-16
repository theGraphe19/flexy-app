import './product.dart';
import './product_size.dart';

class ProductDetails {
  Product product;
  List<ProductSize> productSizeList;
  List<dynamic> productImages;
  //  CHNGE STRING TO PRODUCT IMAGES ONCE IMAGE IS UPLOADED ON SERVER

  ProductDetails({
    this.product,
    this.productSizeList,
    this.productImages,
  }) {
    this.product = Product();
    this.productSizeList = [];
    this.productImages = [];
  }

  void mapToProductDetails(Map<dynamic, dynamic> map) {
    product.mapToDetails(map['product']);
    for (var i = 0; i < map['product_sizes'].length; i++) {
      ProductSize productSize = ProductSize();
      productSize.mapToProductSize(map['product_sizes'][i]);
      productSizeList.add(productSize);
    }
    productImages = map['product_images'];
  }
}

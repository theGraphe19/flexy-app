import './product_image.dart';

class Product {
  int id;
  String name;
  String productType;
  String description;
  String category;
  String timeStamp;
  String productSizes;
  List<ProductImage> productImages;

  Product({
    this.id,
    this.name,
    this.productType,
    this.description,
    this.category,
    this.timeStamp,
    this.productSizes,
    this.productImages,
  });
}

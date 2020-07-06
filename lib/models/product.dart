import './product_size.dart';

class Product {
  String id;
  int productId;
  String name;
  String description;
  String category;
  String tagline;
  String subCategory;
  String productTags;
  List<ProductSize> productSizes;
  List<dynamic> productImages;
  // CHANGE TYPE TO PRODUCT_IMAGE ONCE IMAGE IS UPLOADED

  Product({
    this.id,
    this.productId,
    this.name,
    this.description,
    this.category,
    this.tagline,
    this.subCategory,
    this.productTags,
    this.productSizes,
    this.productImages,
  });

  void mapToProduct(Map<dynamic, dynamic> map) {
    this.id = map['uniq_id'];
    this.productId = map['id'];
    this.name = map['name'];
    this.description = map['description'];
    this.category = map['category'];
    this.tagline = map['tagline'];
    this.subCategory = map['subcategory'];
    this.productTags = map['product_tags'];
    this.productImages = map['product_images'];
    this.productSizes = [];
    for (var i = 0; i < map['product_sizes'].length; i++)
      productSizes.add(ProductSize.mapToProductSize(map['product_sizes'][i]));
  }

  Product.mapToDetails(Map<dynamic, dynamic> map) {
    this.id = map['uniq_id'];
    this.productId = map['id'];
    this.name = map['name'];
    this.description = map['description'];
    this.category = map['category'].toString();
    this.tagline = map['tagline'];
    this.subCategory = map['subcategory'].toString();
    this.productTags = map['product_tags'].toString();
    this.productImages = map['product_images'];
    this.productSizes = [];
    for (var i = 0; i < map['product_sizes'].length; i++)
      productSizes.add(ProductSize.mapToProductSize(map['product_sizes'][i]));
  }
}

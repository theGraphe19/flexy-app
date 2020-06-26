import './product_size.dart';

class Product {
  String id;
  String name;
  String description;
  String category;
  String subCategory;
  String productTags;
  List<ProductSize> productSizes;
  List<dynamic> productImages;
  // CHANGE TYPE TO PRODUCT_IMAGE ONCE IMAGE IS UPLOADED

  Product({
    this.id,
    this.name,
    this.description,
    this.category,
    this.subCategory,
    this.productTags,
    this.productSizes,
    this.productImages,
  });

  void mapToProduct(Map<dynamic, dynamic> map) {
    this.id = map['uniq_id'];
    this.name = map['name'];
    this.description = map['description'];
    this.category = map['category'];
    this.subCategory = map['subcategory'];
    this.productTags = map['product_tags'];
    this.productImages = map['product_images'];
    this.productSizes = [];
    for (var i = 0; i < map['product_sizes'].length; i++)
      productSizes.add(ProductSize.mapToProductSize(map['product_sizes'][i]));
  }

  // void mapToDetails(Map<dynamic, dynamic> map) {
  //   this.id = map['id'];
  //   this.name = map['name'];
  //   this.productType = map['prod_type'];
  //   this.description = map['description'];
  //   this.category = map['category'];
  //   this.timeStamp = map['created_at'];
  // }
}

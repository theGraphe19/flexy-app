class Product {
  int id;
  String name;
  String productType;
  String description;
  String category;
  String timeStamp;
  String productSizes;
  List<dynamic> productImages;
  // CHANGE TYPE TO PRODUCT_IMAGE ONCE IMAGE IS UPLOADED

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

  void mapToUser(Map<dynamic, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.productType = map['prod_type'];
    this.description = map['description'];
    this.category = map['category'];
    this.timeStamp = map['created_at'];
    this.productSizes = map['product_sizes'];
    this.productImages = map['product_images'];
  }
}

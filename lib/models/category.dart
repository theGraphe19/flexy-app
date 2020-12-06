class Category {
  int id;
  String name;
  String image;
  List<dynamic> subCategories;
  Map<String, dynamic> categoryData;

  Category({
    this.id,
    this.name,
    this.image,
    this.subCategories,
    this.categoryData,
  });

  Category.frommap(Map<String, dynamic> map) {
    this.categoryData = map;
    this.id = map['id'];
    this.name = map['category'];
    this.image = map['category_img'];
    this.subCategories = map['subcategories'];
  }
}

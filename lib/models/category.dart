class Category {
  int id;
  String name;
  String image;
  List<dynamic> subCategories;

  Category({
    this.id,
    this.name,
    this.image,
    this.subCategories,
  });

  Category.frommap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['category'];
    this.image = map['category_img'];
    this.subCategories = map['subcategories'];
  }
}

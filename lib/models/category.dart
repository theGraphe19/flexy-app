class Category {
  int id;
  String name;
  String image;

  Category({
    this.id,
    this.name,
    this.image,
  });

  Category.frommap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['category'];
    this.image = map['category_img'];
  }
}

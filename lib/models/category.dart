class Category {
  int id;
  String name;

  Category({
    this.id,
    this.name,
  });

  Category.frommap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['category'];
  }
}

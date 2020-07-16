class ProductColor {
  String color;
  String colorName;
  int quantity;
  int stock;

  ProductColor.fromMap(Map<String, dynamic> map) {
    this.color = map['color'];
    this.colorName = map['color_name'];
    this.quantity = map['quantity'];
    this.stock = int.parse(map['in_stock']);
  }
}

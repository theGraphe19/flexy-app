class ProductColor {
  String color;
  int quantity;
  int stock;

  ProductColor.fromMap(Map<String, dynamic> map) {
    this.color = map['color'];
    this.quantity = map['quantity'];
    this.stock = int.parse(map['in_stock']);
  }
}
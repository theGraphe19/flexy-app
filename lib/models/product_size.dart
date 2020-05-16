class ProductSize {
  String size;
  String quantity;
  String price;
  String inStock;
  bool availability;

  ProductSize({
    this.size,
    this.quantity,
    this.price,
    this.inStock,
    this.availability,
  });

  void mapToProductSize(Map<dynamic, dynamic> map) {
    this.size = map['size'];
    this.quantity = map['quantity'];
    this.price = map['price'];
    this.inStock = map['in_stock'];
    this.availability = map['availability'];
  }
}

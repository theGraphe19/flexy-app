class ProductSize {
  String size;
  int available;
  int price;
  int inStock;
  String colors;

  ProductSize({
    this.size,
    this.available,
    this.price,
    this.inStock,
    this.colors,
  });

  ProductSize.mapToProductSize(Map<dynamic, dynamic> map) {
    this.size = map['size'];
    this.available = int.parse(map['available']);
    this.price = int.parse(map['price']);
    this.inStock = int.parse(map['in_stock']);
    this.colors = map['colors'];
  }
}

import './product_size.dart';

class ProductColor {
  String color;
  String colorName;
  int quantity;
  int stock;
  List<ProductSize> sizes;

  ProductColor.onlyColor({this.color, this.colorName});

  ProductColor.fromMap(Map<String, dynamic> map) {
    if (map['color'] != null) this.color = map['color'];
    this.colorName = map['color_name'];
    this.quantity = map['quantity'];
    this.stock = int.parse(map['in_stock']);
  }

  ProductColor.fromProductMap(Map<dynamic, dynamic> map) {
    if (map['color'] != null) this.color = map['color'];
    this.colorName = map['color_name'];
    this.sizes = [];
    for (var i = 0; i < map['sizes'].length; i++)
      sizes.add(ProductSize.mapToProductSizeFromColors(map['sizes'][i]));
  }
}

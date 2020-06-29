import './product_color.dart';

class ProductSize {
  String size;
  int price;
  List<ProductColor> colors;

  ProductSize({
    this.size,
    this.price,
    this.colors,
  });

  ProductSize.mapToProductSize(Map<dynamic, dynamic> map) {
    this.size = map['size'];
    this.price = int.parse(map['price']);
    this.colors = [];
    for (var i = 0; i < (map['colors']).length; i++) {
      this.colors.add(ProductColor.fromMap(map['colors'][i]));
    }
  }
}

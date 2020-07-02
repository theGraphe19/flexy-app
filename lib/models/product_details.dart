import './product.dart';

class ProductDetails {
  Product product;
  List<Product> relatedProducts;

  ProductDetails({
    this.product,
    this.relatedProducts,
  });

  ProductDetails.mapToProductDetails(Map<dynamic, dynamic> map) {
    this.product = Product.mapToDetails(map['main']);
    relatedProducts = [];
    for (var i = 0; i < map['related'].length; i++)
      relatedProducts.add(Product.mapToDetails(map['related'][i]));
  }
}

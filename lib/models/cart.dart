class Cart {
  int id;
  int userId;
  String userName;
  int productId;
  String productName;
  String productSize;
  String color;
  String colorName;
  int categoryId;
  int quantity;
  int productPrice;
  List<dynamic> productImages;
  DateTime timeStamp;

  Cart({
    this.id,
    this.userId,
    this.userName,
    this.productId,
    this.productName,
    this.productSize,
    this.color,
    this.colorName,
    this.categoryId,
    this.quantity,
    this.productPrice,
    this.productImages,
    this.timeStamp,
  });

  Cart.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.userId = int.parse(map['user_id']);
    this.userName = map['user_name'];
    this.productId = int.parse(map['prod_id']);
    this.productName = map['prod_name'];
    this.productSize = map['prod_size'];
    this.color = map['color'];
    this.colorName = map['color_name'];
    this.categoryId = int.parse(map['category_id'][0]);
    this.quantity = int.parse(map['quantity']);
    this.productPrice = int.parse(map['price(per pc.)']);
    this.productImages = map['product_images'];
    this.timeStamp = DateTime.parse(map['created_at']);
  }
}

class Cart {
  int id;
  int userId;
  String userName;
  int productId;
  String productName;
  String productSize;
  String color;
  int quantity;

  Cart({
    this.id,
    this.userId,
    this.userName,
    this.productId,
    this.productName,
    this.productSize,
    this.color,
    this.quantity,
  });

  Cart.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.userId = int.parse(map['user_id']);
    this.userName = map['user_name'];
    this.productId = int.parse(map['prod_id']);
    this.productName = map['prod_name'];
    this.productSize = map['prod_size'];
    this.color = map['color'];
    this.quantity = int.parse(map['quantity']); 
  }
}

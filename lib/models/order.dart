class Order {
  int id;
  String userId;
  String userName;
  String productId;
  String productName;
  String productSize;
  String quantity;
  String availability;
  int status;

  Order({
    this.id,
    this.userId,
    this.userName,
    this.productId,
    this.productName,
    this.productSize,
    this.quantity,
    this.availability,
    this.status,
  });

  void mapToOrder(Map<dynamic, dynamic> map) {
    this.id = map['id'];
    this.userId = map['user_id'];
    this.userName = map['user_name'];
    this.productId = map['prod_id'];
    this.productName = map['prod_name'];
    this.productSize = map['prod_size'];
    this.quantity = map['quantity'];
    this.availability = map['available'];
    this.status = map['status'];
  }
}

class Bill {
  int id;
  String orderId;
  String productId;
  String userId;
  String billDocument;
  String status;

  Bill({
    this.id,
    this.orderId,
    this.productId,
    this.userId,
    this.billDocument,
    this.status,
  });

  Bill.mapToBill(Map<dynamic, dynamic> map) {
    this.id = map['id'];
    this.orderId = map['order_id'];
    this.productId = map['product_id'];
    this.userId = map['user_id'];
    this.billDocument = map['bill'];
    this.status = map['status'];
  }
}
